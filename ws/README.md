# WS (Weight-Stationary) 架构

## 这是什么

`WS` 的核心语义是：

- 权重尽量驻留在 `PE`
- 输入在阵列中流动
- 部分和继续传播，最后收成结果矩阵

如果你第一次接触脉动阵列，建议先看：

- `../docs/脉动阵列零基础上手与仓库导读_CN.md`
- `../docs/数据流资料对照与前端实现评审_CN.md`

## 先看哪些 RTL

推荐优先看这两个文件：

- `src/standard_ws_array_4x4.v`
- `src/pe.v`

其中：

- `standard_ws_array_4x4.v` 是当前推荐的标准 GEMM 风格前端接口
- `systolic_array_4x4.v` 是低层阵列实现，更多用于内部传播结构和 handoff

## 推荐命令

优先使用仓库根目录统一入口：

```bash
make ws
make ws-vcs
make ws-wave
make ws-surfer
make ws-verdi-vcs
make ws-txt
make ws-txt-vcs
make ws-synth
make ws-clean
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

- 权重何时装入阵列
- 输入数据如何按行推进
- 部分和如何沿列传播
- 什么时候把最后一行结果写回到标准输出缓冲

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
