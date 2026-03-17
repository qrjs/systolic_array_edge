# 四种数据流资料对照与前端实现评审

更新时间：2026-03-17

## 1. 评审目标

这份文档回答三个问题：

1. `WS / IS / OS / DiP` 这四种数据流在学术和开源实现里通常怎么定义。
2. 当前仓库里的前端 RTL 是否符合这些定义。
3. 当前实现是否已经达到“可作为标准 4x4 GEMM 前端接口使用”的完备程度。

这里的“前端实现”特指仓库中面向标准 GEMM 接口的这四个包装层：

- `ws/src/standard_ws_array_4x4.v`
- `is/src/standard_is_array_4x4.v`
- `os/src/standard_os_array_4x4.v`
- `dip/src/standard_dip_array_4x4.v`

原因很简单：

- 这些模块直接对外暴露“整块矩阵输入/输出”的稳定接口
- 它们对应的 `.txt` 文件驱动验证已经打通
- 旧的 `systolic_array_*.v` 更适合作为内部/历史 mesh 参考，而不是当前仓库里推荐的标准黑盒入口

## 2. 外部资料、开源项目与教程

### 2.1 基础与经典资料

1. H. T. Kung, “Why Systolic Architectures?”, IEEE Computer, 1982  
   链接：<https://cir.nii.ac.jp/crid/1360855571261536896>  
   作用：给出脉动阵列的基本思想，即把简单 PE 以规则拓扑互联，通过时间和空间上的同步移动实现高复用计算。

2. Google TPU 论文  
   链接：<https://research.google/pubs/in-datacenter-performance-analysis-of-a-tensor-processing-unit/>  
   作用：给出工业界最著名的矩阵乘专用脉动阵列案例。TPU 的矩阵乘单元通常被视作典型 `WS` 参考。

### 2.2 数据流分类与语义资料

3. Eyeriss 项目主页  
   链接：<https://www.mit.edu/~sze/eyeriss.html>  
   作用：虽然 Eyeriss 主打的是 `Row-Stationary`，但它是理解各种 stationary dataflow 取舍的经典入口。

4. Eyeriss 论文公开稿  
   链接：<https://dspace.mit.edu/bitstream/handle/1721.1/101151/eyeriss_isscc_2016.pdf>  
   作用：说明“stationary”本质上是在局部存储里尽量固定某一类数据，以减少外部/跨层数据搬运。

5. Reconfigurable Architecture and Dataflow for Memory Traffic Minimization of CNNs Computation  
   链接：<https://pmc.ncbi.nlm.nih.gov/articles/PMC8624143/>  
   作用：明确给出 `IS / WS / OS` 的高层定义：  
   `IS` 固定输入，`WS` 固定权重，`OS` 固定部分和/输出。

6. INCA 相关论文索引页  
   链接：<https://scholars.duke.edu/individual/pub1572593>  
   作用：给 `IS` 提供较新的学术参考，说明输入驻留并非只是概念，也是一类可独立成立的数据流设计选择。

7. DiP: A Scalable, Energy-Efficient Systolic Array for Matrix Multiplication Acceleration  
   链接：<https://arxiv.org/abs/2412.09709>  
   作用：这是当前仓库 `DiP` 的直接论文来源，明确给出 diagonal-input 和 permutated weight-stationary 的设计思想。

### 2.3 可对照的开源项目

8. Gemmini  
   链接：<https://github.com/ucb-bar/gemmini>  
   作用：Gemmini 同时支持 `OS / WS`，README 对两者的输入、预加载和累加器差异解释得很清楚。

9. Gemmini 文档（Chipyard）  
   链接：<https://chipyard.readthedocs.io/en/stable/Generators/Gemmini.html>  
   作用：比只读源码更容易看清整个架构、tile/mesh 组织和 `WS / OS` 模式区别。

10. SAURIA  
   链接：<https://github.com/bsc-loca/sauria>  
   链接：<https://github-wiki-see.page/m/bsc-loca/sauria/wiki/Systolic-Array>  
   作用：一个较完整的 `OS` 开源实现，文档中明确写到激活和权重流动方向，以及本地累加器的角色。

11. AutoSA  
    链接：<https://github.com/UCLA-VAST/AutoSA>  
    作用：虽然它不只是手写 RTL 示例，但对理解“循环变换如何导出 systolic array”非常有帮助。

12. SCALE-Sim  
    链接：<https://github.com/scalesim-project/SCALE-Sim>  
    作用：更偏建模与性能分析，不是 RTL 实现，但很适合帮助初学者建立数据流、带宽和阵列规模之间的关系。

