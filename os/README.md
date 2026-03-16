# OS (Output Stationary) 架构

## 架构说明
Output Stationary 数据流：部分和驻留在 PE 中，输入和权重沿阵列传播。

## 推荐入口
优先使用仓库根目录统一入口：

```bash
make os
make os-vcs
make os-wave
make os-surfer
make os-verdi-vcs
make os-txt
make os-txt-vcs
make os-synth
make os-clean
```

如果你想只在本子目录内工作，也可以使用统一子入口：

```bash
make -C scripts sim SIM=iverilog
make -C scripts sim SIM=vcs
make -C scripts wave SIM=iverilog
make -C scripts wave SIM=vcs
make -C scripts view SIM=iverilog VIEWER=surfer
make -C scripts view SIM=vcs VIEWER=verdi
make -C scripts txt SIM=iverilog
make -C scripts txt SIM=vcs
make -C scripts synth
make -C scripts clean
```

## 当前支持
- `iverilog` 功能仿真
- `VCS` 功能仿真
- `Surfer / Verdi` 波形查看
- `Vivado` 综合
- `.txt` 输入/期望输出回归

## 详细说明
- 仓库统一说明：`docs/统一Makefile与仿真综合使用说明_CN.md`
- 仓库总入口：`Makefile`
- 本架构子入口：`os/scripts/Makefile`
