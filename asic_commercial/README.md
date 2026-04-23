# Commercial EDA Handoff

`asic_commercial/` is the isolated staging area for commercial ASIC tools.

中文上机说明见 `FLOW_BRINGUP_CN.md`。

Current delivered targets:

- `ws`
- `is`
- `os`
- `dip`
- `i2c` (DC-only helper runset for external I2C RTL)

Design goals:

- keep the existing `asic/` handoff and open-source flow untouched
- reuse the validated RTL, filelist, and `SDC`
- provide a copy-friendly commercial runset for another server

## What is included

For each dataflow under `ws/`, `is/`, `os/`, and `dip/`, this directory now contains:

- Synopsys DC synthesis run script and Tcl runset
- VCS RTL file-vector front-simulation run script
- VCS gate-level post-simulation run script and testbench
- Synopsys Formality equivalence-check run script
- Cadence Innovus back-end run script and staged Tcl flow for the `dip` mainline
- Calibre DRC/LVS wrapper scripts
- environment checking scripts
- a Chinese tutorial for bring-up and execution order

Additionally, `i2c/` contains a lightweight Synopsys DC runset derived from a
teacher-provided synthesis script. It is intended for external RTL such as
`ftp/i2c_master_*.v` that is not part of this repository.

## Directory layout

- `<flow>/config/`: design metadata and foundry/library placeholders
- `<flow>/scripts/`: environment prep, checks, and run entry points
- `<flow>/dc/`: DC work area
- `<flow>/postsim/`: VCS gate-level simulation workspace
- `<flow>/fm/`: Formality work area
- `<flow>/innovus/`: Innovus work area
- `<flow>/calibre/`: Calibre notes and generated run area
- `<flow>/logs/`, `<flow>/reports/`, `<flow>/results/`: generated outputs

## Recommended use

对当前 `SMIC40 thesis` 主线，推荐只记下面几条命令：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
make thesis-check
make thesis-synth
make thesis-dip
make thesis-dip-gated-debug
make thesis-innovus-gui
make thesis-virtuoso
```

它们分别对应：

- `thesis-check`
  检查 EDA 工具环境、`SMIC40_PDK_ROOT`、`DiP` 静态输入
- `thesis-synth`
  跑论文主表综合：
  `ws/is/os legacy FIFO` + `dip std + gated_default`
- `thesis-dip`
  跑 `DiP` functional backend track：
  `plain DC -> gate suite(none) -> gate suite(dc) -> Innovus -> gate suite(innovus) -> Virtuoso`
- `thesis-dip-gated-debug`
  跑 `DiP` gated debug track：
  `gated DC -> FM -> batch_000 + signed_mix`
- `thesis-innovus-gui`
  打开 `Innovus GUI` 看版图
- `thesis-virtuoso`
  导入 `Innovus GDS` 并打开 `Virtuoso layout`

## Current Status

截至当前代码状态，仓库已经把 `dip` 的正式后端主线切到 `Cadence Innovus + Virtuoso`。

需要注意：

- `make thesis-check` 与 `make thesis-synth` 仍然是最先执行的两步
- `make thesis-dip` 现在走 functional backend track
- `make thesis-dip-gated-debug` 单独承担 gated 功能偏差定位
- 当前工作区没有真实 `dc_shell / innovus / virtuoso` 环境，因此这次改动只能做静态落地与脚本验证，端到端结论仍要以目标服务器实测为准

Detailed instructions are in `dip/README.md`, and `ws/README.md`, `is/README.md`, `os/README.md` are thin flow-specific entry notes.

Note on flow split:

- `asic_commercial/syn/` remains the centralized four-architecture PPA comparison flow.
- `asic_commercial/ws|is|os/` keep standard-API wrappers for clean file-vector frontsim/postsim reuse.
- `asic_commercial/dip/` is centered on the thesis mainline `dip_core_std_top_4x4` wrapper for short-command runs, while still preserving the legacy handoff path in separate config files.

## Standardized multi-architecture synthesis

`asic_commercial/syn/scripts/run.tcl` is the common DC entry point for
comparing `ws`, `is`, `os`, and `dip` with a unified setup.

Examples:

```bash
dc_shell -f asic_commercial/syn/scripts/run.tcl

ARCH_LIST="ws is os dip" \
RUN_MODE=base \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
RUN_TAG=all_core_base \
dc_shell -f asic_commercial/syn/scripts/run.tcl

ARCH_LIST="ws,dip" \
RUN_MODE=ultra \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=1.0 \
RUN_TAG=ws_dip_1ghz \
dc_shell -f asic_commercial/syn/scripts/run.tcl

ARCH_LIST="ws is os dip" \
RUN_MODE=mixed \
GATED_ARCH_LIST=dip \
CLK_PERIOD=5.0 \
RUN_TAG=all_mixed_200mhz \
dc_shell -f asic_commercial/syn/scripts/run.tcl

./asic_commercial/syn/scripts/run_dc.sh compare
./asic_commercial/syn/scripts/run_dc.sh mixed

make dc-compare
```

Short commands:

- `./asic_commercial/syn/scripts/run_dc.sh base`
- `./asic_commercial/syn/scripts/run_dc.sh ultra`
- `./asic_commercial/syn/scripts/run_dc.sh compare`
- `./asic_commercial/syn/scripts/run_dc.sh mixed`
- `make dc-base`
- `make dc-ultra`
- `make dc-compare`

Outputs:

- `asic_commercial/syn/reports/<RUN_TAG>/<arch>/`: per-architecture reports
- `asic_commercial/syn/mapped/<RUN_TAG>/`: mapped netlists and exported SDC
- `asic_commercial/syn/reports/<RUN_TAG>/summary.csv`
- `asic_commercial/syn/reports/<RUN_TAG>/summary.md`

The merged summary now also records:

- `selected_profile`: the actual DiP gated profile chosen during `gated_auto`
- `gating_cells`, `gated_regs`, `gated_reg_ratio`: parsed clock-gating insertion stats

The default `CONSTRAINT_MODE=uniform` is recommended when you want an apples-to-apples
comparison of area, power, and timing across architectures.

When `RUN_MODE=compare`, the script runs both `base` and `ultra`, stores detailed
reports under:

- `asic_commercial/syn/reports/<RUN_TAG>/base/<arch>/`
- `asic_commercial/syn/reports/<RUN_TAG>/ultra/<arch>/`

and emits one merged `summary.csv` / `summary.md` at `asic_commercial/syn/reports/<RUN_TAG>/`.

When `RUN_MODE=mixed`, the script runs one shared constraint point and selects
the compile strategy per architecture:

- architectures in `GATED_ARCH_LIST` use normal `compile` after clock-gating insertion
- all other architectures use normal `compile` without clock gating

This is useful for side-by-side comparisons such as `dip` with clock gating
versus `ws/is/os` at normal synthesis under the same `200 MHz` target.

For the current thesis mainline, the recommended short command is:

```bash
make thesis-synth
```

Internally this runs:

- `ws/is/os` with `ARCH_IMPL_STYLE=legacy`
- `dip` with `ARCH_IMPL_STYLE=std` and `DIP_COMPILE_PROFILE=gated_default`

For `dip`, the default `DIP_COMPILE_PROFILE=gated_auto` benchmarks `gated_area`
and `gated_ultra_area` at the same constraint point, then prefers:

- timing `MET`
- lower total cell area
- lower dynamic power as the tiebreaker
