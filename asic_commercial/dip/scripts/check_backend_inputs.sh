#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

mode="${1:-all}"
status=0

check_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        echo "[dip-flow][MISS] ${label}: ${path:-<empty>}" >&2
        status=1
    else
        echo "[dip-flow][OK]   ${label}: $path"
    fi
}

check_lib_list() {
    local label="$1"
    local raw="$2"
    local items=()
    split_path_list "$raw" items
    if [[ "${#items[@]}" -eq 0 ]]; then
        echo "[dip-flow][MISS] ${label}: <empty>" >&2
        status=1
        return
    fi
    local item resolved
    for item in "${items[@]}"; do
        [[ "$item" == "*" ]] && continue
        resolved="$(resolve_path "$item")"
        check_path "${label}" "$resolved"
    done
}

check_dc() {
    check_lib_list "TARGET_LIBRARY" "${TARGET_LIBRARY:-}"
    check_lib_list "LINK_LIBRARY" "${LINK_LIBRARY:-}"
}

check_postsim() {
    check_path "POSTSIM netlist" "$POSTSIM_NETLIST"
    if [[ "${POSTSIM_SDF_MODE:-dc}" != "none" ]]; then
        check_path "POSTSIM SDF" "$POSTSIM_SDF"
    fi
    check_path "SIM_LIBRARY_VERILOG" "$(resolve_path "${SIM_LIBRARY_VERILOG:-}")"
    if [[ -n "${ADDITIONAL_SIM_VERILOGS:-}" ]]; then
        local extra=()
        local item
        split_path_list "$ADDITIONAL_SIM_VERILOGS" extra
        for item in "${extra[@]}"; do
            check_path "ADDITIONAL_SIM_VERILOGS" "$(resolve_path "$item")"
        done
    fi
    check_path "POSTSIM TB" "$POSTSIM_TB_FILE"
}

check_frontsim() {
    check_path "FRONTSIM TB" "$FRONTSIM_TB_FILE"
    check_path "filelist" "$FILELIST"
}

check_icc2() {
    check_path "ICC2_TECH_FILE" "$(resolve_path "${ICC2_TECH_FILE:-}")"
    check_lib_list "ICC2_REFERENCE_LIBS" "${ICC2_REFERENCE_LIBS:-}"
    check_path "ICC2 input netlist" "$ICC2_INPUT_NETLIST"
    if [[ -n "${TLUPLUS_MAX:-}" ]]; then check_path "TLUPLUS_MAX" "$(resolve_path "$TLUPLUS_MAX")"; fi
    if [[ -n "${TLUPLUS_MIN:-}" ]]; then check_path "TLUPLUS_MIN" "$(resolve_path "$TLUPLUS_MIN")"; fi
    if [[ -n "${TLUPLUS_MAP:-}" ]]; then check_path "TLUPLUS_MAP" "$(resolve_path "$TLUPLUS_MAP")"; fi
}

check_calibre_drc() {
    check_path "CALIBRE_DRC_RUNSET" "$(resolve_path "${CALIBRE_DRC_RUNSET:-}")"
    check_path "Calibre GDS" "$CALIBRE_GDS"
}

check_calibre_lvs() {
    check_path "CALIBRE_LVS_RUNSET" "$(resolve_path "${CALIBRE_LVS_RUNSET:-}")"
    check_path "Calibre GDS" "$CALIBRE_GDS"
    check_path "Calibre source netlist" "$CALIBRE_SOURCE_NETLIST"
}

case "$mode" in
    all)
        check_frontsim
        check_dc
        check_postsim
        check_icc2
        check_calibre_drc
        check_calibre_lvs
        ;;
    frontsim) check_frontsim ;;
    dc) check_dc ;;
    postsim) check_postsim ;;
    icc2) check_icc2 ;;
    calibre_drc) check_calibre_drc ;;
    calibre_lvs) check_calibre_lvs ;;
    fm)
        check_dc
        check_path "FM implementation netlist" "$FM_IMPL_NETLIST"
        ;;
    *)
        die "unsupported backend input check mode: $mode"
        ;;
esac

exit "$status"
