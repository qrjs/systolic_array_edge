# DiP (Diagonal-Input & Permutated Weight-Stationary) 架构

## 这是什么

`DiP` 的核心语义不是简单“斜着传数据”，而是这几件事同时成立：

- 输入沿对角方向传播
- 行与行之间有绕接关系
- 权重按软件预旋转后的布局注入
- 最终仍然对外提供标准 GEMM 风格结果矩阵接口

直接论文来源：

- `DiP: A Scalable, Energy-Efficient Systolic Array for Matrix Multiplication Acceleration`
- <https://arxiv.org/abs/2412.09709>

如果你还没学过脉动阵列，建议先看：

- `../docs/脉动阵列零基础上手与仓库导读_CN.md`
- `../docs/数据流资料对照与前端实现评审_CN.md`

## 先看哪些 RTL

推荐优先看：

- `src/standard_dip_array_4x4.v`
- `src/systolic_array_dip_4x4.v`
- `src/dip_pe.v`

其中：

- `standard_dip_array_4x4.v` 负责对外提供标准结果矩阵接口
- `systolic_array_dip_4x4.v` 体现对角传播和边界绕接
- `dip_pe.v` 是带 signed MAC 的基础单元

本仓库中使用的权重旋转公式为：

`W_rot[i][j] = W[(i + j) mod N][j]`

## 推荐命令

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

如果只想在本目录内工作，也可以使用：

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

- `src/dip_pe.v`：带 signed MAC 的 DiP PE
- `src/systolic_array_dip_4x4.v`：体现对角传播与边界绕接的流式阵列
- `src/standard_dip_array_4x4.v`：对外提供标准 GEMM 风格结果矩阵接口
- `tb/standard_dip_smoke_tb.sv`：轻量 smoke testbench
- `tb/standard_dip_file_tb.sv`：`.txt` 输入/期望输出回归 testbench

## 说明

- `.txt` 回归遵循论文导向的验证方式：不把延迟/flush 逻辑偷藏进 testbench 期望里
- VCS 默认 license server 为 `5999@curry-GTR-Pro`，如需覆盖可在命令前设置 `VCS_LICENSE_FILE=<port@host>`
- 更完整的仓库级使用方式见 `../docs/统一Makefile与仿真综合使用说明_CN.md`
