# Systolic Array Edge

本仓库包含四种 `4x4` 脉动阵列数据流实现，并且已经把统一仿真、文件回归、
波形查看和综合入口收敛到一套顶层 Makefile 体系：

- `ws/`：Weight Stationary
- `is/`：Input Stationary
- `os/`：Output Stationary
- `dip/`：DiP（Diagonal-Input & Permutated weight-stationary）

## 先看什么

如果你还没系统学过脉动阵列，建议按这个顺序上手：

1. `docs/脉动阵列零基础上手与仓库导读_CN.md`
2. `docs/数据流资料对照与前端实现评审_CN.md`
3. `DATAFLOW_VALIDATION_STATUS_CN.md`
4. 再回到四个子目录的 `README.md`

当前仓库里最推荐作为“正式前端入口”阅读和使用的模块是：

- `ws/src/standard_ws_array_4x4.v`
- `is/src/standard_is_array_4x4.v`
- `os/src/standard_os_array_4x4.v`
- `dip/src/standard_dip_array_4x4.v`

低层 `systolic_array_*.v` 和 `*_pe.v` 仍然保留，用于理解内部传播结构以及兼容
现有 ASIC handoff，但不再是仓库级的首选学习入口。

## 目录怎么读

如果你只是想快速上手，不要从一堆脚本目录开始翻。先记住下面这张图：

- `Makefile`
  仓库唯一推荐总入口。日常仿真、回归、综合、论文主线都从这里进。
- `ws/` `is/` `os/` `dip/`
  四种数据流的前端 RTL、约束、测试平台和各自的轻量脚本。
- `tb/` `test_vectors/` `utils/`
  公共测试平台、文本向量和回归辅助脚本。
- `asic/`
  开源 ASIC handoff 和 OpenROAD 相关目录。
- `asic_commercial/`
  商业工具 runset。这里脚本最多，但属于“低层实现细节”，通常通过根目录 `make` 间接调用。
- `docs/`
  中文导读、实验口径、论文材料说明。目录地图见 `docs/PROJECT_LAYOUT_CN.md`。
- `slides/`
  组会材料和渲染产物。
- `TSMC28/`
  本地工艺库投放目录，不属于仓库主源码。
- `work/`
  本地整理后的工作区。`make tidy-workspace` 会把根目录误落下来的生成物收拢到这里。

如果你发现根目录开始出现 `*.mr`、`*-verilog.syn`、`innovus.log`、`icc2_output.txt`
这类工具产物，可以直接执行：

```bash
make tidy-workspace
```

## 快速开始

最常用命令都在仓库根目录执行。建议先按这 5 类理解：

```bash
make txt
make random
make batch
make run ARCH=ws
make wave ARCH=dip
make open ARCH=ws
make cov ARCH=dip
```

它们分别表示：

- `txt`：固定基准回归
- `random`：随机回归
- `batch`：`random` 的大样本兼容别名
- `run / wave / open`：调试验证
- `cov`：覆盖率回归

如果你想显式指定架构和工具，也可以继续使用底层统一入口：

```bash
make sim ARCH=ws SIM=iverilog
make view ARCH=os SIM=iverilog VIEWER=surfer
make txt-one ARCH=is SIM=iverilog VECTOR_DIR=test_vectors/txt
make cov ARCH=dip VECTOR_DIR=test_vectors/txt
make synth ARCH=dip
make impl-summary
```

命令总览：

```bash
make help
make help-all
```

如果你第一次使用，最建议先跑这组：

```bash
make txt
make random RANDOM_VECTOR_SEED=3 RANDOM_VECTOR_COUNT=16
make run ARCH=ws
```

## 四种数据流怎么区分

| 架构 | 核心语义 | 当前推荐前端入口 |
|------|----------|------------------|
| `WS` | 权重尽量驻留在 PE，输入流动，部分和传播 | `ws/src/standard_ws_array_4x4.v` |
| `IS` | 输入尽量驻留在 PE，权重流动，部分和传播 | `is/src/standard_is_array_4x4.v` |
| `OS` | 输出/部分和驻留在 PE，本地累加后统一读出 | `os/src/standard_os_array_4x4.v` |
| `DiP` | 输入按对角方向传播，权重按旋转布局注入 | `dip/src/standard_dip_array_4x4.v` |

## 当前你能做什么

- 用 `iverilog` / `VCS` 跑功能仿真
- 用 `Surfer` / `Verdi` 打开波形
- 用 `.txt` 输入和标准答案做回归
- 用 `VCS + urg` 跑功能覆盖率并产出报告
- 在 `.txt` 回归里查看零值门控潜力（`A_nz / B_nz / active_mac / zero_gated / skip_ratio`）
- 用随机向量做四架构统一测试，`batch` 只是大样本兼容入口
- 用 `Vivado` 对四个架构分别综合
- 在每个架构子目录下拿到自己的综合报告

## 当前验证状态

在 2026-03-17 重新实测后，四个标准 wrapper 的 `.txt` 文件驱动回归在
`iverilog` 口径下都通过了 `268 / 268`。

更完整的结论见：

- `DATAFLOW_VALIDATION_STATUS_CN.md`
- `docs/数据流资料对照与前端实现评审_CN.md`

## 重点文档

完整中文上手说明见：

- `docs/脉动阵列零基础上手与仓库导读_CN.md:1`
- `docs/四种数据流波形与时序教学图解_CN.md:1`
- `docs/统一Makefile与仿真综合使用说明_CN.md:1`
- `docs/功能覆盖率使用说明_CN.md:1`
- `docs/数据流资料对照与前端实现评审_CN.md:1`
- `docs/边缘优化实践与实现说明_CN.md:1`
- `docs/论文综合实验口径说明_CN.md:1`
- `docs/论文大纲_面向边缘计算脉动阵列_CN.md:1`
- `docs/ASIC前端完成清单_CN.md:1`

补充状态说明见：

- `DATAFLOW_VALIDATION_STATUS_CN.md:1`

ASIC handoff 骨架见：

- `asic/README.md:1`
- `asic/flows/openroad/README.md:1`
- `asic_commercial/README.md:1`
- `docs/PROJECT_LAYOUT_CN.md:1`
