#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VCS_BIN="${VCS_BIN:-vcs}"
require_tool "$VCS_BIN"

rtl_files=()
while IFS= read -r line; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    rtl_files+=("$(resolve_path "$line")")
done <"$FILELIST"

compile_cmd=(
    "$VCS_BIN"
    -full64
    -sverilog
    "+incdir+${REPO_ROOT}"
    -timescale=1ns/1ps
    -debug_access+all
    -kdb
    -l "$FRONTSIM_COMPILE_LOG"
    -top "$FRONTSIM_TB_TOP"
)

compile_cmd+=("${rtl_files[@]}" "$FRONTSIM_TB_FILE" -o "$FRONTSIM_SIMV")
"${compile_cmd[@]}"

run_cmd=("$FRONTSIM_SIMV" "+SOFT_FAIL" "+INPUT=${FRONTSIM_VECTOR_INPUT}" "+EXPECTED=${FRONTSIM_VECTOR_EXPECTED}")
if [[ -n "$FRONTSIM_CASE" ]]; then
    run_cmd+=("+CASE=${FRONTSIM_CASE}")
fi
if [[ -n "$FRONTSIM_VCD_PATH" ]]; then
    mkdir -p "$(dirname "$FRONTSIM_VCD_PATH")"
    run_cmd+=("+VCD=${FRONTSIM_VCD_PATH}")
fi

"${run_cmd[@]}" -l "$FRONTSIM_RUN_LOG"

grep -F "$FRONTSIM_PASS_MARKER" "$FRONTSIM_RUN_LOG" >/dev/null