13. kaggar11/systolic_4x4arr  
    链接：<https://github.com/kaggar11/systolic_4x4arr>  
    作用：一个简洁的 `WS` 4x4 Verilog 项目，可作为“权重预加载、输入流动、结果读出”的工程级参考。

14. hngenc/systolic-array  
    链接：<https://github.com/hngenc/systolic-array>  
    作用：不是固定某一种 dataflow 的完整 IP，而是展示了如何由时空变换自动生成 systolic array 和 I/O 调度规律，对理解数据何时进入/流出很有帮助。

### 2.4 适合入门的教程与文档

15. AutoSA Documentation  
    链接：<https://autosa.readthedocs.io/en/latest/>  
    作用：适合从调度、阵列映射和 I/O 构造的角度系统理解 systolic array。

16. SCALE-Sim Documentation  
    链接：<https://scale-sim-project.readthedocs.io/>  
    作用：适合在不先深入 RTL 的情况下，先理解数据流和带宽约束如何影响性能。

17. SAURIA Wiki: Systolic Array  
    链接：<https://github-wiki-see.page/m/bsc-loca/sauria/wiki/Systolic-Array>  
    作用：对 `OS` 风格阵列和输入/权重传播方向的解释很适合新手。

18. 仓库内新手导读  
    链接：`docs/脉动阵列零基础上手与仓库导读_CN.md`  
    作用：把“概念 -> 命令 -> RTL -> 外部资料”的学习顺序串起来，适合第一次进入本仓库时先看。

## 3. 当前仓库采用的判断标准

为了避免“RTL 和 testbench 一起错但错得一致”，当前评审不只看主 testbench，还看两层证据：

1. 结构语义是否与外部资料一致  
   也就是：谁静止、谁流动、部分和往哪边传播、结果在哪里完成。

2. 标准 GEMM 黑盒接口是否已经成立  
   也就是：给定 `A` 和 `B`，是否能稳定得到完整 `C = A x B`，而不是只得到阵列内部快照或某种专用时序约定下的值。

当前最有说服力的本地验证是 `.txt` 文件驱动套件：

- `make ws-txt`
- `make is-txt`
- `make os-txt`
- `make dip-txt`

2026-03-17 当天实际重跑结果：

- `WS`：`268 / 268` 通过
- `IS`：`268 / 268` 通过
- `OS`：`268 / 268` 通过
- `DiP`：`268 / 268` 通过

## 4. 逐种数据流评审

### 4.1 WS

对照资料中的核心语义：

- 权重尽量静止在 PE 中
- 输入激活在阵列中流动
- 部分和继续传播并在输出侧收敛

当前仓库中最符合这个语义的是 `ws/src/standard_ws_array_4x4.v`：

- `stored_weight` 保存在阵列内部，只在 `weight_row_valid` 时更新
- `data_pipe` 按行从左向右传播
- `psum_pipe` 按列从上向下传播
- 最后一行完成的结果会被写回 `result_buf`

评审结论：

- 从结构语义看，`WS` 是正确的
- 从标准 GEMM 黑盒接口看，`WS` 也是完备的
- 当前推荐把 `standard_ws_array_4x4.v` 视作仓库里的正式 `WS` 前端入口

补充说明：

- 旧的 `ws/src/systolic_array_4x4.v` 仍然有价值，但它更像低层 mesh/握手实现
- 如果外部用户只是想拿一个稳定的矩阵乘前端，应该优先看标准 wrapper，而不是旧 mesh 顶层

### 4.2 IS

对照资料中的核心语义：

- 输入/激活驻留在本地
- 权重流过阵列
- 部分和继续传播并在另一维收敛

当前仓库中最符合这个语义的是 `is/src/standard_is_array_4x4.v`：

- `stored_input` 是静止状态
- `weight_pipe` 从上到下传播
- `psum_pipe` 从左到右传播
- 最后一列把完成结果写入 `result_buf`

这和 `IS` 的本质语义是一致的：固定输入、流动权重、传播部分和。

评审结论：

- 从结构语义看，`IS` 是正确的
- 从标准 GEMM 黑盒接口看，`IS` 也是完备的
- 当前 `.txt` 套件全通过，说明这个 wrapper 已经不是“概念正确但接口不稳定”的状态

补充说明：

- 旧的 `is/src/systolic_array_is_4x4.v` 还保留了一些偏工程化/历史化的接口组织方式
- 现在推荐文档和回归都应当围绕 `standard_is_array_4x4.v` 展开

