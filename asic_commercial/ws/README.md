# WS Commercial Flow

`ws` uses the same commercial flow skeleton as `dip`, with the backend wired for the local `TSMC28 + Innovus` toolchain.

Quick start:

```bash
cd /home/host_1/systolic_array_edge
export TSMC28_ROOT=/opt/eda_tools/TSMC28

./asic_commercial/ws/scripts/prepare_tsmc28_cache.sh
./asic_commercial/ws/scripts/check_handoff.sh
./asic_commercial/ws/scripts/run_dc.sh
./asic_commercial/ws/scripts/run_postsim.sh dc
./asic_commercial/ws/scripts/check_backend_inputs.sh innovus
./asic_commercial/ws/scripts/run_innovus.sh all

# One-shot flow: DC -> gate(dc) -> Innovus -> gate(innovus) -> Formality
./asic_commercial/ws/scripts/run_full_flow.sh
```

Calibre is available as an explicit debug path, but is disabled by default:

```bash
WS_RUN_CALIBRE_DRC=1 WS_RUN_CALIBRE_LVS=1 ./asic_commercial/ws/scripts/run_full_flow.sh
```

For detailed variable descriptions, see `../dip/README.md`.
