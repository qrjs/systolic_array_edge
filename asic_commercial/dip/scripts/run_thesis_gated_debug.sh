#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
FLOW_ROOT=$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)
REPO_ROOT=$(builtin cd "${FLOW_ROOT}/../.." && /bin/pwd -P)

# shellcheck disable=SC1091
source "${REPO_ROOT}/asic_commercial/scripts/source_eda_env.sh"

export TSMC28_ROOT="${TSMC28_ROOT:-/opt/eda_tools/TSMC28}"
[[ -d "${TSMC28_ROOT}" ]] || {
    echo "[thesis-dip-gated][ERROR] TSMC28_ROOT not found: ${TSMC28_ROOT}" >&2
    exit 1
}

THESIS_VECTOR_DIR="${THESIS_VECTOR_DIR:-${REPO_ROOT}/test_vectors/txt}"
THESIS_GATED_DEBUG_DIR="${THESIS_GATED_DEBUG_DIR:-${FLOW_ROOT}/postsim/gated_debug}"
THESIS_GATED_DEBUG_CASES="${THESIS_GATED_DEBUG_CASES:-batch_000 signed_mix}"

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${FLOW_ROOT}/config/design.env"
export LIBS_ENV="${FLOW_ROOT}/config/libs.env"
export DC_OUTPUT_FLAVOR="gated"
export FM_FLAVOR="gated"
export POSTSIM_FLAVOR="gated"
export DIP_GATED_COMPILE_PROFILE="${DIP_GATED_COMPILE_PROFILE:-gated_default}"
export DIP_COMPILE_PROFILE="${DIP_COMPILE_PROFILE:-gated_default}"

"${SCRIPT_DIR}/check_handoff.sh"
"${SCRIPT_DIR}/check_backend_inputs.sh" dc
"${SCRIPT_DIR}/run_dc.sh"
"${SCRIPT_DIR}/run_fm.sh"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

mkdir -p "${THESIS_GATED_DEBUG_DIR}/logs" "${THESIS_GATED_DEBUG_DIR}/fm"
cp "${FM_SUMMARY_RPT}" "${THESIS_GATED_DEBUG_DIR}/fm/$(basename "${FM_SUMMARY_RPT}")"

status=0
for case_name in ${THESIS_GATED_DEBUG_CASES}; do
    input_path="${THESIS_VECTOR_DIR}/${case_name}_input.txt"
    expected_path="${THESIS_VECTOR_DIR}/${case_name}_expected.txt"
    [[ -f "${input_path}" ]] || {
        echo "[thesis-dip-gated][ERROR] missing input vector: ${input_path}" >&2
        exit 1
    }
    [[ -f "${expected_path}" ]] || {
        echo "[thesis-dip-gated][ERROR] missing expected vector: ${expected_path}" >&2
        exit 1
    }

    echo "[thesis-dip-gated][INFO] Running gated debug case=${case_name}"
    if POSTSIM_INPUT="${input_path}" \
        POSTSIM_EXPECTED="${expected_path}" \
        POSTSIM_CASE="${case_name}" \
        POSTSIM_NETLIST_MODE="dc" \
        POSTSIM_SDF_MODE="none" \
        POSTSIM_FLAVOR="gated" \
        POSTSIM_DISABLE_TIMING_CHECKS="1" \
        "${SCRIPT_DIR}/run_postsim.sh"; then
        echo "[thesis-dip-gated][PASS] case=${case_name}"
    else
        echo "[thesis-dip-gated][FAIL] case=${case_name}" >&2
        status=1
    fi

    cp "${POSTSIM_COMPILE_LOG}" "${THESIS_GATED_DEBUG_DIR}/logs/${case_name}.compile.log" 2>/dev/null || true
    cp "${POSTSIM_RUN_LOG}" "${THESIS_GATED_DEBUG_DIR}/logs/${case_name}.run.log" 2>/dev/null || true
done

cat <<EOF
[thesis-dip-gated][INFO] Gated DC netlist : ${DC_NETLIST}
[thesis-dip-gated][INFO] FM summary       : ${THESIS_GATED_DEBUG_DIR}/fm/$(basename "${FM_SUMMARY_RPT}")
[thesis-dip-gated][INFO] Debug logs       : ${THESIS_GATED_DEBUG_DIR}/logs
EOF

exit "${status}"
