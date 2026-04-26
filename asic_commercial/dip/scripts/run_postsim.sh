#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
requested_stage="${POSTSIM_STAGE:-}"
requested_case="${POSTSIM_CASE:-}"
base_postsim_flavor="${POSTSIM_FLAVOR:-}"
effective_none_flavor="${POSTSIM_NONE_FLAVOR:-}"
if [[ -z "$effective_none_flavor" ]]; then
    if [[ -n "$base_postsim_flavor" && "$base_postsim_flavor" != "default" ]]; then
        effective_none_flavor="$base_postsim_flavor"
    else
        effective_none_flavor="plain"
    fi
fi

configure_stage_env() {
    local stage="$1"
    case "$stage" in
        none)
            export POSTSIM_FLAVOR="$effective_none_flavor"
            export POSTSIM_NETLIST_MODE="dc"
            export POSTSIM_SDF_MODE="none"
            export POSTSIM_DISABLE_TIMING_CHECKS="${POSTSIM_NONE_DISABLE_TIMING_CHECKS:-1}"
            export POSTSIM_FORCE_CLOCK_GATES_OPEN="${POSTSIM_NONE_FORCE_CLOCK_GATES_OPEN:-${POSTSIM_FORCE_CLOCK_GATES_OPEN:-0}}"
            ;;
        dc)
            export POSTSIM_FLAVOR="${POSTSIM_DC_FLAVOR:-${base_postsim_flavor:-default}}"
            export POSTSIM_NETLIST_MODE="dc"
            export POSTSIM_SDF_MODE="dc"
            export POSTSIM_DISABLE_TIMING_CHECKS="${POSTSIM_DC_DISABLE_TIMING_CHECKS:-0}"
            export POSTSIM_FORCE_CLOCK_GATES_OPEN="${POSTSIM_DC_FORCE_CLOCK_GATES_OPEN:-${POSTSIM_FORCE_CLOCK_GATES_OPEN:-0}}"
            ;;
        innovus)
            export POSTSIM_FLAVOR="${POSTSIM_INNOVUS_FLAVOR:-${base_postsim_flavor:-default}}"
            export POSTSIM_NETLIST_MODE="innovus"
            export POSTSIM_SDF_MODE="innovus"
            export POSTSIM_DISABLE_TIMING_CHECKS="${POSTSIM_INNOVUS_DISABLE_TIMING_CHECKS:-0}"
            export POSTSIM_FORCE_CLOCK_GATES_OPEN="${POSTSIM_INNOVUS_FORCE_CLOCK_GATES_OPEN:-${POSTSIM_FORCE_CLOCK_GATES_OPEN:-0}}"
            ;;
        custom)
            export POSTSIM_FLAVOR="${POSTSIM_CUSTOM_FLAVOR:-${base_postsim_flavor:-default}}"
            export POSTSIM_NETLIST_MODE="custom"
            export POSTSIM_SDF_MODE="custom"
            export POSTSIM_DISABLE_TIMING_CHECKS="${POSTSIM_CUSTOM_DISABLE_TIMING_CHECKS:-0}"
            export POSTSIM_FORCE_CLOCK_GATES_OPEN="${POSTSIM_CUSTOM_FORCE_CLOCK_GATES_OPEN:-${POSTSIM_FORCE_CLOCK_GATES_OPEN:-0}}"
            ;;
        *)
            echo "[dip-flow][ERROR] unsupported gate postsim stage: ${stage}" >&2
            exit 1
            ;;
    esac
}

if [[ "${1:-}" =~ ^(none|dc|innovus|custom)$ ]]; then
    requested_stage="$1"
    shift
fi

if [[ -n "${1:-}" ]]; then
    requested_case="$1"
    shift
fi

if [[ "$#" -gt 0 ]]; then
    echo "[dip-flow][ERROR] usage: $0 [none|dc|innovus|custom] [case_name]" >&2
    exit 1
fi

if [[ -n "$requested_stage" ]]; then
    export POSTSIM_STAGE="$requested_stage"
    configure_stage_env "$requested_stage"
fi

if [[ -n "$requested_case" ]]; then
    export POSTSIM_CASE="$requested_case"
