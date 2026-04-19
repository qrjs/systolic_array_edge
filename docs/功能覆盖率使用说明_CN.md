# 功能覆盖率使用说明

## 这份文档解决什么问题

本仓库原先只有功能仿真和 `.txt` 回归，能回答“结果对不对”，但很难回答
“关键场景有没有被激发到”。这份文档说明如何用 `VCS + urg` 在现有四种数据流
上收集功能覆盖率，尤其是把 `DiP` 的覆盖点接进论文实验流程。

## 当前支持范围

- `WS / IS / OS`：已有 `cover property`，覆盖点通过 `+define+FORMAL` 激活
- `DiP`：新增了 `PE`、流式阵列和标准 wrapper 三层覆盖点
- 覆盖率入口统一走仓库根目录 `Makefile`
- 覆盖率工具链要求：`vcs`、`urg`

## 最常用命令

单架构覆盖率：

```bash
make cov ARCH=dip
make cov ARCH=ws
```

快捷别名：

```bash
make dip-cov
make ws-cov
```

四架构全跑：

```bash
make cov-all
```

指定向量目录：

```bash
make cov ARCH=dip VECTOR_DIR=test_vectors/txt
make cov ARCH=dip VECTOR_DIR=test_vectors/batch/seed_20260317
```

## 会产出什么

以 `DiP` 为例，运行 `make dip-cov` 后主要产物在：

```text
dip/sim/coverage/vcs/
```

其中常见文件/目录含义如下：

- `summary.log`：本次覆盖率回归的总日志
- `build/`：`VCS` 编译产物
- `case_vdb/*.vdb`：每个 `.txt` case 的独立覆盖数据库
- `merged.vdb`：`urg` 合并后的总数据库
- `report/`：`urg` 生成的覆盖率报告目录

## DiP 现在覆盖了哪些东西

`DiP` 不是只加了代码覆盖，而是补了面向数据流语义的功能覆盖点：

- `dip_pe.v`
  - 权重装载
  - token 输入
  - 有效 MAC
  - zero-gating 跳过
  - token 与权重同拍出现
  - flush
- `systolic_array_dip_4x4.v`
  - 权重行装载
  - 输入行推进
  - 底行整行 ready
  - ready 到 output_row_valid 的一拍传递
  - 阵列 busy / idle
  - 底行不同列被激发
- `standard_dip_array_4x4.v`
  - drain 触发
  - output row 被收集
  - 最终 result_valid
  - captured_rows 从 0 到 full
  - 输入行稠密度
  - 权重行稠密度
  - 输入稠密度与权重稠密度交叉覆盖

这套覆盖点更适合论文里的“功能场景覆盖”和“稀疏优化是否被命中”描述。

## 和普通回归有什么区别

- `make dip-txt`
  - 目标是验证 268 个向量是否全部通过
- `make dip-cov`
  - 目标是在 `VCS` 下把这些向量再跑一遍，同时产出覆盖率数据库和报告

建议顺序：

1. 先跑 `make dip-txt`
2. 再跑 `make dip-cov`

这样如果覆盖率流程失败，你能更快判断是“设计功能错了”，还是“覆盖率工具链没配好”。

## 论文里怎么写更合适

建议把功能覆盖率写成“验证完备性证据”，不要把它和后端面积/功耗混为一类：

- 功能回归：证明结果正确
- 功能覆盖率：证明关键控制流和数据流场景已被激发
- 综合/后端：证明面积、时序、功耗结论

对 `DiP` 来说，比较适合强调：

- 对角输入传播已被命中
- drain 逻辑已被命中
- zero-gating 场景已被命中
- 稀疏/非稀疏输入都被覆盖

## 常见问题

### 1. 为什么覆盖率只走 VCS，不走 iverilog

因为本仓库现在的覆盖率主线依赖：

- `cover property`
- `covergroup`
- `urg` 合并与报表

这条链路更适合直接用 `VCS`。

### 2. 为什么要定义 `FORMAL`

仓库里已有一批验证语句被包在 `` `ifdef FORMAL `` 里。覆盖率编译时定义
`FORMAL`，是为了把这些现有覆盖点一并激活，不会影响默认综合和普通仿真。

### 3. 如果服务器上没有 `urg` 怎么办

`make dip-cov` 会失败，并在日志里提示 `missing_urg`。这时需要确认
Synopsys 工具环境是否完整，或者把 `urg` 加进 `PATH`。
