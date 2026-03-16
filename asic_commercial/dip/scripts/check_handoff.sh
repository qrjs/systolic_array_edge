#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

check_file() {
    local path="$1"
    local label="$2"
    if [[ -f "${path}" ]]; then
        echo "[ok] ${label}: ${path}"
    else
        echo "[missing] ${label}: ${path}" >&2
        return 1
    fi
}

status=0
check_file "${RTL_WRAPPER}" "RTL wrapper" || status=1
check_file "${FILELIST}" "filelist" || status=1
check_file "${SDC_FILE}" "SDC" || status=1

if [[ -f "${OPEN_SOURCE_NETLIST}" ]]; then
    echo "[ok] open-source seed netlist: ${OPEN_SOURCE_NETLIST}"
else
    echo "[warn] open-source seed netlist not present yet: ${OPEN_SOURCE_NETLIST}"
fi

if [[ -f "${DIP_ROOT}/config/libs.env" ]]; then
    echo "[ok] commercial library config: ${DIP_ROOT}/config/libs.env"
else
    echo "[warn] commercial library config missing, copy config/libs.example.env to config/libs.env"
fi

exit "${status}"
