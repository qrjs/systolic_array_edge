# DIP Commercial Flow Tutorial

这个目录现在按 `VCS -> DC -> FM -> ICC2 -> Calibre` 来组织 `dip_core_top_4x4` 的后续 ASIC 流程。

## 设计输入

直接复用仓库里已经验证过的 handoff：

- RTL wrapper: `asic/dip/rtl/dip_core_top_4x4.v`
- filelist: `asic/dip/filelist.f`
- SDC: `asic/dip/constraints/dip_core_top_4x4.sdc`

## 目录说明

- `config/design.env`: 设计名、时钟、输入文件路径
- `config/libs.example.env`: 商用工具相关库、tech、runset 变量模板
- `scripts/check_handoff.sh`: 检查 RTL/filelist/SDC
- `scripts/check_backend_inputs.sh`: 检查各阶段环境变量和输入文件
- `scripts/run_dc.sh`: 跑 DC 综合
- `scripts/run_fm.sh`: 跑 Formality
- `scripts/run_postsim.sh`: 跑 VCS gate-level 后仿真
- `scripts/run_icc2.sh`: 跑 ICC2
- `scripts/run_calibre_drc.sh`: 跑 Calibre DRC
- `scripts/run_calibre_lvs.sh`: 跑 Calibre LVS

## 第一步：准备 `libs.env`

在目标服务器上：

```bash
cd asic_commercial/dip
cp config/libs.example.env config/libs.env
```

至少需要填写：

- `TARGET_LIBRARY`
- `LINK_LIBRARY`
- `SIM_LIBRARY_VERILOG`
- `ICC2_TECH_FILE`
- `ICC2_REFERENCE_LIBS`
- `TLUPLUS_MAX`
- `TLUPLUS_MIN`
- `TLUPLUS_MAP`
- `POWER_NET`
- `GROUND_NET`
- `PLACE_SITE`
- `CORE_UTILIZATION`
- `CORE_MARGIN_LEFT`
- `CORE_MARGIN_BOTTOM`
- `CORE_MARGIN_RIGHT`
- `CORE_MARGIN_TOP`
- `CALIBRE_DRC_RUNSET`
- `CALIBRE_LVS_RUNSET`

常见可选项：

- `ADDITIONAL_SIM_VERILOGS`
- `POSTSIM_SDF_MODE="dc" | "icc2" | "none" | "custom"`
- `FM_IMPLEMENTATION_MODE="dc" | "icc2" | "custom"`
- `ICC2_NETLIST_MODE="dc" | "custom"`
- `CUSTOM_NETLIST`
- `CUSTOM_SDF`
- `GDS_STREAM_OUT_MAP`
- `ICC2_OVERWRITE_LIB="1"`

## 第二步：先做输入检查

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh dc
./scripts/check_backend_inputs.sh fm
./scripts/check_backend_inputs.sh postsim
./scripts/check_backend_inputs.sh icc2
./scripts/check_backend_inputs.sh calibre_drc
./scripts/check_backend_inputs.sh calibre_lvs
```

在 DC 还没跑之前，`fm/postsim/icc2/calibre_*` 提示综合网表或 GDS 尚不存在是正常的。

## 第三步：跑 DC

```bash
./scripts/run_dc.sh
```

如果你的环境二进制名不同：

```bash
DC_SHELL_BIN=dc_shell-xg-t ./scripts/run_dc.sh
```

DC 主要输出：

- `results/dip_core_top_4x4_dc.v`
- `results/dip_core_top_4x4_dc.sdc`
- `results/dip_core_top_4x4_dc.sdf`
- `results/dip_core_top_4x4_dc.svf`
- `reports/dip_core_top_4x4_dc_*.rpt`

## 第四步：跑 FM

默认比较 `RTL vs DC netlist`：

```bash
./scripts/run_fm.sh
```

如果后面想比较 `RTL vs ICC2 exported netlist`，把 `FM_IMPLEMENTATION_MODE` 改成 `icc2` 后再跑。

FM 主要报告在：

- `reports/fm/`

## 第五步：跑 VCS gate-level 后仿真

默认使用 `DC netlist + DC SDF`：

```bash
./scripts/run_postsim.sh
```

只跑单个测试向量：

```bash
INPUT=../../test_vectors/txt/batch_000_input.txt \
EXPECTED=../../test_vectors/txt/batch_000_expected.txt \
./scripts/run_postsim.sh
```

改成 `ICC2 SDF` 做 post-route 后仿真时：

```bash
POSTSIM_SDF_MODE=icc2 ./scripts/run_postsim.sh
```

主要输出：

- `postsim/work/*.simv`
- `postsim/logs/*.compile.log`
- `postsim/logs/*.run.log`
- `postsim/logs/postsim_summary.log`

## 第六步：跑 ICC2

支持分阶段：

```bash
./scripts/run_icc2.sh init
./scripts/run_icc2.sh floorplan
./scripts/run_icc2.sh power
./scripts/run_icc2.sh place
./scripts/run_icc2.sh cts
./scripts/run_icc2.sh route
./scripts/run_icc2.sh export
```

也支持一次跑完整条流：

```bash
./scripts/run_icc2.sh all
```

如果你习惯叫 `iccw`，也可以直接：

```bash
./scripts/run_iccw.sh all
```

ICC2 主要输出：

- `results/icc2/dip_core_top_4x4_icc2.v`
- `results/icc2/dip_core_top_4x4_icc2.def`
- `results/icc2/dip_core_top_4x4_icc2.sdf`
- `results/icc2/dip_core_top_4x4_icc2.spef`
- `results/icc2/dip_core_top_4x4_icc2.gds`
- `reports/icc2/*.rpt`

说明：

- 这套 ICC2 Tcl 是通用骨架，power plan 和 stream-out 细节通常还要按你的 PDK 命名微调
- `ICC2_OVERWRITE_LIB=1` 时，重新跑 `init/all` 会覆盖 `icc2/work/*.dlib`

## 第七步：跑 Calibre

DRC：

```bash
./scripts/run_calibre_drc.sh
```

LVS：

```bash
./scripts/run_calibre_lvs.sh
```

说明：

- 这里不包含 foundry rule deck 本体，只包装了运行入口
- `CALIBRE_DRC_RUNSET` 和 `CALIBRE_LVS_RUNSET` 需要你在目标服务器上指向真实 runset
- 默认 Calibre 输入来自 ICC2 导出的 `GDS + netlist`

## 推荐执行顺序

```bash
./scripts/check_handoff.sh
./scripts/run_dc.sh
./scripts/run_fm.sh
./scripts/run_postsim.sh
./scripts/run_icc2.sh all
POSTSIM_SDF_MODE=icc2 ./scripts/run_postsim.sh
FM_IMPLEMENTATION_MODE=icc2 ./scripts/run_fm.sh
./scripts/run_calibre_drc.sh
./scripts/run_calibre_lvs.sh
```

## 迁移建议

- 直接整体拷贝 `asic_commercial/`
- 不要改动 `asic/` 下已经验证过的 RTL 和 SDC
- 在新服务器上只改 `config/libs.env`
- 第一次上机先跑 `check_handoff.sh` 和 `check_backend_inputs.sh`
