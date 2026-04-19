# 统一 Makefile 与仿真验证使用说明

更新时间：2026-03-18

本文档只讲三件事：

1. 常用仿真/验证命令怎么跑
2. 每类命令会产生什么数据
3. 现在测试前是否会自动删除旧数据

---

## 1. 统一入口

仓库统一从根目录 `Makefile` 进入。

四种架构：

- `ws`
- `is`
- `os`
- `dip`

建议优先在仓库根目录执行命令。

---

## 2. 先记住这些命令

固定基准回归：

```bash
make ws-txt
make is-txt
make os-txt
make dip-txt
make regress
```

随机回归：

```bash
make random
make random-vcs
```

`batch` 兼容入口：

```bash
make batch
make batch-vcs
```

调试仿真：

```bash
make run ARCH=ws
make wave ARCH=dip
make open ARCH=ws
```

覆盖率：

```bash
make cov ARCH=dip
```

---

## 3. 每类命令分别做什么

### 3.1 `*-txt`

`ws-txt / is-txt / os-txt / dip-txt` 是单架构固定基准回归。

它们会：

1. 读取 `test_vectors/txt/` 下已有的输入文件和标准答案文件
2. 编译对应架构的文件型 testbench
3. 跑文本比对
4. 在对应架构的 `sim/txt_vectors/...` 下输出本轮日志

### 3.2 `regress` / `front-verify`

这是四架构固定基准回归入口。

它们本质上就是依次执行四个 `*-txt`，再给出统一汇总结果。

### 3.3 `random`

`make random` 等价于 `make random-iverilog`。

它会先生成一批新的随机向量，再对四种架构执行统一回归。

随机向量目录形如：

- `test_vectors/generated/seed_<seed>/`

但目录内部现在只保留两个文件：

- `suite_input.txt`
- `suite_expected.txt`

### 3.4 `batch`

`batch` 不再表示第二种验证流程。

它现在只是 `random` 的大样本兼容别名：

- 内部仍然调用同一套随机向量生成与文本比对逻辑
- 只是默认样本数更大
- 默认 seed 用时间戳，所以每次运行都会换一批数据

如果你想复现某一轮结果，可以显式传入 `BATCH_VECTOR_SEED=<固定值>`。
生成目录也已经收敛到同一个根目录：

- `test_vectors/generated/seed_<seed>/`

### 3.5 `run`

`run` 是单架构调试仿真入口。

用途：

- 快速冒烟
- 检查功能行为
- 配合日志看问题

它不是正式功能结论的主口径。

### 3.6 `wave` / `open`

用于生成波形和打开波形。

用途：

- 观察握手
- 观察时序
- 定位 flush / latency / drain 等边界问题

### 3.7 `cov`

仍然是文本向量驱动回归，只是额外打开 VCS 覆盖率收集。

输出通常在：

- `*/sim/coverage/vcs/`

---

## 4. 现在测试前会自动清理哪些旧数据

当前已经统一成“先删旧数据，再跑新测试”。

### 4.1 随机向量

在生成前会先删除旧目录：

- `make random` 先删旧的 `test_vectors/generated/seed_<seed>/`
- `make batch` 先删旧的 `test_vectors/generated/seed_<seed>/`

然后才生成新的：

- `suite_input.txt`
- `suite_expected.txt`

### 4.2 单架构仿真输出

在每次运行前会先清空对应输出目录：

- `sim`
- `wave`
- `txt`
- `cov`

也就是说，每轮结果都是本轮新产物，不会夹杂上一次残留。

### 4.3 多架构汇总日志

`regress / front-verify / random / batch` 这些多架构入口在开始前会先清掉：

- `test_logs/multi_arch_txt/`

然后再写本轮汇总日志。

---

## 5. 文件格式说明

### 5.1 固定基准向量

固定基准仍然使用历史格式：

- 一个 case 对应一个 `*_input.txt`
- 一个 case 对应一个 `*_expected.txt`

这类文件主要位于：

- `test_vectors/txt/`

### 5.2 随机向量

随机向量现在统一使用汇总格式：

- `suite_input.txt`
- `suite_expected.txt`

文件内部使用 `CASE <name>` 分段。

testbench 会通过 `+CASE=<name>` 读取当前 case 对应的数据。

---

## 6. 建议怎么用

如果你想做可复现的正式回归：

```bash
make regress
```

如果你想做新的随机抽检：

```bash
make random RANDOM_VECTOR_SEED=3 RANDOM_VECTOR_COUNT=32
```

如果你想做更大规模随机回归：

```bash
make random RANDOM_VECTOR_SEED=3 RANDOM_VECTOR_COUNT=128
```

如果你手里还有旧脚本，也可以继续写：

```bash
make batch BATCH_VECTOR_SEED=3 BATCH_VECTOR_COUNT=128
```

它只是兼容别名。

如果你在定位波形或接口边界问题：

```bash
make run ARCH=dip
make wave ARCH=dip
```

---

## 7. 一句话总结

现在这套仿真/验证流程的核心原则是：

- 正式验证统一走文本比对
- 随机回归只保留两个汇总文本文件
- 每次测试默认先清旧数据，再产生新结果
