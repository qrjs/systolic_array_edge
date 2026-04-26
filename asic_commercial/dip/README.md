# DiP Commercial Flow

`asic_commercial/dip/` is the TSMC28 commercial backend mainline for the
standard DiP 4x4 core.

The default thesis path is clock-gated:

```bash
cd /home/host_1/systolic_array_edge
export TSMC28_ROOT=/opt/eda_tools/TSMC28

make thesis-dip-gated-opt
make thesis-dip
```

## Mainline

`make thesis-dip` runs:

1. prepare the local TSMC28 cache
2. RTL VCS file-vector suite
3. DiP gated DC profile sweep
4. DC Formality
5. gate suite `none`
6. gate suite `dc`
7. Innovus `all`
8. post-route Formality
9. gate suite `innovus`

Calibre DRC/LVS and Virtuoso import are explicit debug/signoff steps:

```bash
RUN_CALIBRE_DRC=1 RUN_CALIBRE_LVS=1 ./scripts/run_full_flow.sh
RUN_VIRTUOSO=1 VIRTUOSO_TECH_LIB=<oa_tech_lib_name> ./scripts/run_full_flow.sh
```

The current Calibre TSMC28 DRC/LVS entry points run, but their reports are not
yet signoff clean. Innovus internal connectivity/route/drc, post-route gate sim,
and Formality are the current default backend pass criteria.

The gated profile sweep tries:

- `gated_default`
- `gated_area`
- `gated_ultra_area`

Only candidates that pass DC, FM, and the full `none/dc` gate suite are
eligible. The selected candidate is the lowest parsed DC power result, then
lowest parsed cell area as the tie breaker.

## Vector Requirement

Gate suites default to `MIN_GATE_CASES=268`. The runner discovers all
`*_input.txt` / `*_expected.txt` pairs under `test_vectors/txt`; if more cases
are present, it runs them all.

## Useful Entrypoints

```bash
./scripts/check_handoff.sh
./scripts/run_frontsim_suite.sh
./scripts/run_dip_gated_opt.sh
./scripts/run_full_flow.sh
./scripts/run_postsim_suite.sh none dc innovus
./scripts/run_innovus.sh all
./scripts/run_calibre_drc.sh
./scripts/run_calibre_lvs.sh
./scripts/run_virtuoso_layout.sh
```

For IS/OS full flows, use:

```bash
make thesis-is
make thesis-os
make thesis-dio
```
