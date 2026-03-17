# 脉动阵列零基础上手与仓库导读

更新时间：2026-03-17

## 1. 这份文档适合谁

如果你还没有系统学过脉动阵列，但想尽快看懂本仓库里的 `WS / IS / OS / DiP`
四种数据流实现，并且能自己跑通仿真、看波形、做文件回归，这份文档就是给你准备的。

你不需要先掌握很重的体系结构背景，建议先把这里读一遍，再去看具体 RTL。

---

## 2. 先建立一个最小心智模型

### 2.1 什么是脉动阵列

脉动阵列（Systolic Array）可以先粗略理解成：

- 把很多个小处理单元 `PE` 按规则排成网格
- 每个 `PE` 只做简单而重复的事情，比如一次乘加 `MAC`
- 数据不是每次都回到大存储器，而是在相邻 `PE` 之间有节奏地流动

对矩阵乘法 `C = A x B` 来说，这样做的价值很直接：

- `A`、`B`、部分和 `psum` 可以在阵列里复用
- 访存压力变小
- 计算和通信节奏很规则，适合硬件流水化

### 2.2 什么是 PE

你可以先把 `PE` 想成一个很小的计算单元，通常包含：

- 乘法器
- 加法器
- 若干寄存器
- 向邻居传递数据的通路

本仓库里不同架构的 `PE` 实现在：

- `ws/src/pe.v`
- `is/src/is_pe.v`
- `os/src/os_pe.v`
- `dip/src/dip_pe.v`

### 2.3 什么叫 “stationary”

很多新手第一次卡住的点就在这里。

`stationary` 不是说“别的数据不动”，而是说：

- 你刻意让某一类数据尽量待在本地寄存器或局部存储里
- 以换取更少的数据搬运和更高的复用

所以四种数据流最核心的区别，不是“都在算矩阵乘法，有什么不同”，而是：

- 到底是哪一类数据被优先固定下来
- 另外两类数据如何传播
- 部分和最终在哪里完成

---

## 3. 四种数据流怎么理解

### 3.1 WS: Weight-Stationary

关键想法：

- 权重尽量驻留在 `PE`
- 输入激活在阵列里流动
- 部分和继续传播并在输出侧收敛

适合先问自己的问题：

- 权重是不是先装进去，再复用很多次？
- 输入是不是像流一样穿过阵列？

本仓库推荐入口：

- `ws/src/standard_ws_array_4x4.v`

内部低层阵列：

- `ws/src/systolic_array_4x4.v`

### 3.2 IS: Input-Stationary

关键想法：

- 输入尽量驻留在 `PE`
- 权重在阵列里流动
- 部分和在另一维传播

适合先问自己的问题：

- 输入是否被 preload 或保持在本地？
- 权重是否作为流经数据使用？

本仓库推荐入口：

- `is/src/standard_is_array_4x4.v`

内部低层阵列：

- `is/src/systolic_array_is_4x4.v`

### 3.3 OS: Output-Stationary

关键想法：

- 输出或部分和留在 `PE` 的本地累加器里
- `A` 和 `B` 都在阵列中传播
- 等每个 `PE` 完成全部累加后再统一读出结果

适合先问自己的问题：

- 本地累加器是否真的在 `PE` 内驻留？
- 输出是不是等所有乘加完成后才有效？

本仓库推荐入口：

- `os/src/standard_os_array_4x4.v`

内部低层阵列：

- `os/src/systolic_array_os_4x4.v`

### 3.4 DiP: Diagonal-Input and Permutated Weight-Stationary

关键想法：

- 输入按对角方向传播
- 行与行之间有绕接关系
- 权重按预旋转后的布局注入
- 它保留了类似 `WS` 的高复用思路，但改变了数据进入阵列的几何方式

本仓库推荐入口：

- `dip/src/standard_dip_array_4x4.v`

内部低层阵列：

- `dip/src/systolic_array_dip_4x4.v`

---

## 4. 这个仓库里真正该先看哪些文件

如果你是第一次接触本项目，最推荐的阅读顺序是：

1. 根入口和命令体系
   - `README.md`
   - `Makefile`
   - `scripts/arch_common.mk`
2. 四个标准 wrapper
   - `ws/src/standard_ws_array_4x4.v`
   - `is/src/standard_is_array_4x4.v`
   - `os/src/standard_os_array_4x4.v`
   - `dip/src/standard_dip_array_4x4.v`
