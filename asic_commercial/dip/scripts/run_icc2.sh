#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

step="${1:-all}"
case "${step}" in
    init|floorplan|power|place|cts|route|export|all)
        ;;
    *)
        echo "error: unsupported ICC2 step '${step}'" >&2
        echo "usage: $0 [init|floorplan|power|place|cts|route|export|all]" >&2
        exit 1
        ;;
esac

"${SCRIPT_DIR}/check_backend_inputs.sh" icc2

if [[ ! -f "${ICC2_NETLIST}" ]]; then
    echo "error: ICC2 input netlist does not exist: ${ICC2_NETLIST}" >&2
    echo "hint: run scripts/run_dc.sh first, or set ICC2_NETLIST_MODE=custom" >&2
    exit 1
fi

tool_bin="${ICC2_BIN:-icc2_shell}"
if ! command -v "${tool_bin}" >/dev/null 2>&1; then
    echo "error: cannot find ICC2 executable '${tool_bin}'" >&2
    echo "hint: set ICC2_BIN if your installation uses a different command name" >&2
    exit 1
fi

log_file="${LOG_DIR}/icc2_${step}.log"

echo "[info] launching ICC2 step '${step}' with ${tool_bin}"
echo "[info] netlist: ${ICC2_NETLIST}"
echo "[info] log: ${log_file}"

(
    cd "${ICC2_ROOT}"
    export FLOW_STEP="${step}"
    "${tool_bin}" -f "${ICC2_RUNSET}" > "${log_file}" 2>&1
)
