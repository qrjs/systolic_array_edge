#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
FLOW_ROOT="${FLOW_ROOT:-$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)}"
REPO_ROOT=$(builtin cd "${FLOW_ROOT}/../.." && /bin/pwd -P)
FLOW_KEY="$(basename "${FLOW_ROOT}")"

# shellcheck disable=SC1091
source "${REPO_ROOT}/asic_commercial/scripts/source_eda_env.sh"

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${DESIGN_ENV:-${FLOW_ROOT}/config/design.env}"
export LIBS_ENV="${LIBS_ENV:-${FLOW_ROOT}/config/libs.env}"
if [[ -z "${TSMC28_ROOT:-}" && -d "${REPO_ROOT}/TSMC28/PDK/Calibre" ]]; then
    export TSMC28_ROOT="${REPO_ROOT}/TSMC28"
else
    export TSMC28_ROOT="${TSMC28_ROOT:-/opt/eda_tools/TSMC28}"
fi
export THESIS_VECTOR_DIR="${THESIS_VECTOR_DIR:-${REPO_ROOT}/test_vectors/txt}"
export POSTSIM_VECTOR_DIR="${POSTSIM_VECTOR_DIR:-${THESIS_VECTOR_DIR}}"
export FRONTSIM_VECTOR_DIR="${FRONTSIM_VECTOR_DIR:-${THESIS_VECTOR_DIR}}"
export FRONTSIM_SUITE_DIR="${FRONTSIM_SUITE_DIR:-${FLOW_ROOT}/frontsim/suites}"
export MIN_GATE_CASES="${MIN_GATE_CASES:-268}"
export FRONTSIM_MIN_CASES="${FRONTSIM_MIN_CASES:-268}"

case "${FLOW_KEY}" in
    dip)
        export DC_OUTPUT_FLAVOR="${DC_OUTPUT_FLAVOR:-gated}"
        export POSTSIM_FLAVOR="${POSTSIM_FLAVOR:-gated}"
        export INNOVUS_INPUT_FLAVOR="${INNOVUS_INPUT_FLAVOR:-gated}"
        export FM_FLAVOR="${FM_FLAVOR:-gated}"
        ;;
    is|os)
        export DC_OUTPUT_FLAVOR="${DC_OUTPUT_FLAVOR:-plain}"
        export POSTSIM_FLAVOR="${POSTSIM_FLAVOR:-plain}"
        export INNOVUS_INPUT_FLAVOR="${INNOVUS_INPUT_FLAVOR:-plain}"
        export FM_FLAVOR="${FM_FLAVOR:-plain}"
        ;;
    *)
        echo "[commercial-flow][ERROR] unsupported FLOW_ROOT=${FLOW_ROOT}" >&2
        exit 1
        ;;
esac

RUN_PREPARE_CACHE="${RUN_PREPARE_CACHE:-1}"
RUN_FRONTSIM="${RUN_FRONTSIM:-1}"
RUN_DC="${RUN_DC:-1}"
RUN_FM="${RUN_FM:-1}"
RUN_GATE_NONE="${RUN_GATE_NONE:-1}"
RUN_GATE_DC="${RUN_GATE_DC:-1}"
RUN_INNOVUS="${RUN_INNOVUS:-1}"
RUN_POST_ROUTE_FM="${RUN_POST_ROUTE_FM:-1}"
RUN_GATE_INNOVUS="${RUN_GATE_INNOVUS:-1}"
RUN_CALIBRE_DRC="${RUN_CALIBRE_DRC:-0}"
RUN_CALIBRE_LVS="${RUN_CALIBRE_LVS:-0}"
RUN_VIRTUOSO="${RUN_VIRTUOSO:-0}"
RUN_DIP_GATED_OPT="${RUN_DIP_GATED_OPT:-1}"

run_cmd() {
    echo "[commercial-flow][INFO] $*"
    "$@"
}

if [[ "${RUN_PREPARE_CACHE}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/prepare_tsmc28_cache.sh"
fi

run_cmd "${SCRIPT_DIR}/check_handoff.sh"

if [[ "${RUN_FRONTSIM}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/run_frontsim_suite.sh"
fi

if [[ "${FLOW_KEY}" == "dip" && "${RUN_DIP_GATED_OPT}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/run_dip_gated_opt.sh"
elif [[ "${RUN_DC}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/check_backend_inputs.sh" dc
    run_cmd "${SCRIPT_DIR}/run_dc.sh"
fi

if [[ "${FLOW_KEY}" != "dip" || "${RUN_DIP_GATED_OPT}" != "1" ]]; then
    if [[ "${RUN_FM}" == "1" ]]; then
        run_cmd env FM_IMPLEMENTATION_MODE=dc FM_FLAVOR="${FM_FLAVOR}" "${SCRIPT_DIR}/run_fm.sh"
    fi
    if [[ "${RUN_GATE_NONE}" == "1" ]]; then
        run_cmd "${SCRIPT_DIR}/run_postsim_suite.sh" none
    fi
    if [[ "${RUN_GATE_DC}" == "1" ]]; then
        run_cmd "${SCRIPT_DIR}/run_postsim_suite.sh" dc
    fi
fi

if [[ "${RUN_INNOVUS}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/check_backend_inputs.sh" innovus
    run_cmd "${SCRIPT_DIR}/run_innovus.sh" all
fi

if [[ "${RUN_POST_ROUTE_FM}" == "1" ]]; then
    run_cmd env FM_IMPLEMENTATION_MODE=innovus FM_FLAVOR="${INNOVUS_INPUT_FLAVOR}" "${SCRIPT_DIR}/run_fm.sh"
fi

if [[ "${RUN_GATE_INNOVUS}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/run_postsim_suite.sh" innovus
fi

if [[ "${RUN_CALIBRE_DRC}" == "1" ]]; then
    run_cmd env CALIBRE_LAYOUT_MODE=innovus "${SCRIPT_DIR}/check_backend_inputs.sh" calibre_drc
    run_cmd env CALIBRE_LAYOUT_MODE=innovus "${SCRIPT_DIR}/run_calibre_drc.sh"
fi

if [[ "${RUN_CALIBRE_LVS}" == "1" ]]; then
    run_cmd env CALIBRE_LAYOUT_MODE=innovus CALIBRE_SOURCE_MODE=innovus "${SCRIPT_DIR}/check_backend_inputs.sh" calibre_lvs
    run_cmd env CALIBRE_LAYOUT_MODE=innovus CALIBRE_SOURCE_MODE=innovus "${SCRIPT_DIR}/run_calibre_lvs.sh"
fi

if [[ "${RUN_VIRTUOSO}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/check_backend_inputs.sh" virtuoso
    run_cmd "${SCRIPT_DIR}/run_virtuoso_layout.sh"
fi

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

echo "[commercial-flow][PASS] ${FLOW_KEY} full flow finished"
echo "[commercial-flow][INFO] DC netlist        : ${DC_NETLIST}"
echo "[commercial-flow][INFO] DC sdf            : ${DC_SDF}"
echo "[commercial-flow][INFO] Innovus netlist   : ${INNOVUS_NETLIST}"
echo "[commercial-flow][INFO] Innovus sdf       : ${INNOVUS_SDF}"
echo "[commercial-flow][INFO] Innovus def       : ${INNOVUS_DEF}"
echo "[commercial-flow][INFO] Innovus gds       : ${INNOVUS_GDS}"
echo "[commercial-flow][INFO] Front suite       : ${FRONTSIM_SUITE_DIR}/summary.md"
echo "[commercial-flow][INFO] Gate suite dir    : ${POSTSIM_SUITE_DIR}"