3. 各架构的低层阵列与 PE
   - `ws/src/pe.v`
   - `is/src/is_pe.v`
   - `os/src/os_pe.v`
   - `dip/src/dip_pe.v`
4. 文件回归 testbench
   - `ws/tb/standard_ws_file_tb.sv`
   - `is/tb/standard_is_file_tb.sv`
   - `os/tb/standard_os_file_tb.sv`
   - `dip/tb/standard_dip_file_tb.sv`
5. 统一文本向量
   - `test_vectors/txt`

最重要的判断原则是：

- 学语义时先看 `standard_*`
- 学实现细节时再看 `systolic_array_*` 和 `*_pe.v`

因为当前仓库里真正对外推荐的前端黑盒接口，是四个 `standard_*_array_4x4.v`。

---

## 5. 第一次上手建议这样做

### 5.1 先跑最简单的功能仿真

在仓库根目录：

```bash
make ws
make is
make os
make dip
```

这一步的目的不是追求“我已经完全懂了”，而是先确认：

- 环境能跑
- 四个架构当前都能过主功能仿真

### 5.2 再跑文件向量回归

```bash
make ws-txt
make is-txt
make os-txt
make dip-txt
```

这一层比“写死在 testbench 里的例子”更重要，因为它把：

- 输入
- 期望输出
- 仿真执行

拆成了更独立的验证流程，更适合判断标准 GEMM 黑盒接口是否成立。

### 5.3 然后看波形

```bash
make ws-wave
make is-wave
make os-wave
make dip-wave
```

你第一次看波形时，不要试图一次看懂所有信号。更建议只抓三件事：

- 哪一类数据先进入阵列
- 哪一类数据在本地保持
- 结果什么时候开始有效

### 5.4 最后再去看 RTL

建议先看四个 `standard_*_array_4x4.v`，因为它们最贴近你对“矩阵乘法黑盒”的直觉。

---

## 6. 这四种架构在本仓库里的当前结论

基于当前本地回归和资料对照，推荐你把下面四个模块视作正式前端入口：

- `ws/src/standard_ws_array_4x4.v`
- `is/src/standard_is_array_4x4.v`
- `os/src/standard_os_array_4x4.v`
- `dip/src/standard_dip_array_4x4.v`

2026-03-17 当天重新实测的 `.txt` 文件驱动黑盒回归结果为：

- `WS`: `268 / 268`
- `IS`: `268 / 268`
- `OS`: `268 / 268`
- `DiP`: `268 / 268`

这意味着在当前 `4x4`、signed GEMM、文件向量验证口径下，这四种标准 wrapper
已经可以视作：

- 结构语义正确
- 标准 GEMM 接口完备

---

## 7. 常见误区

### 7.1 “stationary 就是别的数据完全不动”

不是。`stationary` 的意思是“优先固定某类数据以提高复用”，不是说其它数据都停止传播。

### 7.2 “只要 testbench 过了就说明架构定义一定对”

也不是。一个 testbench 可能和 RTL 一起把错误固化进去，所以本仓库才特别强调：

- 主 testbench
- 文件驱动回归
- 外部资料语义对照

这三层一起看。

### 7.3 “低层 mesh 顶层一定比标准 wrapper 更正式”

不一定。对外使用时，通常更应该优先看能稳定提供标准矩阵输入/输出接口的 wrapper。
低层阵列更多用于研究内部时序、信号传播和 ASIC handoff。

---

## 8. 外部资料怎么选

下面按“先学概念、再看工程、最后看工具”的顺序组织。

### 8.1 入门必读论文和经典资料

1. H. T. Kung, “Why Systolic Architectures?”, IEEE Computer, 1982  
   链接：<https://cir.nii.ac.jp/crid/1360855571261536896>  
   为什么看：这是理解“为什么要让数据按节奏在阵列里流动”的经典原点。

2. Google TPU 论文  
   链接：<https://research.google/pubs/in-datacenter-performance-analysis-of-a-tensor-processing-unit/>  
   为什么看：给你一个工业界大规模矩阵乘脉动阵列的直观参照。

3. Eyeriss 项目主页  
   链接：<https://www.mit.edu/~sze/eyeriss.html>  
   为什么看：帮助理解“数据流优化”为什么不是只谈算力，还和数据搬运强相关。

4. Eyeriss 论文公开稿  
   链接：<https://dspace.mit.edu/bitstream/handle/1721.1/101151/eyeriss_isscc_2016.pdf>  
   为什么看：适合建立 `stationary`、局部复用、能效之间的联系。

