# 四种数据流波形与时序教学图解

更新时间：2026-03-17

## 1. 这份文档解决什么问题

很多人第一次看脉动阵列 RTL 时，并不是乘法和加法看不懂，而是：

- 不知道数据到底从哪一边进入
- 不知道什么叫“驻留”
- 打开波形后信号很多，不知道先看谁

这份文档专门解决这三个问题。它不是论文综述，而是一份“带着你看图、看时序、
看波形”的教学版说明。

如果你还没看过基础导读，建议先读：

- `docs/脉动阵列零基础上手与仓库导读_CN.md`

---

## 2. 看波形前先记住一个统一套路

无论是 `WS / IS / OS / DiP`，第一次看波形都建议按这四步：

1. 先看“谁先进入阵列”
2. 再看“谁在阵列里保持不动”
3. 再看“部分和或输出在哪里完成”
4. 最后看 `result_valid` 什么时候拉高

在本仓库里，四个标准 wrapper 都有这几个共同的顶层信号：

- `clk`
- `rst_n`
- `flush`
- `clk_enable`
- `result_valid`
- `result_matrix`
- `busy`

因此，新手第一次打开波形时，最小观察集可以先设成：

- 顶层输入控制信号
- 阵列内部核心状态寄存器
- `result_valid`
- `busy`

---

## 3. 怎么打开波形

推荐直接在仓库根目录执行：

```bash
make ws-wave
make is-wave
make os-wave
make dip-wave
```

如果要直接打开：

```bash
make ws-surfer
make is-surfer
make os-surfer
make dip-surfer
```

或者：

```bash
make ws-verdi-vcs
make is-verdi-vcs
make os-verdi-vcs
make dip-verdi-vcs
```

如果你想从最容易理解的 case 开始，建议优先看这些文本向量：

- `identity`
- `rank1_outer`
- `triangular_mix`
- `sparse_signed`

---

## 4. WS 教学图解

### 4.1 先用一句话理解

`WS` 的重点是：

- 权重先装进去，留在 `PE`
- 输入沿行传播
- 部分和沿列向下传播

### 4.2 结构示意图

![WS 数据流示意图](assets/ws_dataflow.svg)

图里可以直接把 `WS` 读成：

- 黄色 `W` 留在每个 `PE` 里
- 蓝色箭头表示输入 `A` 横向推进
- 橙色箭头表示部分和 `psum` 向下传播

### 4.3 在代码里对应哪些信号

看 [standard_ws_array_4x4.v](/home/jrq/systolic_array_edge/ws/src/standard_ws_array_4x4.v) 时，优先关注：

- `weight_row_valid`
- `weight_row_idx`
- `weight_row_data`
- `input_valid_vec`
- `input_data_vec`
- `stored_weight`
- `data_pipe`
- `psum_pipe`
- `row_tag_pipe`
- `result_buf`
- `result_valid`
- `busy`

### 4.4 看波形时先看什么

第一阶段：装权重

- `weight_row_valid` 会连续拉高几拍
- `stored_weight[row][col]` 被写入后保持不变

第二阶段：推输入

- `input_valid_vec` 开始出现反对角线式的有效模式
- `data_pipe` 从左向右推进

第三阶段：看部分和

- `psum_pipe` 从上往下传播
- 当最后一行拿到完成值时，会写入 `result_buf`

第四阶段：看输出完成

- 全部结果到齐后，`result_valid` 拉高一个拍
- `busy` 在计算未结束前保持有效

### 4.5 新手最容易误读的点

- `WS` 不是“只有权重存在，其它都不动”，而是“权重驻留，输入和部分和继续流动”
- `result_valid` 不是每个单元出一个结果就立刻拉高，而是整块矩阵收齐后才拉高

---

## 5. IS 教学图解

### 5.1 先用一句话理解

`IS` 的重点是：

- 输入先装进去并静止保存
- 权重从上往下流
- 部分和从左往右流

### 5.2 结构示意图

![IS 数据流示意图](assets/is_dataflow.svg)

图里可以直接把 `IS` 读成：

- 绿色 `A` 静止保存在每个 `PE`
- 蓝色箭头表示权重 `B` 从上往下推进
- 橙色箭头表示部分和 `psum` 从左往右传播

### 5.3 在代码里对应哪些信号

