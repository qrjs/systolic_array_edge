# Architecture Validation And Performance Guide

这份文档保留为仓库级摘要，但统一入口已经收敛到新的 Makefile 体系。

## 统一入口
推荐直接在仓库根目录使用：

```bash
make ws
make is
make os
make dip
make txt
make txt-all-vcs
make random-vcs RANDOM_VECTOR_SEED=20260319 RANDOM_VECTOR_COUNT=2
```

## 通用参数化入口
```bash
make sim ARCH=ws SIM=iverilog
make sim ARCH=dip SIM=vcs
make wave ARCH=os SIM=vcs
make view ARCH=is SIM=iverilog VIEWER=surfer
make txt-one ARCH=dip SIM=vcs
make synth ARCH=ws
```

## 各架构支持能力
- `iverilog` 功能仿真
- `VCS` 功能仿真
- `Surfer / Verdi` 波形查看
- `Vivado` 综合
- `.txt` 文件驱动回归

## 文档入口
- 完整中文说明：`docs/统一Makefile与仿真综合使用说明_CN.md`
- 根入口：`README.md`
- DiP 说明：`dip/README.md`
