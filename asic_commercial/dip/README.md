# DIP Commercial Flow Prep

This folder prepares the `DIP` wrapper for later commercial EDA work.

Referenced project handoff files:

- RTL wrapper: `asic/dip/rtl/dip_core_top_4x4.v`
- filelist: `asic/dip/filelist.f`
- SDC: `asic/dip/constraints/dip_core_top_4x4.sdc`

Suggested commercial flow order:

1. DC or Genus synthesis
2. Innovus place-and-route
3. PrimeTime or Tempus signoff timing
4. Power analysis with VCD/SAIF when activity is ready

## First steps

1. Edit `config/libs.example.env` into `config/libs.env`
2. Run `scripts/check_handoff.sh`
3. Use `templates/dc_setup.tcl` or `templates/innovus_mmmc.tcl` as your starting point

## Output policy

- Put synthesis netlists in `results/`
- Put tool logs in `logs/`
- Put reports in `reports/`
- Keep vendor runsets local to this directory so they do not affect the
  validated open-source flow