看 [standard_is_array_4x4.v](/home/jrq/systolic_array_edge/is/src/standard_is_array_4x4.v) 时，优先关注：

- `input_load_valid`
- `input_load_row_idx`
- `input_load_row_data`
- `weight_valid_vec`
- `weight_data_vec`
- `stored_input`
- `weight_pipe`
- `psum_pipe`
- `col_tag_pipe`
- `result_buf`
- `result_valid`
- `busy`

### 5.4 看波形时先看什么

第一阶段：装输入

- `input_load_valid` 连续拉高
- `stored_input[row][col]` 写入后保持不变

第二阶段：推权重

- `weight_valid_vec` 开始出现有效 token
- `weight_pipe` 从上往下推进

第三阶段：看部分和

- `psum_pipe` 从左往右传播
- 最后一列会把结果写回 `result_buf`

第四阶段：看完成信号

- `result_valid` 在整块矩阵完成时拉高
- `busy` 在输入加载或权重推进期间都可能为高

### 5.5 新手最容易误读的点

- `IS` 里静止的是输入，不是权重
- `stored_input` 不再流动，但权重 token 仍然要逐拍经过所有行

---

## 6. OS 教学图解

### 6.1 先用一句话理解

`OS` 的重点是：

- `A` 和 `B` 都在流动
- 每个 `PE` 自己维护本地累加器
- 输出不是“部分和继续往外传”，而是“本地累满再读出”

### 6.2 结构示意图

![OS 数据流示意图](assets/os_dataflow.svg)

图里可以直接把 `OS` 读成：

- 蓝色箭头表示 `A` 沿行传播
- 橙色箭头表示 `B` 沿列传播
- 红色 `acc` 表示结果就地在每个 `PE` 内累加

### 6.3 在代码里对应哪些信号

看 [standard_os_array_4x4.v](/home/jrq/systolic_array_edge/os/src/standard_os_array_4x4.v) 时，优先关注：

- `a_valid`
- `a_data`
- `b_valid`
- `b_data`
- `a_pipe`
- `b_pipe`
- `acc`
- `accum_count`
- `cell_done`
- `done_count`
- `result_valid`
- `busy`

### 6.4 看波形时先看什么

第一阶段：双边输入推进

- `a_valid` 表示每一行当前有没有新的 A token
- `b_valid` 表示每一列当前有没有新的 B token

第二阶段：看阵列内部传播

- `a_pipe` 沿行推进
- `b_pipe` 沿列推进

第三阶段：看本地累加

- `acc[row][col]` 会在同拍拿到有效 A/B 时更新
- `accum_count[row][col]` 会递增到 `ARRAY_SIZE`

第四阶段：看整块何时完成

- 当所有单元都完成后，`done_count` 到满
- `result_valid` 拉高

### 6.5 新手最容易误读的点

- `OS` 里没有显式的跨单元 `psum_pipe`，因为部分和就留在 `acc`
- 即使某拍 A 或 B 为 0，也可能仍然要推进计数，保证完成判定正确

---

## 7. DiP 教学图解

### 7.1 先用一句话理解

`DiP` 的重点是：

- 权重仍然有“像 WS 一样先装入”的味道
- 输入不是普通行传播，而是对角传播
- 标准 wrapper 还会自动补一拍 `drain`，把最后的结果冲出来

### 7.2 先看外层 wrapper，再看内层流式阵列

新手建议分两层看：

1. 先看 [standard_dip_array_4x4.v](/home/jrq/systolic_array_edge/dip/src/standard_dip_array_4x4.v)
2. 再看 [systolic_array_dip_4x4.v](/home/jrq/systolic_array_edge/dip/src/systolic_array_dip_4x4.v)

原因是：

- 外层 wrapper 更像标准 GEMM 黑盒
- 内层流式阵列才体现真正的对角传播

### 7.3 结构示意图

![DiP 数据流示意图](assets/dip_dataflow.svg)

图里可以直接把 `DiP` 读成：

- 黄色 `W` 仍然表示静止保存的权重
- 蓝色斜箭头表示 token 不是直上直下，而是对角传播
- 右侧 `wrap` 强调上一行输出会绕接到下一行
- 绿色框表示底部结果按行采集成 `output_row`

更准确地说，内层连接满足：

