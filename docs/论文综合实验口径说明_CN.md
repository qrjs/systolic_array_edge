# 论文综合实验口径说明

更新时间：2026-04-21

## 1. 这份说明解决什么问题

当前仓库同时支持：

- 四种数据流的统一综合比较
- `DiP` 的时钟门控版本
- `DiP gated_auto` 的候选 profile 自动择优
- 一组更接近论文系统级同步开销的 `legacy` mesh 实现

这四类结果不能混着当作“纯数据流优劣”主结论。

从论文口径看，需要固定下面这条规则：

1. `WS / IS / OS / DiP` 的主表只使用统一 RTL 平台下的公平基线。
2. `DiP` 的时钟门控收益只做同架构消融。
3. `DiP gated_auto` 只能作为工程优化后的最佳实现点，不直接和 `WS / IS / OS` 基线做主结论横比。
4. 如果要讨论论文中“DiP 减少显式 FIFO / 同步开销”的动机，应单独引用 `legacy` 组，而不是拿 `std` 主表直接下结论。

## 2. 建议使用的 thesis tags

### 2.1 公平数据流基线

用于论文主文的数据流对比表：

```bash
ARCH_IMPL_STYLE=std \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
RUN_TAG=thesis_std_base_5ns \
./asic_commercial/syn/scripts/run_dc.sh base ws is os dip
```

使用规则：

- 主对比图只引用 `thesis_std_base_5ns`
- 这一组结果用于回答“统一 RTL 平台下四种数据流的综合表现”
- 不把这组结果表述成“纯理论数据流上限”

### 2.2 DiP 同架构消融

用于证明“我的改进有效”：

```bash
ARCH_IMPL_STYLE=std \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
GATED_ARCH_LIST=dip \
DIP_COMPILE_PROFILE=gated_default \
RUN_TAG=thesis_dip_std_cg_compile_5ns \
./asic_commercial/syn/scripts/run_dc.sh mixed dip
```

使用规则：

- 只拿它和 `thesis_std_base_5ns` 里的 `DiP base` 对比
- 这一组用于回答“加入边缘导向时钟门控后，DiP 本身改善了多少”
- 不拿它直接和 `WS / IS / OS base` 做论文主结论横比

### 2.3 DiP 工程最优点

用于附录、补充实验或工程实现展示：

```bash
ARCH_IMPL_STYLE=std \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
GATED_ARCH_LIST=dip \
DIP_COMPILE_PROFILE=gated_auto \
RUN_TAG=thesis_dip_std_cg_auto_5ns \
./asic_commercial/syn/scripts/run_dc.sh mixed dip
```

使用规则：

- 只能标为“工程优化后最佳实现点”
- 不拿去替代 `thesis_std_base_5ns` 的主表
- 如果图里出现它，必须明确注明：`gated_auto` 会在多个 compile profile 间自动择优

### 2.4 Paper-Style FIFO / Buffer 开销组

用于讨论论文中 `DiP` 通过减少显式同步 FIFO / 对齐缓冲而获益的架构动机：

```bash
ARCH_IMPL_STYLE=legacy \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
RUN_TAG=thesis_legacy_fifo_base_5ns \
./asic_commercial/syn/scripts/run_dc.sh base ws is os dip
```

这组的含义是：

- `WS / IS / OS` 走带 mesh 与同步 FIFO 的 handoff 顶层
- `OS legacy` 现在也会走 `systolic_array_os_4x4.v`，把输入/权重同步 FIFO 算进去
- `DiP` 走的是更接近论文传播方式的流式 handoff 顶层，而不是 `std` 的整块结果 wrapper

使用规则：

- 这组只用于讨论“系统级同步开销 / FIFO 开销 / 边界对齐开销”
- 不替代 `thesis_std_base_5ns` 的论文主表
- 如果引用它，必须明确注明它比较的是 `legacy mesh / handoff tops`，不是统一黑盒 wrapper
- 它更接近论文动机验证，不是统一接口下的最终工程结论

## 3. 如何解读 summary 里的新字段

`asic_commercial/syn/reports/<RUN_TAG>/summary.csv` 和 `summary.md` 现在会额外输出：

- `selected_profile`
- `gating_cells`
- `gated_regs`
- `gated_reg_ratio`

解释规则：

- `selected_profile`
  只在 `DiP gated` 运行里有意义，用于记录最后实际落地的是 `gated_default`、`gated_area` 还是 `gated_ultra_area`
- `gating_cells / gated_regs / gated_reg_ratio`
  用于标记时钟门控的实际插入结果，避免只写“用了 clock gating”但无法追溯门控规模
- 非门控运行会显示 `NA`

这几个字段的目的不是让主表更复杂，而是让后续答辩时能回答：

- 这组结果到底是不是自动挑选出来的
- 时钟门控到底插了多少
- 主表和附录图是不是同一种综合口径

## 4. 论文中的推荐表述

建议主文采用下面这类表述：

> 本文复现了 DiP 数据流语义，并在统一接口平台上完成 `WS / IS / OS / DiP` 四种数据流的工程化实现与综合比较。在此基础上，针对 DiP 进一步加入面向边缘场景的时钟门控与综合优化，用于评估改进型 DiP 的工程实现收益。

同时建议明确写出限制项：

> 需要指出的是，当前 `WS / IS / OS` 与 `DiP` 的 RTL 微结构并非完全同构，因此跨数据流的综合结果更适合作为统一工程平台下的实现比较，而不直接等价于纯数据流理论上限比较。

如果你需要讨论论文中 `DiP` 省去显式同步 FIFO 的优势，建议额外补一句：

> 为了观察边界同步与对齐开销对结果的影响，本文另外给出一组基于 `legacy` mesh / handoff top 的补充综合结果；这组结果仅用于说明论文中的系统级架构动机，不替代统一接口平台下的主比较表。

不建议再写成：

- “本文复现得到的 DiP 理论收益远高于原论文”
- “这说明 DiP 数据流本身天然优于其余三种很多”

更稳妥的写法是：

- “本文的绝对 PPA 同时受到 RTL 微结构与综合策略影响，因此不直接追求与原论文数值逐项一致”
- “改进型 DiP 在当前统一平台下体现出更好的工程实现潜力”

## 5. 一个要避免的常见误用

`all_mixed_std_200mhz` 这类 tag 适合做阶段性工程观察，但不建议直接拿来当论文主表。

原因是它把下面三件事混在了一起：

1. `DiP` 专属时钟门控
2. `DiP` 专属更激进的 compile profile 选择
3. `DiP std` 与 `WS / IS / OS std` 本身不同的 RTL 组织方式

如果要在论文里引用这类结果，必须明确标成：

- 工程优化展示
- 非公平基线
- 不作为纯数据流主结论

同样地，`thesis_legacy_fifo_base_5ns` 也不能直接替代主表。

它适合回答的是：

- `WS / IS / OS` 如果把 mesh 对齐 FIFO / 同步缓冲算进去，会发生什么
- `DiP` 的论文动机是否和“减少显式同步开销”一致

它不适合直接回答的是：

- 统一标准黑盒接口下，四种数据流谁最终更优
