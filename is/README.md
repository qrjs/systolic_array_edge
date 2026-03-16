# IS (Input Stationary) 架构

## 架构说明
Input Stationary 数据流：输入在阵列中保持，权重按阵列时序流动。

## 推荐入口
优先使用仓库根目录统一入口：

```bash
make is
make is-vcs
make is-wave
make is-surfer
make is-verdi-vcs
make is-txt
make is-txt-vcs
make is-synth
make is-clean
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
- 本架构子入口：`is/scripts/Makefile`
