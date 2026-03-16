# OpenROAD Flow Handoff

This directory adds a non-intrusive OpenROAD-flow-scripts (ORFS) entry for the
ASIC wrappers under `asic/`.

Current first target:

- `DIP + Nangate45`

Goals:

- reuse the existing ASIC wrapper and `SDC`
- keep Vivado / FPGA flows untouched
- give backend a reproducible open-source bring-up path

## Directory layout

- `dip/nangate45/config.mk`: ORFS design config
- `run_orfs_dip.sh`: helper script for local ORFS or Docker-based ORFS runs

## Prerequisites

Option 1: local ORFS checkout

- extract or clone ORFS to `~/OpenROAD-flow-scripts`
- or set `ORFS_HOME=/path/to/OpenROAD-flow-scripts`
- install a matching OpenROAD/Yosys toolchain for that ORFS version

Option 2: Docker image

- install Docker
- make sure `openroad/orfs` can be pulled or is already present locally

## Recommended first runs

Smoke-check the config only:

```bash
ORFS_RUN_MODE=local \
./asic/flows/openroad/run_orfs_dip.sh -n synth
```

Run synthesis:

```bash
./asic/flows/openroad/run_orfs_dip.sh synth
```

If your machine only has local `yosys` but not local `openroad`, stop at the
mapped netlist stage:

```bash
ORFS_RUN_MODE=local \
./asic/flows/openroad/run_orfs_dip.sh netlist
```

Run a longer backend stage:

```bash
./asic/flows/openroad/run_orfs_dip.sh floorplan
./asic/flows/openroad/run_orfs_dip.sh place
./asic/flows/openroad/run_orfs_dip.sh route
```

Run the full flow:

```bash
./asic/flows/openroad/run_orfs_dip.sh finish
```

## Notes

- Results are written into the ORFS tree, not this repository.
- The config uses the current `asic/dip/rtl/dip_core_top_4x4.v` wrapper and
  `asic/dip/constraints/dip_core_top_4x4.sdc`.
- In `local` mode, the helper script auto-detects host `yosys` and `openroad`
  when they are available.
- This is a backend bring-up config, not a final signoff setup.
