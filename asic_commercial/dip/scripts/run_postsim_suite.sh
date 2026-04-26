#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VCS_BIN="${VCS_BIN:-vcs}"
require_tool "$VCS_BIN"
require_tool python3

base_postsim_flavor="${POSTSIM_FLAVOR:-}"
effective_none_flavor="${POSTSIM_NONE_FLAVOR:-}"
if [[ -z "$effective_none_flavor" ]]; then
    if [[ -n "$base_postsim_flavor" && "$base_postsim_flavor" != "default" ]]; then
        effective_none_flavor="$base_postsim_flavor"
    else
        effective_none_flavor="plain"
    fi
fi
none_stage_status="not-run"
dc_stage_status="not-run"
functional_fail_seen=0
license_block_seen=0

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
            die "unsupported gate postsim stage: $stage"
            ;;
    esac
}

summarize_stage_failure() {
    local stage_output_dir="$1"
    local debug_snapshot="${stage_output_dir}/debug_snapshot.txt"
    local first_failed_case="<none>"
    local first_failed_run_log="<none>"

    if [[ -f "$debug_snapshot" ]]; then
        first_failed_case="$(awk -F= '/^first_failed_case=/{print $2; exit}' "$debug_snapshot")"
        first_failed_run_log="$(awk -F= '/^first_failed_run_log=/{print $2; exit}' "$debug_snapshot")"
        [[ -n "$first_failed_case" ]] || first_failed_case="<none>"
        [[ -n "$first_failed_run_log" ]] || first_failed_run_log="<none>"
    fi

    echo "[dip-flow][INFO]   first_failed_case=${first_failed_case}"
    echo "[dip-flow][INFO]   first_failed_run_log=${first_failed_run_log}"
}

read_stage_suite_status() {
    local stage_output_dir="$1"
    local debug_snapshot="${stage_output_dir}/debug_snapshot.txt"
    if [[ -f "$debug_snapshot" ]]; then
        awk -F= '/^suite_status=/{print $2; exit}' "$debug_snapshot"
    fi
}

stages=("$@")
if [[ "${#stages[@]}" -eq 0 ]]; then
    split_path_list "${POSTSIM_STAGES}" stages
fi
[[ "${#stages[@]}" -gt 0 ]] || die "No gate postsim stages requested"

vector_dir="${POSTSIM_VECTOR_DIR}"
suite_root="${POSTSIM_SUITE_DIR}"
export POSTSIM_MIN_CASES="${POSTSIM_MIN_CASES:-${MIN_GATE_CASES:-0}}"
dump_vcd_args=()
if [[ "${POSTSIM_DUMP_VCD:-0}" == "1" ]]; then
    dump_vcd_args=(--dump-vcd)
fi

for stage in "${stages[@]}"; do
    if [[ "$stage" == "dc" && "$none_stage_status" == "functional-fail" ]]; then
        echo "[dip-flow][INFO] gate postsim stage=${stage} skipped prerequisite=none prerequisite_status=${none_stage_status}"
        continue
    fi
    if [[ "$stage" == "dc" && "$none_stage_status" == "license-blocked" ]]; then
        echo "[dip-flow][INFO] gate postsim stage=${stage} skipped prerequisite=none prerequisite_status=${none_stage_status}"
        continue
    fi
    if [[ "$stage" == "innovus" && ( "$none_stage_status" == "functional-fail" || "$dc_stage_status" == "functional-fail" ) ]]; then
        echo "[dip-flow][INFO] gate postsim stage=${stage} skipped prerequisite_statuses=none:${none_stage_status},dc:${dc_stage_status}"
        continue
    fi
    if [[ "$stage" == "innovus" && ( "$none_stage_status" == "license-blocked" || "$dc_stage_status" == "license-blocked" ) ]]; then
        echo "[dip-flow][INFO] gate postsim stage=${stage} skipped prerequisite_statuses=none:${none_stage_status},dc:${dc_stage_status}"
        continue
    fi

    configure_stage_env "$stage"

    export POSTSIM_VECTOR_DIR="$vector_dir"
    export POSTSIM_SUITE_DIR="$suite_root"

    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/prepare_env.sh"

    stage_output_dir="${POSTSIM_SUITE_DIR}/${stage}"
    echo "[dip-flow][INFO] Running gate postsim suite stage=${stage}"
    echo "[dip-flow][INFO]   flavor=${POSTSIM_FLAVOR}"
    echo "[dip-flow][INFO]   netlist=${POSTSIM_NETLIST}"
    echo "[dip-flow][INFO]   sdf=${POSTSIM_SDF:-<none>}"
    echo "[dip-flow][INFO]   vector_dir=${POSTSIM_VECTOR_DIR}"
    echo "[dip-flow][INFO]   force_clock_gates_open=${POSTSIM_FORCE_CLOCK_GATES_OPEN}"

    set +e
    if [[ "${#dump_vcd_args[@]}" -gt 0 ]]; then
        python3 "${REPO_ROOT}/utils/run_gate_vector_suite.py" \
            --stage "$stage" \
            --vector-dir "${POSTSIM_VECTOR_DIR}" \
            --output-dir "${stage_output_dir}" \
            "${dump_vcd_args[@]}"
        stage_rc=$?
    else
        python3 "${REPO_ROOT}/utils/run_gate_vector_suite.py" \
            --stage "$stage" \
            --vector-dir "${POSTSIM_VECTOR_DIR}" \
            --output-dir "${stage_output_dir}"
        stage_rc=$?
    fi
    set -e

    case "$stage_rc" in
        0)
            stage_status="pass"
            echo "[dip-flow][PASS] gate postsim stage=${stage} status=${stage_status} summary=${stage_output_dir}/summary.md"
            echo "[dip-flow][PASS] gate postsim stage=${stage} debug_snapshot=${stage_output_dir}/debug_snapshot.txt"
            ;;
        2)
            stage_status="missing-artifact"
            echo "[dip-flow][INFO] gate postsim stage=${stage} status=${stage_status} summary=${stage_output_dir}/summary.md"
            echo "[dip-flow][INFO] gate postsim stage=${stage} debug_snapshot=${stage_output_dir}/debug_snapshot.txt"
            ;;
        *)
            suite_status="$(read_stage_suite_status "$stage_output_dir")"
            if [[ "$suite_status" == "LICENSE_BLOCKED" ]]; then
                stage_status="license-blocked"
                license_block_seen=1
            else
                stage_status="functional-fail"
                functional_fail_seen=1
            fi
            echo "[dip-flow][INFO] gate postsim stage=${stage} status=${stage_status} summary=${stage_output_dir}/summary.md"
            echo "[dip-flow][INFO] gate postsim stage=${stage} debug_snapshot=${stage_output_dir}/debug_snapshot.txt"
            summarize_stage_failure "$stage_output_dir"
            ;;
    esac

    case "$stage" in
        none)
            none_stage_status="$stage_status"
            ;;
        dc)
            dc_stage_status="$stage_status"
            ;;
    esac
done

if [[ "$functional_fail_seen" == "1" ]]; then
    exit 1
fi

if [[ "$license_block_seen" == "1" ]]; then
    exit 1
fi
