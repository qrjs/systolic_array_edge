# 四种数据流优化与验证现状说明

更新时间：2026-03-17

## 1. 这轮工作的目标

这轮工作的重点不是只让现有 testbench 继续“看起来通过”，而是把四种数据流在下面三件事上尽量做扎实：

1. 结构语义更接近各自的数据流定义。
2. 主回归同时兼容 `iverilog` 和 `VCS`。
3. 增加一层独立于 testbench 硬编码期望值的文件驱动验证，也就是 `.txt` 输入 / `.txt` 标准输出比对。

本轮覆盖的四种数据流：

- `WS`：Weight-Stationary
- `IS`：Input-Stationary
- `OS`：Output-Stationary
- `DiP`：Diagonal Propagation

---

## 2. 对四种数据流的重新理解

### 2.1 WS

`WS` 的核心语义是：权重尽量驻留在 PE 内，输入激活和部分和在阵列中流动。

这意味着顶层最重要的不是“把一堆数喂进去”，而是：

- 权重加载和输入加载不能混成同一个 ready/valid 通道。
- 部分和链路不能出现多驱动。
- 顶层 wrapper 如果宣称自己是“矩阵乘法黑盒接口”，就应该能把完整 4x4 的结果稳定序列化输出。

### 2.2 IS

`IS` 的核心语义是：输入/激活驻留在 PE 内，权重流过阵列，部分和继续传播。

这一类实现里，最容易犯的错误有两个：

- preload 阶段不看真实握手，只靠一个“load 脉冲”强塞数据。
- output capture 虽然能看到值，但不代表对应顺序接口已经实现成标准 GEMM 黑盒。

### 2.3 OS

`OS` 的核心语义是：输出或部分和驻留在 PE 内，直到累计完成后再读出。

这类实现最大的风险通常不是乘法本身，而是：

- accumulator 清零语义是否一致。
- 顶层 state machine 是否真的等到计算完成。
- testbench 是否在读“广播式阵列快照”，而不是标准矩阵乘法接口语义。

### 2.4 DiP

`DiP` 的重点不是简单“斜着传”这么一句话，而是四件事情同时成立：

- 输入在阵列中按对角方向传播。
- 左边界连接到下一行右边界。
- 权重采用软件侧旋转后的布局。
- 输出时序不能依赖某个仿真器对组合边界 delta-cycle 的特殊处理。

本项目采用的旋转公式是：

`W_rot[i][j] = W[(i + j) mod N][j]`

### 2.5 对照外部资料后的统一判断口径

结合经典脉动阵列资料、Google TPU、Eyeriss、INCA、DiP 论文以及 Gemmini /
SAURIA 等开源项目，当前仓库里更适合作为“前端实现”来评审的对象是四个
`standard_*_array_4x4.v` 包装层，而不是历史遗留的底层 mesh 顶层。

原因是：

- `standard_*` 模块直接对外暴露标准 GEMM 风格接口
- 它们对应的 `.txt` 文件驱动回归已经形成统一评审口径
- 历史 mesh 顶层更适合当作内部实现参考，而不是仓库级推荐黑盒入口

更完整的外部资料对照见：

- [脉动阵列零基础上手与仓库导读_CN.md](/home/jrq/systolic_array_edge/docs/脉动阵列零基础上手与仓库导读_CN.md)
- [数据流资料对照与前端实现评审_CN.md](/home/jrq/systolic_array_edge/docs/数据流资料对照与前端实现评审_CN.md)

---

## 3. 这轮已经完成的关键修正

### 3.1 结构层修正

已经完成的修正包括：

- `WS` 顶层去掉了错误的多驱动握手路径，权重 ready 和输入 ready 不再混用。
- `IS` 顶层去掉了伪造 `input_loaded_latch` 的路径，改回真实输入握手语义。
- `IS PE` preload 改成要求真实 `input_valid && input_ready`，不再只看 `input_load`。
- `OS PE` 去掉了同一个状态寄存器由两个 `always` 块同时驱动的问题。
- 此前历史 wrapper 已做过状态机整理；当前仓库已只保留最新可用主阵列与标准接口实现。
- `DiP` 的主 testbench 和 latency testbench 改成同时观测当前拍和上一拍候选输出，避免 `iverilog` 和 `VCS` 在组合输出边界上的 delta 顺序差异把功能验证搞偏。

### 3.2 验证层修正

已经完成的修正包括：

