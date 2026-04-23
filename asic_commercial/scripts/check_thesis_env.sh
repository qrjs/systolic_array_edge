#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/../.." && pwd)
FLOW_ROOT="${REPO_ROOT}/asic_commercial/dip"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/source_eda_env.sh"

die() {
    echo "[thesis-check][ERROR] $*" >&2
    exit 1
}

require_tool() {
    local tool="$1"
    command -v "$tool" >/dev/null 2>&1 || die "required tool not found in PATH: $tool"
}

warn_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        echo "[thesis-check][WARN] ${label} missing: ${path:-<empty>}" >&2
        return 0
    fi
    echo "[thesis-check][OK]   ${label}: $path"
    return 0
}

check_path_list() {
    local label="$1"
    local raw="$2"
    local item
    local items=()
    split_path_list "$raw" items
    [[ "${#items[@]}" -gt 0 ]] || die "${label} missing: <empty>"
    for item in "${items[@]}"; do
        check_path "${label}" "$(resolve_path "$item")"
    done
}

check_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        die "${label} missing: ${path:-<empty>}"
    fi
    echo "[thesis-check][OK]   ${label}: $path"
}

[[ -n "${SMIC40_PDK_ROOT:-}" ]] || die "SMIC40_PDK_ROOT is not set"
[[ -d "${SMIC40_PDK_ROOT}" ]] || die "SMIC40_PDK_ROOT is not a directory: ${SMIC40_PDK_ROOT}"

require_tool dc_shell
require_tool vcs
require_tool innovus

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${FLOW_ROOT}/config/design.std.env"
export LIBS_ENV="${FLOW_ROOT}/config/libs.env"
export DIP_COMPILE_PROFILE="${DIP_COMPILE_PROFILE:-gated_default}"

# shellcheck disable=SC1091
source "${FLOW_ROOT}/scripts/prepare_env.sh"

"${FLOW_ROOT}/scripts/check_handoff.sh"
"${FLOW_ROOT}/scripts/check_backend_inputs.sh" dc

check_path "SIM_LIBRARY_VERILOG" "${SIM_LIBRARY_VERILOG}"
check_path "INNOVUS_TECH_LEF" "${INNOVUS_TECH_LEF}"
check_path_list "INNOVUS_LEF_FILES" "${INNOVUS_LEF_FILES}"
check_path "INNOVUS_LIB_MAX" "${INNOVUS_LIB_MAX}"
check_path "INNOVUS_LIB_MIN" "${INNOVUS_LIB_MIN}"
warn_path "INNOVUS_QRC_TECH_FILE" "${INNOVUS_QRC_TECH_FILE}"
warn_path "INNOVUS_GDS_MAP" "${INNOVUS_GDS_MAP}"

if command -v strmin >/dev/null 2>&1; then
    echo "[thesis-check][OK]   strmin: $(command -v strmin)"
else
    echo "[thesis-check][WARN] strmin not found in PATH; Virtuoso layout import will be unavailable." >&2
fi
if command -v virtuoso >/dev/null 2>&1; then
    echo "[thesis-check][OK]   virtuoso: $(command -v virtuoso)"
else
    echo "[thesis-check][WARN] virtuoso not found in PATH; Innovus can still run, but OA layout viewing cannot." >&2
fi
if [[ -n "${VIRTUOSO_TECH_LIB:-}" ]]; then
    echo "[thesis-check][OK]   VIRTUOSO_TECH_LIB=${VIRTUOSO_TECH_LIB}"
else
    echo "[thesis-check][WARN] VIRTUOSO_TECH_LIB is empty; set it before running run_virtuoso_layout.sh." >&2
fi

echo "[thesis-check][INFO] DESIGN_NAME=${DESIGN_NAME}"
echo "[thesis-check][INFO] CLOCK_PERIOD_NS=${CLOCK_PERIOD_NS}"
echo "[thesis-check][INFO] TARGET_LIBRARY=${TARGET_LIBRARY}"
echo "[thesis-check][INFO] INNOVUS_TECH_LEF=${INNOVUS_TECH_LEF}"
echo "[thesis-check][INFO] INNOVUS_QRC_TECH_FILE=${INNOVUS_QRC_TECH_FILE}"
echo "[thesis-check][PASS] thesis environment looks ready"
