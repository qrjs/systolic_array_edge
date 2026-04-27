# Key Raw Evidence

这份索引用于答辩和论文复核时快速定位“原文证据”。`reports/thesis/*.md` 是汇总表；下面列出的 `asic_commercial/.../*.rpt`、`*.rep`、`*.results` 和 `reports/thesis/runs/logs/*.log` 是对应步骤的原始工具输出。

## Evidence Scope

- 四个数据流：`WS`、`OS`、`IS`、`DIP`
- 后端主线：TSMC28 commercial flow，Innovus block-level layout
- 综合口径：`WS/OS/IS` 使用 `plain`，`DIP` 使用 `gated`
- 原文证据已纳入 git 的范围：小型 DC/FM/Innovus/Calibre 报告、论文验证 run logs、综合批量报告
- 未纳入 git 的范围：GDS/DEF/SDF/netlist/checkpoint 等大生成物；用 `handoff_manifest.md` 记录大小和 SHA256

## Step Evidence Map

| Step | What It Proves | Summary Entry | Raw Evidence |
| --- | --- | --- | --- |
| RTL front simulation | 四个数据流功能向量通过 | `validation_matrix.md`, `reports/thesis/runs/validation_summary.md` | `reports/thesis/runs/logs/<arch>_front_<case>.log` |
| DC synthesis | 面积、功耗、时序、约束和设计检查 | `dataflow_compare.md`, `dip_ablation.md` | `asic_commercial/<arch>/reports/<design>_dc_<flavor>_*.rpt` |
| Batch synthesis archive | 最新批量综合原文，用于复核跨数据流综合结果 | `dataflow_compare.md` | `asic_commercial/syn/reports/thesis_std_base_5ns/`, `asic_commercial/syn/reports/thesis_dip_std_cg_compile_5ns/` |
| Formality after DC | RTL vs DC netlist 等价 | `backend_status.md`, `signoff_check.md` | `asic_commercial/<arch>/reports/fm/<design>_fm_dc_<flavor>_summary.rpt` |
| Innovus place/route | post-route timing/power/area、pin、DRC、connectivity、route | `backend_status.md`, `layout_completeness.md` | `asic_commercial/<arch>/reports/innovus/<design>_*.rpt` |
| Formality after Innovus | RTL/DC reference vs Innovus netlist 等价 | `backend_status.md`, `signoff_check.md` | `asic_commercial/<arch>/reports/fm/<design>_fm_innovus_<flavor>_summary.rpt` |
| Gate simulation | Innovus SDF 门级验证通过 | `validation_matrix.md`, `signoff_check.md` | `reports/thesis/runs/logs/<arch>_gate_innovus_<case>.log` |
| Calibre DRC | foundry deck DRC 尝试和剩余缺口 | `calibre_drc_summary.md`, `foundry_signoff_check.md` | `asic_commercial/<arch>/reports/calibre/<design>_drc_backend.rep`, `.results` |
| Calibre LVS | foundry LVS 尝试和 mismatch 证据 | `calibre_lvs_summary.md`, `calibre_lvs_attempts.md` | `asic_commercial/<arch>/reports/calibre/<design>_lvs_ports_only_nostdlib.rep`, `.rep.ext` |
| Layout handoff | GDS/DEF/SDF/netlist 存在性、大小、SHA256、查看入口 | `handoff_manifest.md`, `layout_completeness.md` | `asic_commercial/<arch>/results/innovus/` is local generated payload; manifest is tracked |

## Per-Arch Raw Report Roots

| Arch | Design | DC Flavor | Raw Report Root |
| --- | --- | --- | --- |
| WS | `ws_core_std_top_4x4` | `plain` | `asic_commercial/ws/reports/` |
| OS | `os_core_std_top_4x4` | `plain` | `asic_commercial/os/reports/` |
| IS | `is_core_std_top_4x4` | `plain` | `asic_commercial/is/reports/` |
| DIP | `dip_core_std_top_4x4` | `gated` | `asic_commercial/dip/reports/` |

## Validation Log Scope

The raw validation logs kept in git include:

- Front simulation: `directed`, `sparse_00/25/50/75/90`, `random_seed_2026042601` to `random_seed_2026042605`
- Innovus gate simulation: `directed`, `sparse_90`, `random_seed_2026042601`

The thesis workspace links the representative subset used most often during writing: `directed`, `sparse_90`, and `random_seed_2026042601`. Full validation coverage is summarized in `reports/thesis/runs/validation_summary.md` and `reports/thesis/validation_matrix.md`.

## Workspace Packaging

Run:

```bash
make thesis-workspace
```

The generated `work/thesis_materials/latest/evidence_manifest.csv` links the raw evidence above into a single per-arch evidence tree:

- `evidence/ws/`
- `evidence/os/`
- `evidence/is/`
- `evidence/dip/`