- 上一行的输出不会直接喂给下一行同列
- 而是“循环右移一列后”喂给下一行

### 7.4 外层 wrapper 该看哪些信号

在 [standard_dip_array_4x4.v](/home/jrq/systolic_array_edge/dip/src/standard_dip_array_4x4.v) 里，优先关注：

- `weight_row_valid`
- `weight_row_idx`
- `weight_row_data`
- `input_row_valid`
- `input_row_data`
- `prev_input_row_valid`
- `drain_pending_reg`
- `drain_issued_reg`
- `stream_input_row_valid`
- `stream_input_row_data`
- `captured_rows`
- `result_pending_reg`
- `result_valid`
- `busy`

### 7.5 内层流式阵列该看哪些信号

在 [systolic_array_dip_4x4.v](/home/jrq/systolic_array_edge/dip/src/systolic_array_dip_4x4.v) 里，优先关注：

- `pe_valid_in`
- `pe_data_in`
- `pe_psum_in`
- `pe_valid_out`
- `pe_data_out`
- `pe_psum_out`
- `row_ready`
- `row_capture_valid_reg`
- `row_capture_data_reg`
- `output_row_valid_reg`
- `output_row_data_reg`
- `activity_sr`
- `busy`

### 7.6 看波形时的推荐顺序

第一阶段：装载旋转后的权重

- `weight_row_valid` 拉高
- testbench 会先把 `b_matrix` 旋转成 `b_rot`

第二阶段：送入输入行

- `input_row_valid` 拉高
- `stream_input_row_valid` 正常跟随输入

第三阶段：观察自动 drain

- 当 `input_row_valid` 从 1 变 0 后
- `drain_pending_reg` 会被置位
- 下一拍 `stream_input_row_valid` 会自动再发一行全 0

第四阶段：观察逐行吐出结果

- 内层 `row_ready` 表示底部一整行结果齐了
- `row_capture_valid_reg` 先收一拍
- `output_row_valid_reg` 再寄存一拍
- 外层 `captured_rows` 逐行累加到 4
- 最终 `result_valid` 拉高

### 7.7 新手最容易误读的点

- `DiP` 不是 testbench 手工多等几拍就算正确，而是 RTL 里真的有 `drain` 逻辑
- 如果你只看外层 `result_valid`，会错过 DiP 最有特点的“逐行采集 + 对角传播”

---

## 8. 四种数据流放在一起怎么看

### 8.1 对比图

```text
WS: 权重静止，输入横向流，psum 纵向流
IS: 输入静止，权重纵向流，psum 横向流
OS: A/B 都流动，acc 本地静止
DiP: 权重近似静止，输入对角流，输出逐行收集
```

### 8.2 观察重点对照表

| 架构 | 先看哪个“驻留状态” | 先看哪个“流动状态” | 最后看什么 |
|------|--------------------|--------------------|------------|
| `WS` | `stored_weight` | `data_pipe` / `psum_pipe` | `result_buf` / `result_valid` |
| `IS` | `stored_input` | `weight_pipe` / `psum_pipe` | `result_buf` / `result_valid` |
| `OS` | `acc` | `a_pipe` / `b_pipe` | `accum_count` / `result_valid` |
| `DiP` | 旋转后权重 + 外层缓存 | `stream_input_row_valid` / `pe_*` | `captured_rows` / `result_valid` |

---

## 9. 如果你只想花 15 分钟学会怎么看

最推荐的路径是：

1. 先看 `WS`
2. 再看 `IS`
3. 再看 `OS`
4. 最后看 `DiP`

原因是：

- `WS` 最适合建立“静止 vs 流动”的第一印象
- `IS` 是把“谁静止”换了一下
- `OS` 会让你理解“部分和不一定要继续跨单元传播”
- `DiP` 则是更特殊的传播几何和输出收集方式

---

## 10. 和本页配套的文档

- `README.md`
- `docs/脉动阵列零基础上手与仓库导读_CN.md`
- `docs/数据流资料对照与前端实现评审_CN.md`
- `DATAFLOW_VALIDATION_STATUS_CN.md`

如果你准备边看边跑，建议把本页和波形窗口一起打开。这样你会更容易把：

- “概念上的数据流”
- “RTL 里的寄存器和连线”
- “波形里的真实时序”

三者对上。
