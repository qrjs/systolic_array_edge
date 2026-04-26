#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
FLOW_ROOT=$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)
REPO_ROOT=$(builtin cd "${FLOW_ROOT}/../.." && /bin/pwd -P)

# shellcheck disable=SC1091
source "${REPO_ROOT}/asic_commercial/scripts/source_eda_env.sh"

export TSMC28_ROOT="${TSMC28_ROOT:-/opt/eda_tools/TSMC28}"
if [[ ! -d "${TSMC28_ROOT}" ]]; then
    echo "[ws-flow][ERROR] TSMC28_ROOT not found: ${TSMC28_ROOT}" >&2
    exit 1
fi

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${DESIGN_ENV:-${FLOW_ROOT}/config/design.env}"
export LIBS_ENV="${LIBS_ENV:-${FLOW_ROOT}/config/libs.env}"
export DC_OUTPUT_FLAVOR="${DC_OUTPUT_FLAVOR:-plain}"
export POSTSIM_FLAVOR="${POSTSIM_FLAVOR:-plain}"
export INNOVUS_INPUT_FLAVOR="${INNOVUS_INPUT_FLAVOR:-plain}"

WS_GATE_MODE="${WS_GATE_MODE:-single}"
WS_GATE_CASE="${WS_GATE_CASE:-}"
WS_RUN_FRONTSIM="${WS_RUN_FRONTSIM:-0}"
WS_RUN_NONE_STAGE="${WS_RUN_NONE_STAGE:-0}"
WS_RUN_BACKEND="${WS_RUN_BACKEND:-1}"
WS_RUN_POST_ROUTE_GATE="${WS_RUN_POST_ROUTE_GATE:-1}"
WS_RUN_FM="${WS_RUN_FM:-1}"
WS_RUN_POST_ROUTE_FM="${WS_RUN_POST_ROUTE_FM:-1}"
WS_RUN_CALIBRE_DRC="${WS_RUN_CALIBRE_DRC:-0}"
WS_RUN_CALIBRE_LVS="${WS_RUN_CALIBRE_LVS:-0}"
WS_BACKEND_STEP="${WS_BACKEND_STEP:-all}"
WS_BACKEND_TOOL="${WS_BACKEND_TOOL:-innovus}"

case "${WS_GATE_MODE}" in
    single|suite) ;;
    *)
        echo "[ws-flow][ERROR] Unsupported WS_GATE_MODE=${WS_GATE_MODE} (expected single or suite)" >&2
        exit 1
        ;;
esac

case "${WS_BACKEND_TOOL}" in
    innovus) ;;
    *)
        echo "[ws-flow][ERROR] Unsupported WS_BACKEND_TOOL=${WS_BACKEND_TOOL} (expected innovus)" >&2
        exit 1
        ;;
esac

run_cmd() {
    echo "[ws-flow][INFO] $*"
    "$@"
}

run_single_gate_stage() {
    local stage="$1"
    if [[ -n "${WS_GATE_CASE}" ]]; then
        run_cmd "${SCRIPT_DIR}/run_postsim.sh" "${stage}" "${WS_GATE_CASE}"
    else
        run_cmd "${SCRIPT_DIR}/run_postsim.sh" "${stage}"
    fi
}

run_suite_gate_stage() {
    local stage="$1"
    run_cmd "${SCRIPT_DIR}/run_postsim_suite.sh" "${stage}"
}

