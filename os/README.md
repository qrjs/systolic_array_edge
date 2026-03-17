# OS (Output-Stationary) 架构

## 这是什么

`OS` 的核心语义是：

- 输出或部分和驻留在 `PE` 的本地累加器中
- 输入和权重都在阵列里流动
- 等累加完成后再统一读出结果

如果你第一次接触脉动阵列，建议先看：

- `../docs/脉动阵列零基础上手与仓库导读_CN.md`
- `../docs/数据流资料对照与前端实现评审_CN.md`

## 先看哪些 RTL

推荐优先看：

- `src/standard_os_array_4x4.v`
- `src/os_pe.v`

其中：

- `standard_os_array_4x4.v` 是当前推荐的标准 GEMM 前端接口
- `systolic_array_os_4x4.v` 是底层阵列实现，保留给内部结构理解和 handoff

## 推荐命令

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

- 本地累加器 `acc` 何时清零
- `A` 和 `B` 如何分别沿两维传播
- 每个 `PE` 何时完成全部乘加
- `result_valid` 何时才真正拉高

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
