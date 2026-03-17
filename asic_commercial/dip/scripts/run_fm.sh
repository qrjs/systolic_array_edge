#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

"${SCRIPT_DIR}/check_backend_inputs.sh" fm

tool_bin="${FM_SHELL_BIN:-fm_shell}"
if ! command -v "${tool_bin}" >/dev/null 2>&1; then
    echo "error: cannot find Formality executable '${tool_bin}'" >&2
    echo "hint: set FM_SHELL_BIN if your installation uses a different command name" >&2
    exit 1
fi

log_file="${LOG_DIR}/fm_${DESIGN_NAME}.log"

if [[ ! -f "${SYNTH_SVF}" ]]; then
    echo "error: FM SVF does not exist: ${SYNTH_SVF}" >&2
    echo "hint: run scripts/run_dc.sh first so DC can emit the SVF" >&2
    exit 1
fi

if [[ ! -f "${FM_IMPLEMENTATION_NETLIST}" ]]; then
    echo "error: FM implementation netlist does not exist: ${FM_IMPLEMENTATION_NETLIST}" >&2
    echo "hint: run DC or ICC2 export first, or set FM_IMPLEMENTATION_MODE=custom" >&2
    exit 1
fi

echo "[info] launching Formality with ${tool_bin}"
echo "[info] implementation netlist: ${FM_IMPLEMENTATION_NETLIST}"
echo "[info] log: ${log_file}"

(
    cd "${FM_ROOT}"
    "${tool_bin}" -f "${RUNSET_ROOT}/fm/run_fm.tcl" > "${log_file}" 2>&1
)