if [[ "${WS_RUN_FRONTSIM}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/run_frontsim.sh"
fi

run_cmd "${SCRIPT_DIR}/prepare_tsmc28_cache.sh"
run_cmd "${SCRIPT_DIR}/check_handoff.sh"
run_cmd "${SCRIPT_DIR}/check_backend_inputs.sh" dc
run_cmd "${SCRIPT_DIR}/run_dc.sh"

if [[ "${WS_GATE_MODE}" == "suite" ]]; then
    if [[ "${WS_RUN_NONE_STAGE}" == "1" ]]; then
        run_suite_gate_stage none
    fi
    run_suite_gate_stage dc
else
    if [[ "${WS_RUN_NONE_STAGE}" == "1" ]]; then
        run_single_gate_stage none
    fi
    run_single_gate_stage dc
fi

if [[ "${WS_RUN_FM}" == "1" ]]; then
    run_cmd env FM_IMPLEMENTATION_MODE=dc FM_FLAVOR="${POSTSIM_FLAVOR}" "${SCRIPT_DIR}/run_fm.sh"
fi

if [[ "${WS_RUN_BACKEND}" == "1" ]]; then
    run_cmd "${SCRIPT_DIR}/check_backend_inputs.sh" innovus
    run_cmd "${SCRIPT_DIR}/run_innovus.sh" "${WS_BACKEND_STEP}"

    if [[ "${WS_RUN_POST_ROUTE_GATE}" == "1" ]]; then
        if [[ "${WS_GATE_MODE}" == "suite" ]]; then
            run_suite_gate_stage innovus
        else
            run_single_gate_stage innovus
        fi
    fi

    if [[ "${WS_RUN_POST_ROUTE_FM}" == "1" ]]; then
        run_cmd env FM_IMPLEMENTATION_MODE=innovus FM_FLAVOR="${INNOVUS_INPUT_FLAVOR}" "${SCRIPT_DIR}/run_fm.sh"
    fi

    if [[ "${WS_RUN_CALIBRE_DRC}" == "1" ]]; then
        run_cmd env CALIBRE_LAYOUT_MODE=innovus "${SCRIPT_DIR}/check_backend_inputs.sh" calibre_drc
        run_cmd env CALIBRE_LAYOUT_MODE=innovus "${SCRIPT_DIR}/run_calibre_drc.sh"
    fi

    if [[ "${WS_RUN_CALIBRE_LVS}" == "1" ]]; then
        run_cmd env CALIBRE_LAYOUT_MODE=innovus CALIBRE_SOURCE_MODE=innovus "${SCRIPT_DIR}/check_backend_inputs.sh" calibre_lvs
        run_cmd env CALIBRE_LAYOUT_MODE=innovus CALIBRE_SOURCE_MODE=innovus "${SCRIPT_DIR}/run_calibre_lvs.sh"
    fi
fi

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

echo "[ws-flow][PASS] WS full flow finished"
echo "[ws-flow][INFO] DC netlist        : ${DC_NETLIST}"
echo "[ws-flow][INFO] DC sdf            : ${DC_SDF}"
echo "[ws-flow][INFO] Backend tool      : ${WS_BACKEND_TOOL}"
echo "[ws-flow][INFO] Backend netlist   : ${INNOVUS_NETLIST}"
echo "[ws-flow][INFO] Backend sdf       : ${INNOVUS_SDF}"
echo "[ws-flow][INFO] Backend def       : ${INNOVUS_DEF}"
echo "[ws-flow][INFO] Backend gds       : ${INNOVUS_GDS}"
echo "[ws-flow][INFO] Backend log       : ${INNOVUS_LOG_FILE}"
echo "[ws-flow][INFO] Gate mode         : ${WS_GATE_MODE}"
echo "[ws-flow][INFO] Gate vector dir   : ${POSTSIM_VECTOR_DIR}"
echo "[ws-flow][INFO] Gate suite dir    : ${POSTSIM_SUITE_DIR}"
echo "[ws-flow][INFO] Gate run log      : ${POSTSIM_RUN_LOG}"
echo "[ws-flow][INFO] FM enabled        : dc=${WS_RUN_FM} post_route=${WS_RUN_POST_ROUTE_FM}"
echo "[ws-flow][INFO] Calibre enabled   : drc=${WS_RUN_CALIBRE_DRC} lvs=${WS_RUN_CALIBRE_LVS}"
