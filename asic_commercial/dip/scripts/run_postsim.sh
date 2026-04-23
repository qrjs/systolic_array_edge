#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VCS_BIN="${VCS_BIN:-vcs}"
require_tool "$VCS_BIN"

compile_cmd=("$VCS_BIN" -full64 -sverilog +define+TB_SKIP_SDF_ANNOTATE "+incdir+${REPO_ROOT}" -timescale=1ns/1ps -debug_access+all -kdb -l "$POSTSIM_COMPILE_LOG" -top "$POSTSIM_TB_TOP")

sim_libs=()
split_path_list "${SIM_LIBRARY_VERILOG:-}" sim_libs
extra_libs=()
split_path_list "${ADDITIONAL_SIM_VERILOGS:-}" extra_libs

for item in "${sim_libs[@]-}"; do
    [[ -z "$item" ]] && continue
    compile_cmd+=("$(resolve_path "$item")")
done

for item in "${extra_libs[@]-}"; do
    [[ -z "$item" ]] && continue
    compile_cmd+=("$(resolve_path "$item")")
done

compile_cmd+=("$POSTSIM_NETLIST" "$POSTSIM_TB_FILE" -o "$POSTSIM_SIMV")
if [[ -n "$POSTSIM_SDF" ]]; then
    compile_cmd+=(-sdf "max:${POSTSIM_TB_TOP}.dut:${POSTSIM_SDF}")
fi
"${compile_cmd[@]}"

run_cmd=("$POSTSIM_SIMV" "+SOFT_FAIL" "+INPUT=${POSTSIM_VECTOR_INPUT}" "+EXPECTED=${POSTSIM_VECTOR_EXPECTED}")
if [[ -n "${POSTSIM_CASE:-}" ]]; then
    run_cmd+=("+CASE=${POSTSIM_CASE}")
fi
if [[ "${POSTSIM_DISABLE_TIMING_CHECKS:-0}" == "1" ]]; then
    run_cmd+=("+notimingcheck" "+no_notifier" "+nospecify")
fi
if [[ -n "$POSTSIM_VCD_PATH" ]]; then
    mkdir -p "$(dirname "$POSTSIM_VCD_PATH")"
    run_cmd+=("+VCD=${POSTSIM_VCD_PATH}")
fi

"${run_cmd[@]}" -l "$POSTSIM_RUN_LOG"

grep -F "$POSTSIM_PASS_MARKER" "$POSTSIM_RUN_LOG" >/dev/null