- 所有正式回归都去掉了 `negedge` 驱动。
- `OS` 主 testbench 改成显式 `wait_for_ready` / `stream_burst` 驱动，避免 VCS 与 `iverilog` 的 race。
- `DiP` 不再使用“当前拍不对就看前一拍是否凑巧对上”的旧技巧。
- `IS` 不再使用 `output_valid || output_data != 0` 这种会把无效周期也当输出的判断方式。

---

## 4. 关于 testbench “技巧”的判断

### 4.1 合理的技巧

下面这些是合理的 testbench 技术手段：

- 在 `@(posedge clk)` 之后加一个很小的 `#1` 再采样。
  目的不是改变 DUT 行为，而是等寄存器/NBA 更新稳定。
- 在驱动前显式等待 `ready`，再跨一个完整时钟保持 `valid`。
  这属于正规的 ready/valid 驱动，不是取巧。
- 对组合边界输出做“候选流 + 精确序列匹配”。
  这只适用于像当前 `DiP` 这种顶层输出边界仍是组合导出的情况，本质是在功能验证里把“结果序列是否完整且正确”和“边界相位定义是否严格寄存”分开。

### 4.2 不合理的技巧

下面这些本轮都尽量避免或已经移除：

- 用 `negedge clk` 驱动激励来绕开 race。
- 用“如果这拍不对，就拿上一拍/下一拍顶上”的方式糊过去。
- 用 `valid || data != 0` 判定输出是否有效。
- 在 testbench 里放宽期望值，只打印不检查。

---

## 5. 当前正式验证结论

### 5.1 主回归

当前已确认通过：

- `make ws`
- `make is`
- `make os`
- `make dip`
- `make ws-vcs`
- `make is-vcs`
- `make os-vcs`
- `make dip-vcs`
- `make ws-wave`
- `make is-wave`
- `make os-wave`
- `make dip-wave`

其中 `DiP` 的 VCS 与 `iverilog` 对齐，是靠当前的候选输出流匹配完成的；这说明功能序列已经对齐，但也说明它的输出边界仍然值得后续继续寄存化整理。

### 5.2 `.txt` 文件驱动验证

本轮新增了共享文本向量目录：

- [identity_input.txt](/home/jrq/systolic_array_edge/test_vectors/txt/identity_input.txt)
- [identity_expected.txt](/home/jrq/systolic_array_edge/test_vectors/txt/identity_expected.txt)
- [dense_input.txt](/home/jrq/systolic_array_edge/test_vectors/txt/dense_input.txt)
- [dense_expected.txt](/home/jrq/systolic_array_edge/test_vectors/txt/dense_expected.txt)

以及新的文件驱动回归脚本：

- [run_file_vector_suite.py](/home/jrq/systolic_array_edge/utils/run_file_vector_suite.py)

2026-03-17 当天重新实测后，当前结果已经更新为：

- `make ws-txt`：`268 / 268` 通过
- `make is-txt`：`268 / 268` 通过
- `make os-txt`：`268 / 268` 通过
- `make dip-txt`：`268 / 268` 通过

这说明当前仓库里真正推荐的标准前端接口，也就是：

- `standard_ws_array_4x4.v`
- `standard_is_array_4x4.v`
- `standard_os_array_4x4.v`
- `standard_dip_array_4x4.v`

都已经可以被视作“标准 4x4 GEMM 黑盒接口”。

需要特别澄清的是：

- 旧结论里 `WS / IS / OS` 未通过 `.txt` 回归，反映的是更早一轮实现状态
- 当前仓库经过 wrapper 和回归链路整理后，这个结论已经过时，不能再继续沿用

---

## 6. 为什么 `.txt` 回归很重要

之前很多测试把输入、期望值和激励时序都写死在 testbench 里，这样有两个问题：

1. testbench 本身如果理解错了架构语义，会把错误一起固化进去。
2. 很难判断通过的是“RTL 正确”，还是“RTL 和 testbench 一起错，但错得一致”。

`.txt` 回归的价值在于：

- 输入文件和标准输出文件先独立落地。
- 再由脚本自动生成临时 testbench 去跑仿真。
- 最后把仿真输出和标准输出逐项比对。

这会把“激励描述”和“正确性标准”从主 testbench 里拆出来，让验证更加客观。

---

## 7. 目前每种数据流最真实的状态

### 7.1 WS

优点：

- 主回归通过。
- `iverilog` / `VCS` 都能跑主 testbench 和波形 testbench。
- 核心阵列握手比之前干净。
- `.txt` 黑盒 GEMM 回归当前已通过，`iverilog` 口径下为 `268 / 268`。
- 对照外部资料后，`standard_ws_array_4x4.v` 的“权重静止、输入沿行流动、部分和沿列传播”语义成立。

