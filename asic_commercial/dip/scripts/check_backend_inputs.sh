#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
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

warn_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        echo "[dip-flow][WARN] ${label}: ${path:-<empty>}" >&2
    else
        echo "[dip-flow][OK]   ${label}: $path"
    fi
}

check_innovus_tech_lef() {
    local raw="${INNOVUS_TECH_LEF:-}"
    local path
    path="$(resolve_path "$raw")"
    if [[ -z "$path" || ! -e "$path" ]]; then
        echo "[dip-flow][MISS] INNOVUS_TECH_LEF: ${path:-<empty>}" >&2
        status=1
        return
    fi

    if declare -F is_probable_tech_lef >/dev/null 2>&1 && ! is_probable_tech_lef "$path"; then
        echo "[dip-flow][MISS] INNOVUS_TECH_LEF is not a technology LEF: $path" >&2
        echo "[dip-flow][MISS] Provide a real tech LEF via INNOVUS_TECH_LEF; current file looks like macro LEF only." >&2
        status=1
        return
    fi

    echo "[dip-flow][OK]   INNOVUS_TECH_LEF: $path"
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

check_innovus() {
    check_innovus_tech_lef
    check_lib_list "INNOVUS_LEF_FILES" "${INNOVUS_LEF_FILES:-}"
    check_path "INNOVUS_LIB_MAX" "$(resolve_path "${INNOVUS_LIB_MAX:-}")"
    check_path "INNOVUS_LIB_MIN" "$(resolve_path "${INNOVUS_LIB_MIN:-}")"
    warn_path "INNOVUS_QRC_TECH_FILE" "$(resolve_path "${INNOVUS_QRC_TECH_FILE:-}")"
    check_path "INNOVUS input netlist" "$INNOVUS_INPUT_NETLIST"
    if [[ -n "${INNOVUS_GDS_MAP:-}" ]]; then
        warn_path "INNOVUS_GDS_MAP" "$(resolve_path "${INNOVUS_GDS_MAP}")"
    fi
    if [[ -n "${INNOVUS_GDS_MERGE_FILES:-}" ]]; then
        check_lib_list "INNOVUS_GDS_MERGE_FILES" "${INNOVUS_GDS_MERGE_FILES}"
    fi
}

check_icc() {
    if [[ "${ICC_CREATE_LIB_MODE:-auto}" == "copy" ]]; then
        check_path "ICC_BASE_MW_LIB" "$(resolve_path "${ICC_BASE_MW_LIB:-}")"
    else
        check_path "ICC_TECH_FILE" "$(resolve_path "${ICC_TECH_FILE:-}")"
        warn_path "ICC_BASE_MW_LIB" "$(resolve_path "${ICC_BASE_MW_LIB:-}")"
    fi
    check_lib_list "ICC_REFERENCE_LIBS" "${ICC_REFERENCE_LIBS:-}"
    check_path "ICC input netlist" "$ICC_INPUT_NETLIST"
    check_lib_list "TARGET_LIBRARY" "${TARGET_LIBRARY:-}"
    check_lib_list "LINK_LIBRARY" "${LINK_LIBRARY:-}"
    warn_path "ICC_TLUPLUS_MAX" "$(resolve_path "${ICC_TLUPLUS_MAX:-}")"
    warn_path "ICC_TLUPLUS_MIN" "$(resolve_path "${ICC_TLUPLUS_MIN:-}")"
    warn_path "ICC_TLUPLUS_MAP" "$(resolve_path "${ICC_TLUPLUS_MAP:-}")"
    warn_path "ICC_ITF_FILE" "$(resolve_path "${ICC_ITF_FILE:-}")"
    warn_path "ICC_TECH2ITF_MAP" "$(resolve_path "${ICC_TECH2ITF_MAP:-}")"
}

check_virtuoso() {
    if [[ -z "${VIRTUOSO_TECH_LIB:-}" ]]; then
        echo "[dip-flow][MISS] VIRTUOSO_TECH_LIB: <empty>" >&2
        status=1
    else
        echo "[dip-flow][OK]   VIRTUOSO_TECH_LIB: ${VIRTUOSO_TECH_LIB}"
    fi
    if [[ -n "${VIRTUOSO_STREAM_MAP:-}" ]]; then
        check_path "VIRTUOSO_STREAM_MAP" "$(resolve_path "${VIRTUOSO_STREAM_MAP}")"
    fi
}

check_calibre_drc() {
    check_path "CALIBRE_DRC_RUNSET" "$(resolve_path "${CALIBRE_DRC_RUNSET:-}")"
    check_path "Calibre GDS" "$CALIBRE_GDS"
}

check_calibre_lvs() {
    check_path "CALIBRE_LVS_RUNSET" "$(resolve_path "${CALIBRE_LVS_RUNSET:-}")"
    check_path "Calibre LVS GDS" "$CALIBRE_LVS_GDS"
    check_path "Calibre source netlist" "$CALIBRE_SOURCE_NETLIST"
    if [[ "${CALIBRE_LVS_TEXT_MODE:-gds}" == "ports_only" ]]; then
        check_path "Calibre LVS port DEF" "$CALIBRE_LVS_PORT_DEF"
    fi
    case "${CALIBRE_SOURCE_NETLIST}" in
        *.v|*.vg|*.sv)
            check_path "CALIBRE_LVS_SOURCE_SPICE" "$(resolve_path "${CALIBRE_LVS_SOURCE_SPICE:-}")"
            ;;
    esac
}

case "$mode" in
    all)
        check_frontsim
        check_dc
        check_postsim
        check_innovus
        if [[ -n "${ICC_BASE_MW_LIB:-}" || -n "${ICC_REFERENCE_LIBS:-}" ]]; then
            echo "[dip-flow][INFO] skipping deprecated ICC checks in mode=all; Innovus is the supported backend"
        fi
        if [[ "${RUN_CALIBRE_DRC:-0}" == "1" || "${WS_RUN_CALIBRE_DRC:-0}" == "1" ]]; then
            check_calibre_drc
        else
            echo "[dip-flow][INFO] skipping Calibre DRC checks; set RUN_CALIBRE_DRC=1 or use mode=signoff"
        fi
        if [[ "${RUN_CALIBRE_LVS:-0}" == "1" || "${WS_RUN_CALIBRE_LVS:-0}" == "1" ]]; then
            check_calibre_lvs
        else
            echo "[dip-flow][INFO] skipping Calibre LVS checks; set RUN_CALIBRE_LVS=1 or use mode=signoff"
        fi
        if [[ "${RUN_VIRTUOSO:-0}" == "1" ]]; then
            check_virtuoso
        else
            echo "[dip-flow][INFO] skipping Virtuoso checks; set RUN_VIRTUOSO=1 or use mode=virtuoso"
        fi
        ;;
    frontsim) check_frontsim ;;
    dc) check_dc ;;
    postsim) check_postsim ;;
    innovus) check_innovus ;;
    icc|icc2) die "deprecated backend check mode: $mode; use innovus" ;;
    virtuos*) check_virtuoso ;;
    calibre_drc) check_calibre_drc ;;
    calibre_lvs) check_calibre_lvs ;;
    signoff)
        check_innovus
        check_calibre_drc
        check_calibre_lvs
        check_virtuoso
        ;;
    fm)
        check_dc
        check_path "FM implementation netlist" "$FM_IMPL_NETLIST"
        if [[ -n "${FM_SVF:-}" ]]; then
            check_path "FM SVF" "$FM_SVF"
        fi
        ;;
    *)
        die "unsupported backend input check mode: $mode"
        ;;
esac

exit "$status"
