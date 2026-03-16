# ASIC Handoff Guide

This directory is a non-intrusive handoff area for ASIC frontend and backend work.

Goals:

- keep the existing FPGA/simulation flow untouched
- provide a stable top wrapper per architecture
- separate ASIC `SDC` constraints from Vivado `XDC`
- make backend bring-up easier for DC/Genus/Innovus/OpenROAD style flows

## Directory layout

- `asic/ws/`
- `asic/is/`
- `asic/os/`
- `asic/dip/`

Each architecture directory contains:

- `rtl/`: ASIC handoff wrapper top
- `constraints/`: ASIC `SDC`
- `filelist.f`: source list intended to be used from the repository root

The `flows/` directory contains open-source backend bring-up assets:

- `asic/flows/openroad/README.md`
- `asic/flows/openroad/dip/nangate45/config.mk`
- `asic/flows/openroad/run_orfs_dip.sh`

Commercial-flow staging is kept in a separate top-level directory:

- `asic_commercial/README.md`

## Recommended entry points

- `asic/is/rtl/is_core_top_4x4.v`
- `asic/dip/rtl/dip_core_top_4x4.v`

These two architectures are currently the best starting point because they already have cleaned core-only post-route timing results in the FPGA flow.

## Notes

- The wrappers are pass-through tops by design. They do not change the compute behavior.
- Current `SDC` files are a backend handoff baseline, not yet a final signoff constraint set.
- For the current project stage, keep FPGA `XDC` and ASIC `SDC` fully separated.
- The OpenROAD entry is intentionally isolated so it does not disturb the
  current Vivado, simulation, or regression flow.
