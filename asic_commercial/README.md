# Commercial EDA Handoff

This directory is a separate staging area for commercial ASIC flows.

Design goals:

- keep the existing `asic/` handoff and open-source flow untouched
- prepare a clean place for DC/Genus/Innovus/PT/Tempus style bring-up
- avoid duplicating validated RTL and `SDC`; reference the existing files

Current first target:

- `DIP`

## Directory layout

- `dip/config/`: design metadata and library template files
- `dip/scripts/`: environment setup and handoff checks
- `dip/templates/`: commercial EDA script templates
- `dip/dc/`: reserved for synthesis outputs and vendor-specific scripts
- `dip/innovus/`: reserved for place-and-route setup
- `dip/pt/`: reserved for signoff timing setup
- `dip/logs/`, `dip/reports/`, `dip/results/`: generated outputs

## How this is meant to be used

1. Fill in `dip/config/libs.env` from `dip/config/libs.example.env`
2. Run `dip/scripts/check_handoff.sh`
3. Copy or adapt the templates in `dip/templates/` into your real tool runset
4. Keep tool-generated data inside `asic_commercial/`

## Notes

- This directory is preparation only. It does not assume a specific foundry kit.
- The current templates are intentionally conservative and require you to fill in
  real library, LEF, RC, and MMMC paths before use.
