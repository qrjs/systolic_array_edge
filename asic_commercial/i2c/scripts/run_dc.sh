#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
FLOW_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
LOG_DIR="${FLOW_ROOT}/logs"
RUNSET="${FLOW_ROOT}/dc/run_dc.tcl"
TOOL_BIN="${DC_SHELL_BIN:-dc_shell}"
LOG_FILE="${LOG_DIR}/dc_i2c_master.log"

mkdir -p "${LOG_DIR}"

if ! command -v "${TOOL_BIN}" >/dev/null 2>&1; then
    echo "error: cannot find DC executable '${TOOL_BIN}'" >&2
    echo "hint: set DC_SHELL_BIN if your installation uses a different command name" >&2
    exit 1
fi

echo "[info] flow root: ${FLOW_ROOT}"
echo "[info] log file: ${LOG_FILE}"
echo "[info] dc binary: ${TOOL_BIN}"

(
    cd "${FLOW_ROOT}/dc"
    "${TOOL_BIN}" -64bit -f "${RUNSET}"
) | tee "${LOG_FILE}"
