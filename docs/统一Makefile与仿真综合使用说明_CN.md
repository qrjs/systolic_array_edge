# 统一 Makefile 使用说明（仿真/验证/综合）

本文档面向日常开发与论文实验，目标是：

- 用统一命令跑通四架构（WS/IS/OS/DIP）
- 一键完成功能验证与后端综合
- 自动产出可直接写论文的汇总指标表

---

## 1. 架构与入口

仓库包含四种 `4x4` 数据流实现：

- `ws/`：Weight Stationary
- `is/`：Input Stationary
- `os/`：Output Stationary
- `dip/`：DiP

统一入口：

- 根目录 `Makefile`

建议优先在仓库根目录执行命令。

命令查看方式：

- `make help`：查看推荐主入口
- `make help-all`：查看完整命令列表

---

## 2. 高频命令速查

优先记住下面 6 个主入口：

```bash
# 单架构功能仿真
make run ARCH=ws

# 单架构生成波形
make wave ARCH=dip

# 打开波形（默认 Surfer）
make open ARCH=ws

# 四架构固定向量回归
make regress

# 四架构综合 + 汇总
make backend

# 单架构布局布线（post-route）
make impl ARCH=is

# 端到端一键验证（推荐）
make verify
```

兼容旧别名仍保留，例如：

```bash
make ws
make ws-vcs
make dip-wave
make surfer ARCH=ws
make txt
make verify-full
```

---

## 3. 命令分层

建议把入口分成两层理解：

- 主入口：`run / wave / open / regress / backend / verify`
- 兼容入口：`ws / ws-vcs / txt / verify-full / dip-wave` 等历史命令

第一次上手时，只需要先记住主入口。

### 3.1 功能仿真

推荐主入口：

```bash
make run ARCH=ws
make run ARCH=is
make run ARCH=os
make run ARCH=dip
```

指定 `VCS`：

```bash
make run ARCH=ws SIM=vcs
make run ARCH=dip SIM=vcs
```

兼容别名：

```bash
make ws-vcs
make is-vcs
make os-vcs
make dip-vcs
```

### 3.2 波形

生成波形：

```bash
make wave ARCH=ws
make wave ARCH=dip
```

查看波形：

```bash
make open ARCH=ws
make open ARCH=dip SIM=vcs
make open ARCH=ws VIEWER=verdi
```

兼容别名：

```bash
make surfer ARCH=ws
make surfer-vcs ARCH=dip
make ws-verdi
```

### 3.3 回归

推荐主入口：

```bash
make regress
make regress SIM=vcs
```

单架构 `.txt` 回归：

```bash
make ws-txt
make is-txt
make os-txt
make dip-txt
```

四架构统一回归：

```bash
make regress
make txt-all-vcs
```

随机/批量：

```bash
make random-iverilog
make batch-iverilog
```

### 3.4 综合与后端指标

推荐主入口：

```bash
make backend
make report
make impl-summary
```

单架构综合：

```bash
make synth ARCH=ws
make synth ARCH=is
make synth ARCH=os
make synth ARCH=dip
```

四架构综合：

```bash
make backend
```

汇总表生成：

```bash
make report
```

输出：

- `test_logs/synth_summary/synth_metrics.csv`
- `test_logs/synth_summary/synth_metrics.md`
- `test_logs/impl_summary/impl_metrics.csv`
- `test_logs/impl_summary/impl_metrics.md`

---

## 4. 一键验证入口

### 4.1 功能完备性

```bash
make regress
```

含义：执行四架构统一固定向量回归（默认 `iverilog`）。

### 4.2 后端完备性

```bash
make backend
```

含义：执行四架构综合并生成统一指标表。

### 4.3 端到端验证（推荐）

```bash
make verify
```

含义：按“功能验证 -> 后端综合 -> 指标汇总”顺序一次跑完。

如需查看全部底层命令，可执行：

```bash
make help-all
```

---

## 5. 如何解读汇总指标

`synth_metrics.md` 中每行对应一个架构，核心字段：

- `LUT / FF / DSP`：资源开销
- `WNS(ns)`：setup 裕量（<0 表示 setup 违例）
- `WHS(ns)`：hold 裕量（<0 表示 hold 违例）
- `TotalPower(W) / Dynamic(W)`：综合态 vectorless 功耗估计

注意：

- 综合态功耗仅用于趋势比较，不等同于最终板级实测功耗。
- 建议后续补 `place&route` 后报告，作为论文最终 PPA 结论。

`impl_metrics.md` 中每行对应一个架构，核心字段：

- `STATUS`：`READY` 表示该架构已生成 post-route 报告，`MISSING` 表示尚未执行 `make impl ARCH=<arch>`
- `PostRouteWNS(ns)`：布局布线后的 setup 裕量
- `PostRouteWHS(ns)`：布局布线后的 hold 裕量
- `PostRouteFmax(MHz)`：按 `Fmax = 1000 / (Tclk - WNS)` 估算的 post-route 频率

说明：

- 当前 `impl` 采用 `out_of_context` 的 core-only 实现流，主要用于观察阵列核心本身的时序能力。
- 这组数据适合论文中的“核心级后端时序”对比，不等同于带完整板级 I/O 的 full-chip 最终频率。
- DIP 当前的 hold 修复来自更合理的输入最小延迟建模，反映的是 OOC 边界条件，而不是 RTL 功能变化。

---

## 6. 目录约定

- 回归日志：`test_logs/multi_arch_txt`
- 综合报告：`<arch>/reports/synth`
- post-route 报告：`<arch>/reports/impl`
- 综合中间日志：`<arch>/sim/vivado`
- 综合汇总：`test_logs/synth_summary`
- post-route 汇总：`test_logs/impl_summary`

---

## 7. 推荐实验流程（论文）

1. 功能正确性：`make regress`
2. 后端指标：`make backend`
3. post-route 时序：`make impl ARCH=is`、`make impl ARCH=dip`
4. 导出汇总表：`make report`
5. 一致性复核：重复不同 seed 的随机回归

---

## 8. 常见问题

1. `WHS` 为负怎么办？  
综合阶段出现轻微 hold 负裕量很常见，建议在 `route` 后再看最终 hold。

2. `WNS` 为负怎么办？  
说明 setup 不满足目标时钟，优先处理关键路径流水化或寄存器重定时。

3. 功耗值看起来偏高/偏低？  
先确认约束完整（尤其 DIP 的 XDC），再比较同条件下四架构相对趋势。

4. 为什么 `impl` 只建议先跑 `IS/DIP`？  
当前完整验证顶层 I/O 很多，直接做 full-chip 实现会受器件管脚数限制；因此先用 core-only OOC 流拿 post-route 时序更合理。
