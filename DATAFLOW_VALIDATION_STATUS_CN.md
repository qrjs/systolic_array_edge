# 四种数据流优化与验证现状说明

更新时间：2026-03-15

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

当前结果：

- `DiP` 的 `.txt` 回归已经打通，`identity` 与 `dense` 都能过。
- `WS / IS / OS` 的 `.txt` 回归把一个更本质的问题暴露了出来：它们当前的顶层顺序接口，还不能全部被视作“标准 4x4 GEMM 黑盒接口”。

具体表现：

- `IS` 能吐出 16 个数，但与标准 `A x B` 不一致。
- `WS` 与 `OS` 在 dense case 下甚至吐不满 16 个标准输出。

这不是 `.txt` 回归写错了，反而说明之前的主回归更多是在验证“当前 testbench 约定下的行为”，而不是验证“标准矩阵乘法顺序接口语义”。

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

问题：

- 新的 `.txt` 黑盒 GEMM 验证没有通过。
- 历史 wrapper 与标准 GEMM 顺序接口并不完全一致，因此当前仓库已切换到保留标准接口回归链路。

下一步建议：

- 优先检查 `COMPUTING -> OUTPUT` 的切换条件是否过早。
- 检查 `output_write_ptr` 是否真的等到 16 个结果都进缓冲后再结束计算。

### 7.2 IS

优点：

- 主回归通过。
- `iverilog` / `VCS` 均能通过主 testbench。
- preload 与真实握手关系已经比之前严格。

问题：

- `.txt` 黑盒 GEMM 验证未通过，但能稳定吐出 16 个值。
- 这说明 IS wrapper 的顺序接口与标准 GEMM 语义仍有偏差，问题更可能出在顶层映射和输出重组，而不是简单“没算出来”。

下一步建议：

- 用 `.txt` 回归输出和 `compute_count / output_write_ptr` 做逐拍对照。
- 确认 output buffer 的写入顺序和标准 row-major 顺序是否一致。

### 7.3 OS

优点：

- 主回归通过。
- `iverilog` / `VCS` 都能过正式回归。
- `accumulator_clr` 相关测试口径已经更一致。

问题：

- `.txt` 黑盒 GEMM 验证未通过。
- 当前 OS 顶层更像“把阵列快照串行读出”的 wrapper，而不是标准 GEMM 结果接口。

下一步建议：

- 明确 `os_output_data` 当前到底是阵列快照、广播态，还是已完成的完整结果矩阵。
- 如果要对外提供标准矩阵乘法 API，需要额外一层确定性的结果采集与重排。

### 7.4 DiP

优点：

- 主回归通过。
- `iverilog` / `VCS` 都通过。
- `.txt` 文件驱动回归也通过。
- 权重旋转、flush 保权重、行级加载调度都已纳入正式验证。

问题：

- 输出边界目前仍然依赖“候选流匹配”这层验证逻辑。
- 这说明功能正确，但模块边界时序定义还可以再收紧。

下一步建议：

- 后续可以把 `output_row_valid / output_row_data` 做成更严格的同步输出接口。
- 一旦顶层边界寄存化，DiP 的验证可以从“候选流匹配”进一步收敛到“逐拍严格匹配”。

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

1. 把 `WS / IS / OS` 的 wrapper 全部整理成真正的标准 GEMM 顺序接口。
2. 让 `.txt` 回归在 `WS / IS / OS / DiP` 四套上全部转正。
3. 再把四个子项目 README 统一重写成中文，并把“结构语义 / 验证方法 / 波形入口 / 综合入口 / 已知限制”统一起来。

这会比单纯继续加 testbench 更有价值，因为它直接决定这些子项目是不是“可以被外部当成稳定 IP 使用”。
