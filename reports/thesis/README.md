# Thesis Report Index

这个目录是论文写作和答辩时优先引用的证据入口。所有表都由 `make thesis-report` 重新生成，严格 Calibre 签核检查由 `make thesis-foundry-signoff` 生成。

如果需要一个更集中的写作工作区，运行：

```bash
make thesis-workspace
```

生成目录为 `work/thesis_materials/latest/`，会拷贝常用报告/文档，并用符号链接整理四个数据流的 GDS/DEF/SDF/netlist。

## 先看这几份

- `summary.md` / `summary.csv`: 总入口，汇总四个数据流的功能、门仿、FM、后端 DRC/connectivity 和交付物状态。
- `key_evidence.md` / `key_evidence.csv`: 按 RTL 前仿、DC、FM、Innovus、门仿、Calibre 和版图交付组织的原文证据索引。
- `dataflow_compare.md`: WS/OS/IS/DiP 的统一 PPA 对比表。
- `dip_ablation.md`: DiP plain vs clock-gated 消融结果；当前只有 DiP 开启 clock gating。
- `layout_completeness.md` / `layout_completeness.csv`: 版图是否完整、是否有 IO pad ring、VDD/VSS 是否存在。
- `validation_matrix.md`: baseline 268 和扩展 directed/random/sparse 验证矩阵。
- `handoff_manifest.md` / `handoff_manifest.csv`: GDS/DEF/SDF/netlist/view 脚本的文件大小和 SHA256。

## 版图结论

当前 WS/OS/IS/DiP 四个数据流均完成 block-level hard macro 版图交付：GDS/DEF 存在，顶层 signal pins 合法放置，VDD/VSS 以 DEF SPECIALNETS 形式存在，Innovus connectivity 和 Innovus DRC 为 PASS。

当前四个数据流都不是 full-chip pad-ring 版图：`layout_completeness.md` 中 `IO Pad Ring=NO`、`Pads=0`。也就是说它们适合论文中的同平台后端 PPA/版图对比，但不能直接作为含 IO pad、ESD、power pad、seal ring 的完整流片版图。

## 版图查看

- WS: `asic_commercial/ws/scripts/view_layout.sh`
- OS: `asic_commercial/os/scripts/view_layout.sh`
- IS: `asic_commercial/is/scripts/view_layout.sh`
- DiP: `asic_commercial/dip/scripts/view_layout.sh`

对应交付物位于 `asic_commercial/<arch>/results/innovus/`：

- `<design>.gds`
- `<design>.def`
- `<design>_innovus.v`
- `<design>_innovus_lvs.v`
- `<design>_innovus.sdf`

## 流片缺口

- `signoff_check.md`: 论文实现证据链检查，当前应为 PASS。
- `foundry_signoff_check.md`: 严格 Calibre DRC/LVS 检查，当前为 FAIL，用来说明距离真正 foundry tapeout 还有缺口。
- `calibre_drc_summary.md`: 非零 Calibre DRC rule 聚合。
- `calibre_lvs_summary.md`: 当前 Calibre LVS mismatch 摘要。
- `calibre_lvs_attempts.md`: 不同 LVS 调试配置的对比。
- `tapeout_gap.md`: 把已完成的 Innovus 主流程和未完成的 foundry signoff 分开列出。

论文表述建议保持这个边界：本项目完成了四种数据流在同一 TSMC28 商业后端环境下的 block-level 前后端复现、验证和 PPA 对比；严格可流片还需要 full-chip IO/ESD/power pad 集成和 clean Calibre DRC/LVS。
