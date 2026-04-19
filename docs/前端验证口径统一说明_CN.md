# 前端验证口径统一说明

更新时间：2026-03-18

## 1. 当前前端验证到底按什么算

当前仓库的前端正式功能验证统一按下面这条口径执行：

1. 从文本文件读取输入矩阵
2. 由 DUT 完成运算
3. 与文本文件中的标准答案逐项比对
4. 以批量回归汇总结果作为正式结论

也就是说，正式结论只认“文本输入 + 文本标准答案 + 自动比对”。

---

## 2. 现在有哪些前端验证入口

### 2.1 固定基准回归

固定基准回归使用仓库内置的标准向量目录：

- `test_vectors/txt/*_input.txt`
- `test_vectors/txt/*_expected.txt`

常用命令：

```bash
make ws-txt
make is-txt
make os-txt
make dip-txt
make regress
make front-verify
```

说明：

- `ws-txt / is-txt / os-txt / dip-txt` 是单架构固定回归
- `regress / front-verify` 是把四个 `*-txt` 串起来统一执行

### 2.2 随机回归

随机回归会先生成一批新的随机向量，再立刻跑回归：

```bash
make random
make random-vcs
```

随机向量不再生成一堆零散小文件，而是只生成两个汇总文件：

- `suite_input.txt`
- `suite_expected.txt`

你可以直接通过参数控制规模，例如：

```bash
make random RANDOM_VECTOR_COUNT=32
make random RANDOM_VECTOR_SEED=3 RANDOM_VECTOR_COUNT=128
```

### 2.3 `batch` 现在是什么

`batch` 不再代表第二种验证流程。

现在它只是 `random` 的大样本兼容别名，保留它只是为了少改老命令：

```bash
make batch
make batch-vcs
```

它内部仍然走同一套随机向量生成和文本比对逻辑，只是默认样本数更大、默认 seed 用时间戳。
如果你需要复现某一轮结果，可以手工指定 `BATCH_VECTOR_SEED=<固定值>`。

### 2.4 覆盖率

```bash
make cov ARCH=dip
```

这条链路仍然是文本向量驱动验证，只是额外收集 VCS 覆盖率数据。

---

## 3. 随机回归现在的文件格式

随机回归目录现在都不是“每个 case 两个文件”。

当前格式是：

- 一个输入总文件：`suite_input.txt`
- 一个标准答案总文件：`suite_expected.txt`

文件内部用 `CASE <name>` 分段。例如：

```text
CASE rand_000
A
...
B
...
CASE rand_001
A
...
B
...
```

标准答案文件同理，只是矩阵段名为 `C`。

testbench 会通过 `+CASE=<name>` 从总文件中选取当前 case。

---

## 4. 每次测试前会不会清理旧数据

会。

当前统一要求是：每次测试都先删除旧测试数据，再生成或运行新测试。

已经落实的行为包括：

- `make random` / `make random-vcs`
  会先删除旧的随机向量目录，再生成新的 `suite_input.txt` / `suite_expected.txt`
- `make batch` / `make batch-vcs`
  会按 `random` 的兼容模式先删旧目录，再生成新的 `suite_input.txt` / `suite_expected.txt`
- `make ws-txt` / `make is-txt` / `make os-txt` / `make dip-txt`
  会先清空对应架构的 `sim/txt_vectors/...` 输出目录，再写本轮日志和结果
- `make run` / `make wave`
  会先清空对应输出目录，再生成本轮仿真结果
- `make cov`
  会先清空对应覆盖率输出目录，再生成本轮覆盖率结果
- `make regress` / `make front-verify`
  会先清空 `test_logs/multi_arch_txt`，再写本轮多架构汇总日志

因此现在不需要再手工先执行一次 `make clean` 才能保证本轮结果干净。

---

## 5. `.svh` 文件是做什么的

仓库里你看到的 `.svh` 主要是：

- [txt_matrix_tasks.svh](/home/jrq/systolic_array_edge/tb/common/txt_matrix_tasks.svh)

`.svh` 是 SystemVerilog 头文件，用来放多个 testbench 共用的任务。

当前这个 `.svh` 负责：

- 读取输入文本
- 读取标准答案文本
- 根据 `+CASE=<name>` 从汇总文件中选出指定 case
- 打印矩阵上下文
- 打印逐元素 PASS / FAIL
- 统计 zero-gating 相关信息

它不是 DUT，也不是单独的 testbench，而是文件型 testbench 共用的工具层。

---

## 6. 怎么理解“正式验证”和“调试验证”

正式验证：

- `*-txt`
- `regress`
- `front-verify`
- `random-*`
- `cov`

调试验证：

- `run`
- `wave`
- `open`
- smoke / latency testbench

区别不在于是否跑仿真，而在于：

- 正式验证要输出可复述、可比较的文本比对结论
- 调试验证主要用于看行为、看波形、定位问题

补充说明：

- `batch-*` 仍然可以用，但它只是 `random-*` 的大样本兼容别名