fi

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VCS_BIN="${VCS_BIN:-vcs}"
require_tool "$VCS_BIN"
require_tool python3

require_file "gate netlist" "$POSTSIM_NETLIST"
if [[ -n "$POSTSIM_SDF" ]]; then
    require_file "gate sdf" "$POSTSIM_SDF"
fi

stage_label="${POSTSIM_STAGE:-env}"
case_label="${POSTSIM_CASE:-all}"
export POSTSIM_PREPARED_NETLIST="${POSTSIM_PREPARED_NETLIST:-${POSTSIM_WORK_DIR}/${DESIGN_NAME}_${stage_label}_${case_label}_prepared_gate_netlist.v}"
export POSTSIM_VCS_BUILD_DIR="${POSTSIM_VCS_BUILD_DIR:-${POSTSIM_WORK_DIR}/${DESIGN_NAME}_${stage_label}_${case_label}_vcs_build}"
if [[ -z "${POSTSIM_TRACE_PATH:-}" && "$case_label" != "all" ]]; then
    export POSTSIM_TRACE_PATH="${POSTSIM_LOG_DIR}/${DESIGN_NAME}_${stage_label}_${case_label}.trace.log"
fi
mkdir -p "$(dirname "$POSTSIM_PREPARED_NETLIST")"
python3 - "$POSTSIM_NETLIST" "$POSTSIM_PREPARED_NETLIST" <<'PY'
from pathlib import Path
import os
import re
import sys

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
text = src.read_text(encoding="utf-8", errors="ignore")
prepared = re.sub(r"\.SE\s*\(\s*TE\s*\)", ".SE(1'b0)", text)
if os.environ.get("POSTSIM_FORCE_CLOCK_GATES_OPEN", "0") == "1":
    prepared = re.sub(
        r"(module\s+SNPS_CLOCK_GATE_HIGH[\s\S]*?output\s+ENCLK;\s*)[\s\S]*?endmodule",
        r"\1\n  assign ENCLK = CLK;\nendmodule",
        prepared,
    )
dst.write_text(prepared, encoding="utf-8")
PY

echo "[dip-flow][INFO] Running gate postsim stage=${stage_label} case=${case_label}"
echo "[dip-flow][INFO]   flavor=${POSTSIM_FLAVOR}"
echo "[dip-flow][INFO]   netlist=${POSTSIM_NETLIST}"
echo "[dip-flow][INFO]   prepared_netlist=${POSTSIM_PREPARED_NETLIST}"
echo "[dip-flow][INFO]   sdf=${POSTSIM_SDF:-<none>}"
echo "[dip-flow][INFO]   force_clock_gates_open=${POSTSIM_FORCE_CLOCK_GATES_OPEN}"
if [[ -n "${POSTSIM_TRACE_PATH:-}" ]]; then
    echo "[dip-flow][INFO]   trace=${POSTSIM_TRACE_PATH}"
fi

rm -rf "$POSTSIM_VCS_BUILD_DIR" "$POSTSIM_SIMV" "${POSTSIM_SIMV}.daidir"
mkdir -p "$POSTSIM_VCS_BUILD_DIR"

compile_cmd=("$VCS_BIN" -full64 -sverilog +define+TB_SKIP_SDF_ANNOTATE +define+TB_GATE_SAFE_INPUT_LAUNCH "+incdir+${REPO_ROOT}" -timescale=1ns/1ps -debug_access+all -kdb "-Mdir=${POSTSIM_VCS_BUILD_DIR}/csrc" -l "$POSTSIM_COMPILE_LOG" -top "$POSTSIM_TB_TOP")
if [[ "${POSTSIM_DIP_STREAM_CAPTURE:-0}" == "1" ]]; then
    compile_cmd+=(+define+TB_DIP_STREAM_CAPTURE)
fi
if [[ "${POSTSIM_DIP_INTERNAL_TRACE:-0}" == "1" ]]; then
    compile_cmd+=(+define+TB_DIP_INTERNAL_TRACE)
