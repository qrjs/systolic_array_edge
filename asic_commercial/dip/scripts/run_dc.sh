#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

"${SCRIPT_DIR}/check_backend_inputs.sh" dc

tool_bin="${DC_SHELL_BIN:-dc_shell}"
if ! command -v "${tool_bin}" >/dev/null 2>&1; then
    echo "error: cannot find DC executable '${tool_bin}'" >&2
    echo "hint: set DC_SHELL_BIN if your installation uses a different command name" >&2
    exit 1
fi

log_file="${LOG_DIR}/dc_${DESIGN_NAME}.log"

echo "[info] launching DC with ${tool_bin}"
echo "[info] log: ${log_file}"

(
    cd "${FLOW_ROOT}/dc"
    "${tool_bin}" -64bit -f "${RUNSET_ROOT}/dc/run_dc.tcl" -output_log_file "${log_file}"
)
