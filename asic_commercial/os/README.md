# OS Commercial Flow

`os` uses the same commercial flow skeleton as `dip`, but with the OS ASIC handoff files and an OS-specific gate-level selftest bench.

Quick start:

```bash
cd asic_commercial/os
cp config/libs.example.env config/libs.env
./scripts/check_handoff.sh
./scripts/run_dc.sh
./scripts/run_fm.sh
./scripts/run_postsim.sh
./scripts/run_icc2.sh all
./scripts/run_calibre_drc.sh
./scripts/run_calibre_lvs.sh
```

For detailed variable descriptions, see `../dip/README.md`.