fi
if [[ "${VCS_LICENSE_WAIT_MINUTES:-0}" =~ ^[0-9]+$ ]] && [[ "${VCS_LICENSE_WAIT_MINUTES:-0}" -gt 0 ]]; then
    compile_cmd+=(-licwait "$VCS_LICENSE_WAIT_MINUTES")
fi

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

compile_cmd+=("$POSTSIM_PREPARED_NETLIST" "$POSTSIM_TB_FILE" -o "$POSTSIM_SIMV")
if [[ -n "$POSTSIM_SDF" ]]; then
    if [[ "${POSTSIM_NEG_TCHK:-1}" != "0" ]]; then
        compile_cmd+=(+neg_tchk)
    fi
    compile_cmd+=(-sdf "max:${POSTSIM_TB_TOP}.dut:${POSTSIM_SDF}")
fi
compile_capture_log="$(mktemp "${TMPDIR:-/tmp}/dip_postsim_compile.XXXXXX")"
trap 'rm -f "$compile_capture_log"' EXIT
if ! (
    cd "$POSTSIM_VCS_BUILD_DIR"
    "${compile_cmd[@]}"
) >"$compile_capture_log" 2>&1; then
    if [[ -s "$compile_capture_log" ]]; then
        cat "$compile_capture_log" >&2
        cat "$compile_capture_log" >>"$POSTSIM_COMPILE_LOG"
    fi
    if grep -Eiq 'failed to obtain license|cannot connect to the license server|license server' "$compile_capture_log" "$POSTSIM_COMPILE_LOG" 2>/dev/null; then
        echo "[dip-flow][INFO] gate postsim stage=${stage_label} status=license-blocked compile_log=${POSTSIM_COMPILE_LOG}"
    else
        echo "[dip-flow][INFO] gate postsim stage=${stage_label} status=functional-fail compile_log=${POSTSIM_COMPILE_LOG}"
    fi
    exit 1
fi
if [[ -s "$compile_capture_log" ]]; then
    cat "$compile_capture_log" >>"$POSTSIM_COMPILE_LOG"
fi
rm -f "$compile_capture_log"
trap - EXIT

run_cmd=("$POSTSIM_SIMV" "+SOFT_FAIL" "+INPUT=${POSTSIM_VECTOR_INPUT}" "+EXPECTED=${POSTSIM_VECTOR_EXPECTED}")
if [[ -n "${POSTSIM_CASE:-}" ]]; then
    run_cmd+=("+CASE=${POSTSIM_CASE}")
fi
if [[ "${POSTSIM_DISABLE_TIMING_CHECKS:-0}" == "1" ]]; then
    run_cmd+=("+notimingcheck" "+no_notifier" "+nospecify")
fi
if [[ -n "$POSTSIM_SDF" && "${POSTSIM_NEG_TCHK:-1}" != "0" ]]; then
    run_cmd+=("+neg_tchk")
fi
if [[ -n "$POSTSIM_VCD_PATH" ]]; then
    mkdir -p "$(dirname "$POSTSIM_VCD_PATH")"
    run_cmd+=("+VCD=${POSTSIM_VCD_PATH}")
fi
if [[ -n "${POSTSIM_TRACE_PATH:-}" ]]; then
    mkdir -p "$(dirname "$POSTSIM_TRACE_PATH")"
    run_cmd+=("+TRACE=${POSTSIM_TRACE_PATH}")
fi

run_rc=0
if ! "${run_cmd[@]}" -l "$POSTSIM_RUN_LOG"; then
    run_rc=$?
fi

if grep -F "$POSTSIM_PASS_MARKER" "$POSTSIM_RUN_LOG" >/dev/null; then
    echo "[dip-flow][PASS] gate postsim stage=${stage_label} case=${case_label} compile_log=${POSTSIM_COMPILE_LOG} run_log=${POSTSIM_RUN_LOG} trace_log=${POSTSIM_TRACE_PATH:-<none>}"
    exit 0
fi

echo "[dip-flow][INFO] gate postsim stage=${stage_label} status=functional-fail case=${case_label} run_rc=${run_rc} compile_log=${POSTSIM_COMPILE_LOG} run_log=${POSTSIM_RUN_LOG} trace_log=${POSTSIM_TRACE_PATH:-<none>}"
exit 1
