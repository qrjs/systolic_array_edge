# 论文材料索引与版图状态

这份文档用于写论文时快速定位证据材料，并明确当前版图完成度和流片边界。

## 1. 论文主结论证据入口

优先使用 `reports/thesis/` 下的自动汇总结果：

- `reports/thesis/summary.md`: 总证据链入口。
- `reports/thesis/dataflow_compare.md`: WS/OS/IS/DiP 四种数据流的面积、功耗、时序和验证横向对比。
- `reports/thesis/dip_ablation.md`: DiP clock gating 前后消融；论文中用于说明 DiP 优化收益。
- `reports/thesis/layout_completeness.md`: 版图完整性、IO pad ring、VDD/VSS 状态。
- `reports/thesis/validation_matrix.md`: baseline 268 和扩展验证是否覆盖四个数据流及门仿。
- `reports/thesis/handoff_manifest.md`: GDS/DEF/SDF/netlist/view 脚本文件清单和 SHA256。

这些报告由下面命令刷新：

```bash
make thesis-report
make thesis-signoff
```

严格 foundry DRC/LVS 检查由下面命令刷新：

```bash
make thesis-foundry-signoff
```

论文写作材料工作区由下面命令生成：

```bash
make thesis-workspace
```

生成位置为 `work/thesis_materials/latest/`。其中 `reports/` 和 `docs/` 是论文常用材料拷贝，`layouts/` 默认使用符号链接指向正式 GDS/DEF/SDF/netlist，避免重复保存大文件。

## 2. 当前版图状态

四个数据流当前都达到 block-level hard macro 版图完成状态：

- GDS 和 DEF 均已生成。
- 顶层 signal pins 均合法放置，没有 illegal/unplaced pin。
- DEF 中存在 `VDD` 和 `VSS` SPECIALNETS，且标记为 POWER/GROUND。
- Innovus `verifyConnectivity` 和 Innovus DRC 为 PASS。
- 门级仿真使用 Innovus SDF，和前仿 baseline 一样覆盖 268 个用例；扩展验证结果见 `validation_matrix.md`。

当前不是 full-chip pad-ring 版图：

- `layout_completeness.md` 中四个数据流均为 `IO Pad Ring=NO`。
- `Pads=0`，说明没有 IO pad cell、ESD pad、独立 power pad、package bump 或 seal ring。
- 因此论文中应写为“完成 block-level 后端版图与交付物”，不要写成“已达到 foundry 可直接流片签核”。

## 3. 版图查看入口

四个数据流可分别查看版图：

```bash
./asic_commercial/ws/scripts/view_layout.sh
./asic_commercial/os/scripts/view_layout.sh
./asic_commercial/is/scripts/view_layout.sh
./asic_commercial/dip/scripts/view_layout.sh
```

版图交付物路径：

- WS: `asic_commercial/ws/results/innovus/ws_core_std_top_4x4.gds`
- OS: `asic_commercial/os/results/innovus/os_core_std_top_4x4.gds`
- IS: `asic_commercial/is/results/innovus/is_core_std_top_4x4.gds`
- DiP: `asic_commercial/dip/results/innovus/dip_core_std_top_4x4.gds`

对应 DEF、SDF、post-route netlist 和 LVS netlist 位于同一目录。

## 4. 写论文时建议引用的口径

可以写：

- 本项目完成了 WS、OS、IS、DiP 四种数据流在同一 TSMC28 商业 EDA 环境下的 RTL 前仿、DC 综合、Formality 等价验证、Innovus 后端实现、SDF 门级仿真和 GDS/DEF 交付。
- DiP 单独启用 clock gating，并在相同验证和后端流程下与 WS/OS/IS 对比面积、功耗和时序。
- 当前版图为 block-level hard macro，可用于同平台 PPA 和版图规模对比。

不要写：

- 已经完成 foundry clean tapeout。
- 已经有完整 IO pad ring/ESD/power pad。
- Calibre DRC/LVS 已 clean。

## 5. 流片前仍需补齐

真正达到标准可流片状态，还需要完成：

- full-chip IO pad ring、ESD、power pad、corner pad、可能的 seal ring。
- pad-to-core 供电网络和 package/封装相关约束。
- clean Calibre DRC。
- clean Calibre LVS。
- foundry deck 要求的 antenna、density、ERC、DFM 等 signoff 项。
- 最终 STA signoff corner、SI、IR drop、EM 等更完整的签核检查。

当前这些缺口已经整理到：

- `reports/thesis/foundry_signoff_check.md`
- `reports/thesis/tapeout_gap.md`
- `reports/thesis/calibre_drc_summary.md`
- `reports/thesis/calibre_lvs_summary.md`

## 6. 目录使用建议

论文写作时主要看：

- `reports/thesis/`: 表格、交付物、验证结果。
- `work/thesis_materials/latest/`: 写论文时更集中的材料工作区。
- `docs/`: 中文说明和论文口径。
- `asic_commercial/<arch>/results/innovus/`: 四个数据流的后端交付物。
- `asic_commercial/<arch>/reports/`: DC、FM、Innovus、Calibre 原始报告。

根目录若出现工具临时产物，执行：

```bash
make tidy-workspace
```

未跟踪的根目录 spillover 会被移动到 `work/root_artifacts/<timestamp>/`，源码、工艺库和正式报告目录不会被移动。
