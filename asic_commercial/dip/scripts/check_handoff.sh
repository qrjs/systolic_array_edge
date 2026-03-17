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

check_filelist_entries() {
    local filelist_path="$1"
    local base_dir
    local line
    local path
    local project_candidate
    local filelist_candidate
    local status=0

    base_dir=$(cd "$(dirname "${filelist_path}")" && pwd)

    while IFS= read -r line || [[ -n "${line}" ]]; do
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        [[ -z "${line}" ]] && continue
        [[ "${line}" == \#* ]] && continue
        [[ "${line}" == //* ]] && continue
        [[ "${line}" == +incdir+* ]] && continue

        if [[ "${line}" == -f* ]]; then
            echo "[warn] nested filelist entry not checked automatically: ${line}"
            continue
        fi

        if [[ "${line}" == -v* ]]; then
            line="${line#-v}"
            line="${line#"${line%%[![:space:]]*}"}"
        fi

        if [[ "${line}" == /* ]]; then
            path="${line}"
        else
            project_candidate="${PROJECT_ROOT}/${line#./}"
            filelist_candidate="${base_dir}/${line}"

            if [[ -f "${project_candidate}" ]]; then
                path="${project_candidate}"
            else
                path="${filelist_candidate}"
            fi
        fi

        if [[ -f "${path}" ]]; then
            echo "[ok] filelist entry: ${path}"
        else
            echo "[missing] filelist entry: ${path}" >&2
            status=1
        fi
    done < "${filelist_path}"

    return "${status}"
}

status=0
check_file "${RTL_WRAPPER}" "RTL wrapper" || status=1
check_file "${FILELIST}" "filelist" || status=1
check_file "${SDC_FILE}" "SDC" || status=1
if [[ -f "${FILELIST}" ]]; then
    check_filelist_entries "${FILELIST}" || status=1
fi

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