### 8.2 与四种数据流直接相关的论文

5. Reconfigurable Architecture and Dataflow for Memory Traffic Minimization of CNNs Computation  
   链接：<https://pmc.ncbi.nlm.nih.gov/articles/PMC8624143/>  
   为什么看：对 `WS / IS / OS` 的高层定义很直白，适合做分类参照。

6. INCA: Input-stationary Dataflow for CNN Inference Acceleration  
   链接：<https://scholars.duke.edu/individual/pub1572593>  
   为什么看：给 `IS` 找到更现代、更专门的研究背景。

7. DiP: A Scalable, Energy-Efficient Systolic Array for Matrix Multiplication Acceleration  
   链接：<https://arxiv.org/abs/2412.09709>  
   为什么看：这是本仓库 `DiP` 的直接论文来源。

### 8.3 值得直接看代码的开源实现

8. Gemmini  
   链接：<https://github.com/ucb-bar/gemmini>  
   为什么看：同时支持 `WS / OS`，非常适合对比两种数据流在工程接口上的差异。

9. Gemmini 文档（Chipyard）  
   链接：<https://chipyard.readthedocs.io/en/stable/Generators/Gemmini.html>  
   为什么看：比只读源码更容易建立整体心智模型。

10. SAURIA  
    链接：<https://github.com/bsc-loca/sauria>  
    为什么看：这是一个较完整的开源脉动阵列加速器实现。

11. SAURIA Wiki: Systolic Array  
    链接：<https://github-wiki-see.page/m/bsc-loca/sauria/wiki/Systolic-Array>  
    为什么看：对 `OS` 风格阵列和数据传播方向解释得很适合新手。

12. hngenc/systolic-array  
    链接：<https://github.com/hngenc/systolic-array>  
    为什么看：适合理解“阵列结构 + 时空调度”是如何对应起来的。

13. kaggar11/systolic_4x4arr  
    链接：<https://github.com/kaggar11/systolic_4x4arr>  
    为什么看：体量小，适合刚开始看 Verilog 脉动阵列工程的人。

### 8.4 适合边看边学的教程和工具

14. AutoSA  
    链接：<https://github.com/UCLA-VAST/AutoSA>  
    为什么看：展示如何从更高层的循环/调度视角生成 systolic array。

15. AutoSA 文档  
    链接：<https://autosa.readthedocs.io/en/latest/>  
    为什么看：如果你想从“为什么是这种 I/O 调度”去理解阵列，很有帮助。

16. SCALE-Sim  
    链接：<https://github.com/scalesim-project/SCALE-Sim>  
    为什么看：不是 RTL 实现，而是很适合学习数据流、阵列规模和带宽约束如何影响性能。

17. SCALE-Sim 文档  
    链接：<https://scale-sim-project.readthedocs.io/>  
    为什么看：适合做“纸上推演”和参数实验，帮助你先理解，再看 RTL。

---

## 9. 一个推荐学习顺序

如果你完全从零开始，建议按这个顺序走：

1. 先看本页，建立最小概念框架
2. 再看 `README.md`，知道项目怎么跑
3. 跑 `make ws / is / os / dip`
4. 跑 `make ws-txt / is-txt / os-txt / dip-txt`
5. 看 `docs/数据流资料对照与前端实现评审_CN.md`
6. 对照 `standard_*_array_4x4.v`
7. 再回头看低层 `systolic_array_*` 和 `*_pe.v`
8. 想继续深入时，再去看 Gemmini / SAURIA / AutoSA / SCALE-Sim

---

## 10. 和本仓库最相关的补充文档

- `README.md`
- `docs/四种数据流波形与时序教学图解_CN.md`
- `docs/统一Makefile与仿真综合使用说明_CN.md`
- `docs/数据流资料对照与前端实现评审_CN.md`
- `DATAFLOW_VALIDATION_STATUS_CN.md`
- `ARCHITECTURE_VALIDATION_AND_PERFORMANCE.md`

如果你的目标是“先跑起来，再理解”，优先级建议是：

1. 本文
2. `README.md`
3. `docs/统一Makefile与仿真综合使用说明_CN.md`

如果你的目标是“先确认四种数据流到底对不对”，优先级建议是：

1. 本文
2. `docs/数据流资料对照与前端实现评审_CN.md`
3. `DATAFLOW_VALIDATION_STATUS_CN.md`
