#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

"${SCRIPT_DIR}/check_backend_inputs.sh" calibre_lvs

tool_bin="${CALIBRE_BIN:-calibre}"
if ! command -v "${tool_bin}" >/dev/null 2>&1; then
    echo "error: cannot find Calibre executable '${tool_bin}'" >&2
    echo "hint: set CALIBRE_BIN if your installation uses a different command name" >&2
    exit 1
fi

log_file="${LOG_DIR}/calibre_lvs_${DESIGN_NAME}.log"
run_dir="${CALIBRE_RUN_DIR}/lvs"
mkdir -p "${run_dir}"

echo "[info] launching Calibre LVS with ${tool_bin}"
echo "[info] runset: ${CALIBRE_LVS_RUNSET}"
echo "[info] layout: ${CALIBRE_LAYOUT_GDS}"
echo "[info] source netlist: ${CALIBRE_SOURCE_NETLIST}"
echo "[info] log: ${log_file}"

(
    cd "${run_dir}"
    export CALIBRE_LAYOUT_GDS
    export CALIBRE_SOURCE_NETLIST
    export CALIBRE_TOP_CELL="${DESIGN_NAME}"
    "${tool_bin}" -lvs -hier -runset "${CALIBRE_LVS_RUNSET}" > "${log_file}" 2>&1
)
