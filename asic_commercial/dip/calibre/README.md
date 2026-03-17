# Calibre Wrappers

This directory intentionally does not ship foundry rule decks.

What is included:

- shell wrappers that launch Calibre DRC and LVS
- environment-variable conventions shared with `scripts/prepare_env.sh`

What you still need on the target server:

- a foundry-qualified DRC runset
- a foundry-qualified LVS runset
- the correct GDS and source netlist from ICC2 export

Recommended variables to fill in `config/libs.env`:

- `CALIBRE_DRC_RUNSET`
- `CALIBRE_LVS_RUNSET`
- `CALIBRE_LAYOUT_MODE`
- `CALIBRE_SOURCE_MODE`
