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
- VCS gate-level post-simulation run script and testbench
- Synopsys Formality equivalence-check run script
- Synopsys ICC2 back-end run script and staged Tcl flow
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
- `<flow>/icc2/`: ICC2 work area
- `<flow>/calibre/`: Calibre notes and generated run area
- `<flow>/logs/`, `<flow>/reports/`, `<flow>/results/`: generated outputs

## Recommended use

1. Pick one flow directory such as `ws/`, `is/`, `os/`, or `dip/`
2. Fill in `<flow>/config/libs.env` from `<flow>/config/libs.example.env`
3. Run `<flow>/scripts/check_handoff.sh`
4. Run `<flow>/scripts/run_dc.sh`
5. Run `<flow>/scripts/run_fm.sh`
6. Run `<flow>/scripts/run_postsim.sh`
7. Run `<flow>/scripts/run_icc2.sh all`
8. Run `<flow>/scripts/run_calibre_drc.sh`
9. Run `<flow>/scripts/run_calibre_lvs.sh`

Detailed instructions are in `dip/README.md`, and `ws/README.md`, `is/README.md`, `os/README.md` are thin flow-specific entry notes.

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
```

Outputs:

- `asic_commercial/syn/reports/<RUN_TAG>/<arch>/`: per-architecture reports
- `asic_commercial/syn/mapped/<RUN_TAG>/`: mapped netlists and exported SDC
- `asic_commercial/syn/reports/<RUN_TAG>/summary.csv`
- `asic_commercial/syn/reports/<RUN_TAG>/summary.md`

The default `CONSTRAINT_MODE=uniform` is recommended when you want an apples-to-apples
comparison of area, power, and timing across architectures.
