# Systolic Array Edge

本仓库包含四种 `4x4` 脉动阵列数据流实现：

- `ws/`：Weight Stationary
- `is/`：Input Stationary
- `os/`：Output Stationary
- `dip/`：DiP（Diagonal-Input & Permutated weight-stationary）

## 快速开始

最常用命令都在仓库根目录执行：

```bash
make run ARCH=ws
make wave ARCH=dip
make open ARCH=ws
make regress
make backend
make impl ARCH=is
make impl-summary
make verify
make clean
```

兼容旧别名仍然保留，例如：

```bash
make ws
make ws-vcs
make dip-wave
make surfer ARCH=ws
make txt
make verify-full
```

如果你想显式指定架构和工具，也可以继续使用底层统一入口：

```bash
make sim ARCH=ws SIM=iverilog
make view ARCH=os SIM=iverilog VIEWER=surfer
make txt-one ARCH=is SIM=iverilog VECTOR_DIR=test_vectors/txt
make synth ARCH=dip
make impl-summary
```

命令总览：

```bash
make help
make help-all
```

## 你现在能做什么

- 用 `iverilog` / `VCS` 跑功能仿真
- 用 `Surfer` / `Verdi` 打开波形
- 用 `.txt` 输入和标准答案做回归
- 在 `.txt` 回归里查看零值门控潜力（`A_nz / B_nz / active_mac / zero_gated / skip_ratio`）
- 用随机向量和大批量向量做四架构统一测试
- 用 `Vivado` 对四个架构分别综合
- 在每个架构子目录下拿到自己的综合报告

## 重点文档

完整中文上手说明见：

- `docs/统一Makefile与仿真综合使用说明_CN.md:1`
- `docs/边缘优化实践与实现说明_CN.md:1`
- `docs/论文大纲_面向边缘计算脉动阵列_CN.md:1`
- `docs/ASIC前端完成清单_CN.md:1`

补充状态说明见：

- `DATAFLOW_VALIDATION_STATUS_CN.md:1`

ASIC handoff 骨架见：

- `asic/README.md:1`
- `asic/flows/openroad/README.md:1`
- `asic_commercial/README.md:1`
