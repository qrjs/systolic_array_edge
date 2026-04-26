# 商业 ASIC 流程上机说明

当前 thesis 主线使用 `TSMC28`，默认后端为 `Innovus`。三条数据流
`DIP/IS/OS` 都要完成：

```text
RTL VCS suite
-> DC
-> Formality
-> gate suite none/dc
-> Innovus
-> post-route Formality
-> gate suite innovus
-> optional Calibre DRC/LVS
-> optional Virtuoso GDS import
```

DiP 主线额外开启 clock gating，并在 `gated_default/gated_area/gated_ultra_area`
里选择同时通过 FM 和全量 gate suite 的低功耗、低面积候选。

## 1. 推荐入口

```bash
export TSMC28_ROOT=/opt/eda_tools/TSMC28

make thesis-check
make thesis-dip-gated-opt
make thesis-dip
make thesis-is
make thesis-os
make thesis-dio
```

## 2. 工具和资源

默认主线需要：

- `dc_shell`
- `fm_shell`
- `vcs`
- `innovus`
- TSMC28 12T 标准单元 `.db/.lib/.v/.lef/.gds/.spi`
- TSMC28 tech LEF、QRC

可选 signoff/view 需要：

- `calibre`
- `v2lvs`
- `strmin`
- `virtuoso`
- TSMC28 Calibre DRC/LVS runset
- 可 attach 的 Virtuoso OA tech lib，变量为 `VIRTUOSO_TECH_LIB`，只在 `RUN_VIRTUOSO=1` 时需要

如果本地还没有 cache，先跑：

```bash
./asic_commercial/dip/scripts/prepare_tsmc28_cache.sh
```

## 3. 单数据流调试

进入任意 flow 目录，例如：

```bash
cd asic_commercial/is
./scripts/check_handoff.sh
./scripts/run_frontsim_suite.sh
./scripts/run_dc.sh
./scripts/run_fm.sh
./scripts/run_postsim_suite.sh none dc
./scripts/run_innovus.sh all
FM_IMPLEMENTATION_MODE=innovus ./scripts/run_fm.sh
./scripts/run_postsim_suite.sh innovus
```

Signoff 调试入口单独跑：

```bash
RUN_CALIBRE_DRC=1 RUN_CALIBRE_LVS=1 ./scripts/run_full_flow.sh
RUN_VIRTUOSO=1 VIRTUOSO_TECH_LIB=<oa_tech_lib_name> ./scripts/run_full_flow.sh
./scripts/run_calibre_drc.sh
./scripts/run_calibre_lvs.sh
```

当前状态：Innovus 内部 connectivity/route/drc 检查可 clean，post-route 门仿和 Formality 可跑；Calibre signoff DRC/LVS 可启动但 report 尚未 clean，不能当作最终 tapeout signoff 结论。

Gate suite 默认要求至少 `268` 个 case。当前 `test_vectors/txt` 正好有
268 对 `*_input.txt` / `*_expected.txt`，如果之后增加向量，脚本会全部跑。

## 4. DiP Clock Gating

DiP gated profile sweep:

```bash
./asic_commercial/dip/scripts/run_dip_gated_opt.sh
```

输出：

- `asic_commercial/dip/gated_opt/summary.csv`
- `asic_commercial/dip/gated_opt/selected.env`
- `asic_commercial/dip/results/dip_core_std_top_4x4_dc_gated.v`
- `asic_commercial/dip/results/dip_core_std_top_4x4_dc_gated.sdf`

只有 DC、FM、`none/dc` gate suite 都通过的 profile 会被选择。
