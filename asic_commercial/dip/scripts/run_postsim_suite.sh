#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VCS_BIN="${VCS_BIN:-vcs}"
require_tool "$VCS_BIN"
require_tool python3

stages=("$@")
if [[ "${#stages[@]}" -eq 0 ]]; then
    split_path_list "${POSTSIM_STAGES}" stages
fi
[[ "${#stages[@]}" -gt 0 ]] || die "No gate postsim stages requested"

vector_dir="${POSTSIM_VECTOR_DIR}"
suite_root="${POSTSIM_SUITE_DIR}"
dump_vcd_args=()
if [[ "${POSTSIM_DUMP_VCD:-0}" == "1" ]]; then
    dump_vcd_args=(--dump-vcd)
fi

for stage in "${stages[@]}"; do
    case "$stage" in
        none)
            export POSTSIM_NETLIST_MODE="dc"
            export POSTSIM_SDF_MODE="none"
            export POSTSIM_DISABLE_TIMING_CHECKS="1"
            ;;
        dc)
            export POSTSIM_NETLIST_MODE="dc"
            export POSTSIM_SDF_MODE="dc"
            export POSTSIM_DISABLE_TIMING_CHECKS="0"
            ;;
        innovus)
            export POSTSIM_NETLIST_MODE="innovus"
            export POSTSIM_SDF_MODE="innovus"
            export POSTSIM_DISABLE_TIMING_CHECKS="0"
            ;;
        custom)
            export POSTSIM_NETLIST_MODE="custom"
            export POSTSIM_SDF_MODE="custom"
            export POSTSIM_DISABLE_TIMING_CHECKS="0"
            ;;
        *)
            die "unsupported gate postsim stage: $stage"
            ;;
    esac

    export POSTSIM_VECTOR_DIR="$vector_dir"
    export POSTSIM_SUITE_DIR="$suite_root"

    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/prepare_env.sh"

    stage_output_dir="${POSTSIM_SUITE_DIR}/${stage}"
    echo "[dip-flow][INFO] Running gate postsim suite stage=${stage}"
    echo "[dip-flow][INFO]   netlist=${POSTSIM_NETLIST}"
    echo "[dip-flow][INFO]   sdf=${POSTSIM_SDF:-<none>}"
    echo "[dip-flow][INFO]   vector_dir=${POSTSIM_VECTOR_DIR}"

    if [[ "${#dump_vcd_args[@]}" -gt 0 ]]; then
        python3 "${REPO_ROOT}/utils/run_gate_vector_suite.py" \
            --stage "$stage" \
            --vector-dir "${POSTSIM_VECTOR_DIR}" \
            --output-dir "${stage_output_dir}" \
            "${dump_vcd_args[@]}"
    else
        python3 "${REPO_ROOT}/utils/run_gate_vector_suite.py" \
            --stage "$stage" \
            --vector-dir "${POSTSIM_VECTOR_DIR}" \
            --output-dir "${stage_output_dir}"
    fi

    echo "[dip-flow][PASS] gate postsim stage=${stage} summary=${stage_output_dir}/summary.md"
    echo "[dip-flow][PASS] gate postsim stage=${stage} debug_snapshot=${stage_output_dir}/debug_snapshot.txt"
done