### 4.3 OS

对照资料中的核心语义：

- 输出或部分和驻留在 PE 内部
- A、B 两类操作数在阵列中流动
- 当每个 PE 完成全部乘加后，再读出最终结果

当前仓库中最符合这个语义的是 `os/src/standard_os_array_4x4.v`：

- `acc` 在每个 PE 本地保存
- `a_pipe` 沿行传播
- `b_pipe` 沿列传播
- `accum_count` 记录每个 PE 已完成多少次 MAC
- 全部单元完成后，`result_valid` 才拉高

这和 SAURIA、Gemmini 等公开资料中对 `OS` 的描述是吻合的。

评审结论：

- 从结构语义看，`OS` 是正确的
- 从标准 GEMM 黑盒接口看，`OS` 也是完备的
- 当前 `.txt` 套件全通过，说明它已经不是“只是阵列快照接口”

### 4.4 DiP

对照论文中的核心语义：

- 输入沿对角方向传播
- 通过边界绕接实现 diagonal movement
- 权重按软件预旋转布局注入
- 相比传统 `WS`，减少同步 FIFO 并提高利用率

当前仓库中最符合这个语义的是两层组合：

- `dip/src/systolic_array_dip_4x4.v`
- `dip/src/standard_dip_array_4x4.v`

其中：

- `systolic_array_dip_4x4.v` 里用上一行循环右移一列的方式连接到下一行
- `standard_dip_array_4x4.v` 负责把逐行输出重新收成标准矩阵，并在输入流结束后自动补一拍 drain
- 仓库说明里采用的权重旋转公式为  
  `W_rot[i][j] = W[(i + j) mod N][j]`

评审结论：

- 从结构语义看，`DiP` 与论文描述高度一致
- 从标准 GEMM 黑盒接口看，`DiP` 也是完备的
- `.txt` 套件全通过，说明不仅“方向对”，输出矩阵语义也成立

## 5. 综合判断

### 5.1 “是否正确”

如果把“正确”定义为：

- 本地静止/流动对象与数据流定义一致
- 矩阵乘输出结果与 `A x B` 一致

那么当前仓库中四种数据流的标准前端实现都可以判定为：

- `WS`：正确
- `IS`：正确
- `OS`：正确
- `DiP`：正确

### 5.2 “是否完备”

如果把“完备”定义为：

- 不只是 PE 内部概念正确
- 而是已经对外提供稳定的标准 GEMM 黑盒接口
- 并且这个接口已经被较大规模文件向量集验证过

那么当前四种标准 wrapper 也都可以判定为：

- `WS`：完备
- `IS`：完备
- `OS`：完备
- `DiP`：完备

## 6. 仍然需要保留的边界条件

上面的“正确且完备”不是说后面完全不需要继续改进，而是说：

- 在当前 4x4、signed GEMM、文件向量回归的验证口径下，它们已经成立

仍需保留的边界条件有：

1. 当前结论主要对应 `standard_*_array_4x4.v` 这四个标准包装层  
   不建议再把历史 mesh 顶层当成仓库级“唯一推荐接口”。

2. 目前验证口径是 4x4  
   如果以后扩到更大阵列尺寸，还需要重新确认 token 排布、flush、drain 和输出重排是否保持一致。

3. 当前结论以功能正确性为主  
   不等于已经完成形式验证、时序闭合验证或跨工艺综合对照。

4. `DiP` 的论文来自特定设计背景  
   当前仓库实现保留了其核心思想，但不声称每个微结构细节都与论文实现逐门级一一对应。

## 7. 当前最推荐的结论口径

如果后面需要在中文文档、论文草稿或对外说明里用一句话总结，建议直接写：

> 当前仓库中的 `WS / IS / OS / DiP` 四种数据流，已经分别通过结构语义检查与
> `268` 组 `.txt` 文件驱动 GEMM 黑盒回归；其中 `DiP` 直接对照了论文语义，
> `WS / IS / OS` 则对照了 stationary dataflow 的经典定义与开源实现经验。
> 因而在当前 `4x4` 前端 RTL 范围内，可认为四种数据流都已正确实现并具备完备的标准接口。

## 8. 后续建议

下一步最值得做的事情不是继续纠结“这四种数据流算不算成立”，而是：

1. 把这份结论同步到各子项目 README
2. 增加 `VCS txt` 套件统计摘要，形成 `iverilog + VCS` 双口径文档
3. 如果未来要写论文或答辩材料，再补一张“WS / IS / OS / DiP 数据驻留与流动方向对照图”