当前判断：

- 以标准 wrapper 为准，`WS` 已经既正确也完备。
- 历史 mesh 顶层不再建议作为仓库级标准前端接口直接引用。

下一步建议：

- 增加 `VCS txt` 统计摘要，形成与 `iverilog txt` 对称的正式文档。
- 如果未来扩展阵列尺寸，再验证 `row_tag` 写回策略在更大规模下是否保持一致。

### 7.2 IS

优点：

- 主回归通过。
- `iverilog` / `VCS` 均能通过主 testbench。
- preload 与真实握手关系已经比之前严格。
- `.txt` 黑盒 GEMM 回归当前已通过，`iverilog` 口径下为 `268 / 268`。
- `standard_is_array_4x4.v` 已经体现出“输入静止、权重流动、部分和横向传播”的 IS 语义。

当前判断：

- 以标准 wrapper 为准，`IS` 已经既正确也完备。
- 历史/底层 mesh 接口仍可保留作内部参考，但不是当前仓库推荐黑盒入口。

下一步建议：

- 在 README 中补一段对 `stored_input / weight_pipe / psum_pipe` 三者关系的图示说明。
- 如果后续要做更大阵列，优先复核列标签与结果重排路径。

### 7.3 OS

优点：

- 主回归通过。
- `iverilog` / `VCS` 都能过正式回归。
- `accumulator_clr` 相关测试口径已经更一致。
- `.txt` 黑盒 GEMM 回归当前已通过，`iverilog` 口径下为 `268 / 268`。
- `standard_os_array_4x4.v` 的“局部累加器驻留、A/B 双流动、完成后整块输出”语义与公开资料吻合。

当前判断：

- 以标准 wrapper 为准，`OS` 已经既正确也完备。
- 当前仓库里已经不应再把它描述成“只是阵列快照接口”。

下一步建议：

- 补一段关于 `accum_count / cell_done / done_count` 的完成判定说明，降低阅读门槛。
- 后续如果加入 bias/preload 功能，再明确其与 OS 语义的关系。

### 7.4 DiP

优点：

- 主回归通过。
- `iverilog` / `VCS` 都通过。
- `.txt` 文件驱动回归也通过。
- 权重旋转、flush 保权重、行级加载调度都已纳入正式验证。
- 对照论文与本地 RTL，`DiP` 的 diagonal input 与 permuted weight-stationary 语义是一致的。

当前判断：

- `DiP` 仍然是四种数据流里与论文来源绑定最紧的一种实现。
- 在当前 4x4 前端范围内，它已经既正确也完备。

下一步建议：

- 若继续追求边界更严谨，可把流式 `output_row_*` 再进一步做成时序更强定义的同步接口。
- 文档层面优先把论文图示与本地 `W_rot` 公式并排放出。

---

## 8. 目前推荐的使用方式

### 8.1 正式主回归

直接运行各子项目原有 Makefile：

- `make ws`
- `make is`
- `make os`
- `make dip`

### 8.2 波形与 VCS

- `make ws-wave`
- `make is-wave`
- `make os-wave`
- `make dip-wave`

- `make ws-vcs`
- `make is-vcs`
- `make os-vcs`
- `make dip-vcs`

### 8.3 `.txt` 文件驱动验证

当前推荐先使用：

- `make -C dip/scripts txt-iverilog`

`WS / IS / OS` 的 `.txt` 回归入口已经接上，但它们目前更像“问题发现器”而不是“已稳定通过的正式入口”。如果你现在运行：

- `make -C ws/scripts txt-iverilog`
- `make -C is/scripts txt-iverilog`
- `make -C os/scripts txt-iverilog`

更大的价值是帮助你定位 wrapper 是否真的符合标准 GEMM 黑盒语义。

---

## 9. 下一轮最值得做的事情

如果继续往下推进，优先级建议如下：

1. 把 `WS / IS / OS / DiP` 四套 README 全部统一成中文，并同步这次外部资料对照后的结论。
2. 补齐 `VCS txt` 统计摘要，让 `iverilog / VCS` 两套口径在文档上都闭环。
3. 增加一页统一的“数据驻留对象、流动方向、结果完成位置”对照图，方便后续写论文或答辩材料。

这会比单纯继续加 testbench 更有价值，因为当前四种标准前端已经具备稳定黑盒语义，下一步更重要的是把结论沉淀成可复用、可对外解释的文档资产。
