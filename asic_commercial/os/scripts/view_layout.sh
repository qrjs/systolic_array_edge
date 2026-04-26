#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
export FLOW_ROOT=$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)
export RUNSET_ROOT=$(builtin cd "${SCRIPT_DIR}/../../dip" && /bin/pwd -P)

export DESIGN_ENV="${DESIGN_ENV:-${FLOW_ROOT}/config/design.env}"
export LIBS_ENV="${LIBS_ENV:-${FLOW_ROOT}/config/libs.env}"
export INNOVUS_INPUT_FLAVOR="${INNOVUS_INPUT_FLAVOR:-plain}"

"${SCRIPT_DIR}/prepare_tsmc28_cache.sh"

# shellcheck disable=SC1091
source "${RUNSET_ROOT}/scripts/prepare_env.sh"

INNOVUS_BIN="${INNOVUS_BIN:-innovus}"
require_tool "$INNOVUS_BIN"

if [[ -z "${INNOVUS_VIEW_CHECKPOINT:-}" ]]; then
    if [[ -e "${INNOVUS_CHECKPOINT_PREFIX}_export.enc.dat" ]]; then
        INNOVUS_VIEW_CHECKPOINT="${INNOVUS_CHECKPOINT_PREFIX}_export.enc.dat"
    else
        INNOVUS_VIEW_CHECKPOINT="${INNOVUS_CHECKPOINT_PREFIX}_route.enc.dat"
    fi
fi
export DESIGN_NAME
export INNOVUS_CHECKPOINT_PREFIX
export INNOVUS_VIEW_CHECKPOINT
export LOGS_DIR

if [[ ! -e "${INNOVUS_VIEW_CHECKPOINT}" ]]; then
    echo "[os-flow][ERROR] Innovus checkpoint not found: ${INNOVUS_VIEW_CHECKPOINT}" >&2
    echo "[os-flow][INFO] run backend first: ./asic_commercial/os/scripts/run_innovus.sh all" >&2
    exit 1
fi

innovus_args=(-overwrite)
if [[ "${INNOVUS_VIEW_NO_GUI:-0}" == "1" ]]; then
    innovus_args+=(-no_gui)
fi
if [[ "${INNOVUS_VIEW_BATCH:-0}" == "1" ]]; then
    innovus_args+=(-batch)
fi
innovus_args+=(
    -files "${RUNSET_ROOT}/scripts/view_innovus_layout.tcl"
    -log "${LOGS_DIR}/${DESIGN_NAME}_innovus_view.log"
)

exec "$INNOVUS_BIN" "${innovus_args[@]}"
