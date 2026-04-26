#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
REPO_ROOT=$(builtin cd "${SCRIPT_DIR}/../.." && /bin/pwd -P)
RUNSET_ROOT="${REPO_ROOT}/asic_commercial/dip"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/source_eda_env.sh"

die() {
    echo "[thesis-check][ERROR] $*" >&2
    exit 1
}

require_tool() {
    local tool="$1"
    command -v "$tool" >/dev/null 2>&1 || die "required tool not found in PATH: $tool"
    echo "[thesis-check][OK]   ${tool}: $(command -v "$tool")"
}

check_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        die "${label} missing: ${path:-<empty>}"
    fi
    echo "[thesis-check][OK]   ${label}: $path"
}

warn_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        echo "[thesis-check][WARN] ${label} missing: ${path:-<empty>}" >&2
        return 0
    fi
    echo "[thesis-check][OK]   ${label}: $path"
}

require_optional_tool() {
    local tool="$1"
    if command -v "$tool" >/dev/null 2>&1; then
        echo "[thesis-check][OK]   ${tool}: $(command -v "$tool")"
    else
        echo "[thesis-check][WARN] optional tool not found in PATH: ${tool}" >&2
    fi
}

check_path_list() {
    local label="$1"
    local raw="$2"
    local items=()
    local item
    split_path_list "$raw" items
    [[ "${#items[@]}" -gt 0 ]] || die "${label} missing: <empty>"
    for item in "${items[@]}"; do
        [[ "$item" == "*" ]] && continue
        check_path "$label" "$(resolve_path "$item")"
    done
}

check_flow() (
    local flow="$1"
    local flow_root="${REPO_ROOT}/asic_commercial/${flow}"
    [[ -d "${flow_root}" ]] || die "flow root missing: ${flow_root}"

    export FLOW_ROOT="${flow_root}"
    export REPO_ROOT
    export DESIGN_ENV="${flow_root}/config/design.env"
    export LIBS_ENV="${flow_root}/config/libs.env"
    export TSMC28_ROOT

    echo "[thesis-check][INFO] checking flow=${flow}"

    # shellcheck disable=SC1091
    source "${RUNSET_ROOT}/scripts/prepare_env.sh"

    "${RUNSET_ROOT}/scripts/check_handoff.sh"
    "${RUNSET_ROOT}/scripts/check_backend_inputs.sh" dc

    check_path_list "SIM_LIBRARY_VERILOG" "${SIM_LIBRARY_VERILOG}"
    check_path "INNOVUS_TECH_LEF" "$(resolve_path "${INNOVUS_TECH_LEF}")"
    check_path_list "INNOVUS_LEF_FILES" "${INNOVUS_LEF_FILES}"
    check_path "INNOVUS_LIB_MAX" "$(resolve_path "${INNOVUS_LIB_MAX}")"
    check_path "INNOVUS_LIB_MIN" "$(resolve_path "${INNOVUS_LIB_MIN}")"
    warn_path "INNOVUS_QRC_TECH_FILE" "$(resolve_path "${INNOVUS_QRC_TECH_FILE:-}")"
    warn_path "INNOVUS_GDS_MAP" "$(resolve_path "${INNOVUS_GDS_MAP:-}")"
    check_path_list "INNOVUS_GDS_MERGE_FILES" "${INNOVUS_GDS_MERGE_FILES}"
    warn_path "CALIBRE_DRC_RUNSET" "$(resolve_path "${CALIBRE_DRC_RUNSET}")"
    warn_path "CALIBRE_LVS_RUNSET" "$(resolve_path "${CALIBRE_LVS_RUNSET}")"
    warn_path "CALIBRE_LVS_SOURCE_SPICE" "$(resolve_path "${CALIBRE_LVS_SOURCE_SPICE}")"

    if [[ "${RUN_VIRTUOSO:-0}" == "1" ]]; then
        [[ -n "${VIRTUOSO_TECH_LIB:-}" ]] || die "VIRTUOSO_TECH_LIB is empty; set it before running Virtuoso import"
        echo "[thesis-check][OK]   VIRTUOSO_TECH_LIB=${VIRTUOSO_TECH_LIB}"
    elif [[ -n "${VIRTUOSO_TECH_LIB:-}" ]]; then
        echo "[thesis-check][OK]   VIRTUOSO_TECH_LIB=${VIRTUOSO_TECH_LIB}"
    else
        echo "[thesis-check][INFO] VIRTUOSO_TECH_LIB is empty; Virtuoso import is optional and disabled by default"
    fi

    echo "[thesis-check][INFO] DESIGN_NAME=${DESIGN_NAME}"
    echo "[thesis-check][INFO] CLOCK_PERIOD_NS=${CLOCK_PERIOD_NS}"
    echo "[thesis-check][INFO] TARGET_LIBRARY=${TARGET_LIBRARY}"
    echo "[thesis-check][INFO] INNOVUS_TECH_LEF=${INNOVUS_TECH_LEF}"
)

export TSMC28_ROOT="${TSMC28_ROOT:-/opt/eda_tools/TSMC28}"
[[ -d "${TSMC28_ROOT}" ]] || die "TSMC28_ROOT is not a directory: ${TSMC28_ROOT}"

require_tool dc_shell
require_tool fm_shell
require_tool vcs
require_tool innovus
require_optional_tool calibre
require_optional_tool v2lvs
require_optional_tool strmin
require_optional_tool virtuoso

flows=(${THESIS_FLOWS:-dip is os})
for flow in "${flows[@]}"; do
    case "$flow" in
        dip|is|os) check_flow "$flow" ;;
        *) die "unsupported THESIS_FLOWS item: $flow" ;;
    esac
done

echo "[thesis-check][PASS] TSMC28 thesis environment looks ready for: ${flows[*]}"
