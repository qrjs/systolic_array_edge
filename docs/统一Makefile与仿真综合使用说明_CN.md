# 统一 Makefile 与仿真/回归/综合中文上手说明

这份文档只讲**现在能直接用的流程**，目标是让你第一次打开仓库就知道：

- 从哪里开始跑
- 常用命令是什么
- 测试输出怎么看
- 综合报告在哪
- 四个架构怎么分别使用

---

## 1. 仓库里有什么

本仓库当前维护四种 `4x4` 数据流实现：

- `ws/`：Weight Stationary
- `is/`：Input Stationary
- `os/`：Output Stationary
- `dip/`：DiP（Diagonal-Input & Permutated weight-stationary）

统一入口在仓库根目录：

- `Makefile`

四个架构各自还有子目录入口：

- `ws/scripts/Makefile`
- `is/scripts/Makefile`
- `os/scripts/Makefile`
- `dip/scripts/Makefile`

但日常使用时，**推荐你优先在仓库根目录执行命令**。

---

## 2. 最常用命令

### 2.1 单架构功能仿真

默认 `iverilog`：

```bash
make ws
make is
make os
make dip
```

显式写法：

```bash
make ws-iverilog
make is-iverilog
make os-iverilog
make dip-iverilog
```

用 `VCS`：

```bash
make ws-vcs
make is-vcs
make os-vcs
make dip-vcs
```

### 2.2 生成和查看波形

生成波形：

```bash
make ws-wave
make dip-wave
make ws-wave-vcs
make dip-wave-vcs
```

打开波形：

```bash
make ws-surfer
make ws-verdi
make dip-surfer-vcs
make dip-verdi-vcs
```

说明：

- `*-surfer` / `*-verdi` 默认打开 `iverilog` 生成的波形
- `*-surfer-vcs` / `*-verdi-vcs` 打开 `VCS` 生成的波形
- 需要图形环境（例如正确设置 `DISPLAY`）

### 2.3 `.txt` 文件回归

单架构固定向量回归：

```bash
make ws-txt
make is-txt
make os-txt
make dip-txt
```

单架构固定向量回归 + `VCS`：

```bash
make ws-txt-vcs
make is-txt-vcs
make os-txt-vcs
make dip-txt-vcs
```

四架构统一固定回归：

```bash
make txt
```

四架构统一固定回归 + `VCS`：

```bash
make txt-all-vcs
```

### 2.4 大批量回归

生成随机向量并跑四架构：

```bash
make random-iverilog
make random-vcs
```

生成更大批量向量并跑四架构：

```bash
make batch-iverilog
make batch-vcs
```

### 2.5 综合

四个架构都能分别综合：

```bash
make ws-vivado
make is-vivado
make os-vivado
make dip-vivado
```

兼容别名：

```bash
make ws-synth
make is-synth
make os-synth
make dip-synth
```

### 2.6 清理

单架构清理：

```bash
make ws-clean
make dip-clean
```

全局清理：

```bash
make clean
make distclean
```

---

## 3. 推荐上手顺序

如果你第一次上手，建议按这个顺序跑：

### 第一步：确认功能仿真能跑

```bash
make ws
make dip
```

### 第二步：看 `.txt` 文件回归

```bash
make txt
```

### 第三步：看大批量统一回归

```bash
make batch-iverilog BATCH_VECTOR_COUNT=32
```

### 第四步：看某个架构的波形

```bash
make dip-wave
make dip-verdi
```

### 第五步：看综合

```bash
make dip-vivado
```

---

## 4. 测试输出怎么看

这是现在最重要的一部分。

### 4.1 单个 `.txt` 用例会打印什么

当你执行：

```bash
make ws-txt
```

或者：

```bash
make txt-one ARCH=ws SIM=iverilog VECTOR_DIR=test_vectors/txt
```

每个测试用例会打印：

- 当前输入文件路径
- 当前标准答案文件路径
- `A` 矩阵
- `B` 矩阵
- `EXPECTED_C` 矩阵
- 低功耗相关统计：
  - `A_nz / B_nz`：A、B 中非零元素个数
  - `active_mac`：真正需要执行的非零乘加次数
  - `zero_gated`：可以被零值门控旁路的乘加次数
  - `skip_ratio`：零值门控可跳过比例
- 每个输出元素的：
  - `row`
  - `col`
  - `expected`
  - `actual`
  - `PASS / FAIL`

也就是说，你可以直接在终端里看到：

- 期望值是多少
- 实际值是多少
- 哪个单元过了
- 哪个单元错了

### 4.2 输出格式特点

矩阵打印已经做成了行列对齐的形式，例如：

- 顶部有列号：`c0 c1 c2 c3`
- 左边有行号：`row0 row1 row2 row3`
- 数值按列对齐

逐元素检查的输出类似：

```text
[WS_FILE][CHECK] row=0 col=0 expected=... actual=... => PASS
```

其中：

- `PASS` 为绿色
- `FAIL` 为红色

在真实终端里颜色会显示出来；如果是在某些不支持颜色的环境中，可能只显示纯文本。

### 4.2A 低功耗统计怎么理解

你会看到类似下面这一行：

```text
[WS_FILE][POWER] A_nz=12/16 B_nz=13/16 active_mac=40/64 zero_gated=24 skip_ratio=37.5%
```

含义如下：

- `A_nz / B_nz`：输入矩阵里有多少个非零值
- `active_mac`：这组矩阵乘中，真正需要做的非零 MAC 数
- `zero_gated`：因为某一侧操作数为 0，可以直接旁路掉的 MAC 数
- `skip_ratio`：`zero_gated / total_mac`，越高说明稀疏性越强、零值门控收益越大

