# Architecture Validation And Performance Guide

这份文档保留为仓库级摘要，但统一入口已经收敛到新的 Makefile 体系。

## 统一入口
推荐直接在仓库根目录使用：

```bash
make txt
make random RANDOM_VECTOR_SEED=3 RANDOM_VECTOR_COUNT=16
make random RANDOM_VECTOR_SEED=3 RANDOM_VECTOR_COUNT=64
make run ARCH=ws
make wave ARCH=dip
make cov ARCH=dip
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

## 当前验证结构
- `txt`：固定基准回归
- `random`：随机回归
- `batch`：`random` 的大样本兼容别名
- `run / wave / view`：调试验证
- `cov`：覆盖率回归

## 文档入口
- 零基础导读：`docs/脉动阵列零基础上手与仓库导读_CN.md`
- 完整中文说明：`docs/统一Makefile与仿真综合使用说明_CN.md`
- 数据流资料对照与前端评审：`docs/数据流资料对照与前端实现评审_CN.md`
- 根入口：`README.md`
- DiP 说明：`dip/README.md`
