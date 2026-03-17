# IS (Input-Stationary) 架构

## 这是什么

`IS` 的核心语义是：

- 输入尽量驻留在 `PE`
- 权重在阵列中流动
- 部分和继续传播，最后重组成标准结果矩阵

如果你第一次接触这类架构，建议先看：

- `../docs/脉动阵列零基础上手与仓库导读_CN.md`
- `../docs/数据流资料对照与前端实现评审_CN.md`

## 先看哪些 RTL

推荐优先看：

- `src/standard_is_array_4x4.v`
- `src/is_pe.v`

其中：

- `standard_is_array_4x4.v` 是当前推荐的标准 GEMM 前端接口
- `systolic_array_is_4x4.v` 是保留给底层传播结构和现有 handoff 的低层阵列

## 推荐命令

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

## 你第一次看波形时该关注什么

- 输入是如何 preload 或保持在本地的
- 权重如何沿阵列推进
- 部分和如何横向传播
- 最后一列如何把结果写回标准输出缓冲

## 当前支持

- `iverilog` 功能仿真
- `VCS` 功能仿真
- `Surfer / Verdi` 波形查看
- `Vivado` 综合
- `.txt` 输入/期望输出回归

## 相关文档

- 仓库总入口：`../README.md`
- 统一命令说明：`../docs/统一Makefile与仿真综合使用说明_CN.md`
- 新手导读：`../docs/脉动阵列零基础上手与仓库导读_CN.md`
- 资料对照与实现评审：`../docs/数据流资料对照与前端实现评审_CN.md`
