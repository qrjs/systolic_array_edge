# Thesis Result Archive

更新时间：2026-04-21

## 归档内容

本归档只保留当前论文主对比最相关的两组结果：

- `reports/thesis_legacy_fifo_base_5ns/`
  `WS / IS / OS` 的 `legacy` 口径结果，包含 mesh / FIFO / 同步缓冲开销
- `reports/thesis_dip_std_cg_compile_5ns/`
  `DiP + gated_default` 结果，用于代表改进型 `DiP`

这份归档的目标很明确：

- 不再混入 `std_base`
- 不再把 `DiP legacy` 单独拿出来讲
- 只比较 `WS / IS / OS` 的带 FIFO 结果，和 `DiP + clock gating` 的结果

## 主对比表

| Arch / Group | Area | Dynamic (mW) | Leakage (mW) | 备注 |
| --- | ---: | ---: | ---: | --- |
| `WS legacy FIFO` | 217329.742435 | 5.891800 | 1.261900 | `ws_core_top_4x4` |
| `IS legacy FIFO` | 218703.545677 | 5.909700 | 1.274900 | `is_core_top_4x4` |
| `OS legacy FIFO` | 182253.660277 | 3.341600 | 1.165900 | `os_core_top_4x4` |
| `DiP + gated_default` | 186869.695249 | 2.672600 | 1.120500 | `dip_core_std_top_4x4`，`27` gating cells，`1757 / 1780` regs gated，`98.71%` |

## 关键对比

### `DiP + gated_default` 相对 `WS / IS / OS legacy FIFO`

| Compare | Area | Dynamic | Leakage |
| --- | ---: | ---: | ---: |
| `DiP + CG` vs `WS legacy FIFO` | `-14.02%` | `-54.64%` | `-11.21%` |
| `DiP + CG` vs `IS legacy FIFO` | `-14.56%` | `-54.78%` | `-12.11%` |
| `DiP + CG` vs `OS legacy FIFO` | `+2.53%` | `-20.02%` | `-3.89%` |

## 结论

- 如果把 `WS / IS / OS` 的 FIFO / 同步缓冲开销算进去，再和带时钟门控的 `DiP` 比，`DiP` 在功耗上优势很明显。
- 相对 `WS / IS`，`DiP + CG` 同时获得了更小面积、更低动态功耗和更低漏电。
- 相对 `OS`，`DiP + CG` 的动态和漏电也更低，但面积略大约 `2.53%`，所以不能写成“全面最优”。

更稳妥的论文表述是：

> 在计入 `WS / IS / OS` 的 FIFO / 同步缓冲开销后，改进型 `DiP` 在功耗方面表现出更明显的优势；其中，相对 `WS / IS` 同时体现出面积和功耗收益，而相对 `OS` 主要体现为功耗收益。

## 使用建议

- 如果你当前论文主线就是“带 FIFO 的传统数据流”对比“带时钟门控的改进型 `DiP`”，那这份归档就是主表口径。
- 如果后面还要保留“统一 `std` wrapper”口径，可以放到附录，不必再放进这份主归档里。

## 复现实验命令

```bash
# WS / IS / OS 的 legacy FIFO 基线
ARCH_IMPL_STYLE=legacy CONSTRAINT_MODE=uniform CLK_PERIOD=5.0 RUN_TAG=thesis_legacy_fifo_base_5ns \
./asic_commercial/syn/scripts/run_dc.sh base ws is os

# DiP + gated_default
ARCH_IMPL_STYLE=std CONSTRAINT_MODE=uniform CLK_PERIOD=5.0 GATED_ARCH_LIST=dip \
DIP_COMPILE_PROFILE=gated_default RUN_TAG=thesis_dip_std_cg_compile_5ns \
./asic_commercial/syn/scripts/run_dc.sh mixed dip
```
