# DiP Standalone Subproject

本目录实现 DiP（Diagonal-Input and Permutated weight-stationary）数据流的 RTL、文件型回归和统一 Makefile 入口。

论文入口：

- arXiv: `DiP: A Scalable, Energy-Efficient Systolic Array for Matrix Multiplication Acceleration`
- 链接：`https://arxiv.org/abs/2412.09709`

## 推荐入口
优先使用仓库根目录统一入口：

```bash
make dip
make dip-vcs
make dip-wave
make dip-wave-vcs
make dip-surfer
make dip-verdi-vcs
make dip-txt
make dip-txt-vcs
make dip-synth
make dip-clean
```

如果你想只在 DiP 子目录内工作，也可以使用：

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

## 当前实现
- `dip/src/dip_pe.v`：带 signed MAC 的 DiP PE
- `dip/src/systolic_array_dip_4x4.v`：带稳定 row-output 接口的流式 DiP 阵列
- `dip/src/standard_dip_array_4x4.v`：对外提供标准 GEMM 风格结果矩阵接口
- `dip/tb/standard_dip_smoke_tb.sv`：轻量 smoke testbench
- `dip/tb/standard_dip_file_tb.sv`：`.txt` 输入/期望输出回归 testbench

## 说明
- `.txt` 回归遵循论文要求：不把延迟/flush 实现在 testbench 中。
- VCS 默认 license server 为 `5999@curry-GTR-Pro`，如需覆盖可在命令前设置 `VCS_LICENSE_FILE=<port@host>`。
- 更完整的仓库级使用方式见 `docs/统一Makefile与仿真综合使用说明_CN.md`。