这个统计不会改变功能正确性，它只是帮助你评估：

- 这组向量对“边缘低功耗优化”是否友好
- 当前数据集中稀疏性有多强
- 零值门控理论上能减少多少无效翻转

### 4.3 最后的统计摘要

所有统一入口在结束时都会输出摘要框，包含：

- 架构名
- 模式（`sim / wave / txt / synth`）
- 工具（`iverilog / vcs / vivado`）
- `PASS / FAIL`
- 统计计数
- 若是 `.txt` 回归，还会额外输出 `TXT_POWER` 汇总行
- 日志路径
- 产物路径（如果适用）

相关实现：

- `utils/pretty_summary.py`

### 4.4 四架构统一回归时的统计规则

当你执行：

```bash
make txt
```

或：

```bash
make batch-iverilog
```

现在采用的是**先跑、最后统一打印统计**的方式：

- 运行过程中，仍然能看到各架构真实的 testbench 输出
- 所有架构跑完后，最后统一打印：
  - `WS`
  - `IS`
  - `OS`
  - `DIP`
  - `ALL_ARCH`

也就是说：

- 不会把工具输出隐藏掉
- 但最终统计会集中放在最后，更容易收尾查看

相关实现：

- `utils/run_multi_arch_txt_regression.py`

---

## 5. 常用目录说明

### 5.1 仿真输出目录

例如：

- `ws/sim/iverilog`
- `ws/sim/vcs`
- `dip/sim/iverilog`
- `dip/sim/vcs`

### 5.2 波形输出目录

例如：

- `ws/sim/wave_iverilog`
- `ws/sim/wave_vcs`
- `dip/sim/wave_iverilog`
- `dip/sim/wave_vcs`

### 5.3 `.txt` 回归输出目录

例如：

- `ws/sim/txt_vectors/iverilog`
- `ws/sim/txt_vectors/vcs`
- `dip/sim/txt_vectors/iverilog`
- `dip/sim/txt_vectors/vcs`

### 5.4 统一回归日志目录

四架构统一批量回归日志放在：

- `test_logs/multi_arch_txt`

### 5.5 综合日志目录

Vivado 的命令行日志默认在各架构自己的：

- `ws/sim/vivado`
- `is/sim/vivado`
- `os/sim/vivado`
- `dip/sim/vivado`

### 5.6 综合报告目录

每个架构综合完成后，报告统一写到该架构自己的：

- `ws/reports/synth`
- `is/reports/synth`
- `os/reports/synth`
- `dip/reports/synth`

其中通常包含：

- `utilization_report.txt`
- `timing_report.txt`
- `clock_interaction.txt`
- `power_report.txt`
- `drc.txt`

所以现在答案很明确：**四个架构都能分别综合，而且报告都在各自子目录下。**

---

## 6. 批量测试参数怎么改

### 6.1 随机回归参数

```bash
make random-iverilog \
  RANDOM_VECTOR_COUNT=16 \
  RANDOM_VECTOR_SEED=20260316 \
  RANDOM_VECTOR_MIN=-16 \
  RANDOM_VECTOR_MAX=16 \
  RANDOM_VECTOR_SPARSE=0.20
```

### 6.2 大批量回归参数

```bash
make batch-iverilog \
  BATCH_VECTOR_COUNT=256 \
  BATCH_VECTOR_SEED=20260324 \
  BATCH_VECTOR_MIN=-64 \
  BATCH_VECTOR_MAX=64 \
  BATCH_VECTOR_SPARSE=0.30
```

常用变量含义：

- `BATCH_VECTOR_COUNT`：生成多少组测试
- `BATCH_VECTOR_SEED`：固定随机种子，方便复现
- `BATCH_VECTOR_MIN` / `BATCH_VECTOR_MAX`：随机值范围
- `BATCH_VECTOR_SPARSE`：置零概率，值越大越稀疏

---

## 7. 什么时候用哪个命令

### 只想快速确认架构没坏

```bash
make ws
make dip
```

### 想验证矩阵乘法结果是否完全对

```bash
make txt
```

### 想做更强压力测试

```bash
make batch-iverilog BATCH_VECTOR_COUNT=256
```

### 想看波形

```bash
make dip-wave
make dip-verdi
```

### 想比较 `iverilog` 和 `VCS`

```bash
make dip-txt
make dip-txt-vcs
```

### 想看综合资源和时序

```bash
make dip-vivado
```

然后去看：

- `dip/reports/synth`

---

## 8. 简化理解：你其实只要记住这些

如果你平时不想记太多，记下面这几条就够了：

```bash
make ws
make ws-vcs
make txt
make batch-iverilog
make dip-wave
make dip-vivado
make clean
```

需要切架构时，把 `ws` 换成：

- `is`
- `os`
- `dip`

---

## 9. 当前实现和论文复现的边界说明

这里说的是“怎么用”，不是完整论文评述，但有一点需要你知道：

- 当前 `DiP` 是按论文思路做的数据流复现方向
- 当前 `WS / IS / OS` 是可用、可测、可综合的传统数据流实现
- 如果你要做**论文 baseline 级别**的严格对照，尤其是 `WS` 是否带同步 FIFO，这部分还需要继续收敛和补强

换句话说：

- **现在这套流程已经非常适合日常开发、验证、批量回归和综合**
- **如果目标是完全对齐论文硬件开销模型，还要继续做更细的结构级复现**

---

## 10. 一句话总结

现在推荐你的默认工作流就是：

```bash
make txt
make batch-iverilog BATCH_VECTOR_COUNT=256
make dip-vivado
```

这样你可以分别完成：

- 固定回归
- 大批量压力回归
- 单架构综合与报告查看

如果只做日常开发，优先用根目录 `Makefile` 就够了。
