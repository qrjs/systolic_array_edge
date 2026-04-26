# Thesis Evidence Summary

该目录汇总论文实验证据链：功能回归、门级回归、FM、后端 DRC/connectivity、PPA 和版图产物。

- `summary.csv`: 机器可读总表
- `dataflow_compare.md`: 四数据流 PPA/验证横比
- `dip_ablation.md`: DiP plain/gated 消融
- `backend_status.md`: 后端产物和检查状态
- `layout_completeness.md`: 版图完整性、IO pad ring、VDD/VSS special nets 检查
- `handoff_manifest.md`: GDS/DEF/SDF/netlist/view 脚本 SHA256 清单
- `tapeout_gap.md`: Innovus 主线与 Calibre/foundry signoff 缺口
- `calibre_drc_summary.md`: Calibre DRC 非零规则聚合
- `calibre_lvs_summary.md`: Calibre LVS 错误/警告摘要
- `calibre_lvs_attempts.md`: Calibre LVS 多配置尝试对比
- `foundry_signoff_check.md`: 严格 Calibre DRC/LVS 签核检查，需运行 `make thesis-foundry-signoff` 生成
- `vector_manifest.md`: baseline + directed/random/sparse 向量清单
- `vector_activity_summary.md`: 向量稀疏度和理论 MAC 活动统计
- `gate_activity_summary.md`: Innovus SDF 门仿活动统计
- `validation_matrix.md`: 扩展验证完成矩阵
- `coverage_summary.md`: VCS/URG 覆盖率摘要
- `validation_summary.md`: baseline 或 thesis 扩展回归状态

Overall implementation evidence: `PASS`
