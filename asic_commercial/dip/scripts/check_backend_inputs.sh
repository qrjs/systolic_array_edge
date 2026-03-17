#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

stage="${1:-all}"

case "${stage}" in
    dc|postsim|fm|icc2|calibre_drc|calibre_lvs|all)
        ;;
    *)
        echo "error: unsupported stage '${stage}'" >&2
        echo "usage: $0 [dc|postsim|fm|icc2|calibre_drc|calibre_lvs|all]" >&2
        exit 1
        ;;
esac

status=0

is_placeholder() {
    local value="$1"
    [[ -z "${value}" || "${value}" == /path/to/* || "${value}" == REPLACE_ME* ]]
}

check_path_var() {
    local var_name="$1"
    local label="$2"
    local value="${!var_name:-}"

    if is_placeholder "${value}"; then
        echo "[missing] ${label}: ${var_name} is not filled" >&2
        status=1
        return
    fi

    if [[ -f "${value}" ]]; then
        echo "[ok] ${label}: ${value}"
    else
        echo "[missing] ${label}: ${value}" >&2
        status=1
    fi
}

check_optional_path_var() {
    local var_name="$1"
    local label="$2"
    local value="${!var_name:-}"

    if [[ -z "${value}" ]]; then
        echo "[skip] ${label}: ${var_name} not set"
        return
    fi

    if [[ -f "${value}" ]]; then
        echo "[ok] ${label}: ${value}"
    else
        echo "[warn] ${label}: ${value} does not exist yet" >&2
    fi
}

check_list_var() {
    local var_name="$1"
    local label="$2"
    local entry
    local found=0

    for entry in ${!var_name:-}; do
        [[ "${entry}" == "*" ]] && continue
        found=1
        if [[ -f "${entry}" ]]; then
            echo "[ok] ${label}: ${entry}"
        else
            echo "[missing] ${label}: ${entry}" >&2
            status=1
        fi
    done

    if [[ "${found}" -eq 0 ]]; then
        echo "[missing] ${label}: ${var_name} is empty" >&2
        status=1
    fi
}

check_nonempty_var() {
    local var_name="$1"
    local label="$2"
    local value="${!var_name:-}"

    if is_placeholder "${value}"; then
        echo "[missing] ${label}: ${var_name} is not filled" >&2
        status=1
    else
        echo "[ok] ${label}: ${value}"
    fi
}

echo "[info] checking backend inputs for stage: ${stage}"

if [[ ! -f "${DIP_ROOT}/config/libs.env" ]]; then
    echo "[missing] commercial library config: ${DIP_ROOT}/config/libs.env" >&2
    echo "hint: copy config/libs.example.env to config/libs.env first" >&2
    exit 1
fi

if [[ "${stage}" == "dc" || "${stage}" == "all" ]]; then
    check_path_var TARGET_LIBRARY "DC target library"
    check_list_var LINK_LIBRARY "DC link library"
    check_nonempty_var MAX_CORES "DC max cores"
fi

if [[ "${stage}" == "postsim" || "${stage}" == "all" ]]; then
    check_path_var SIM_LIBRARY_VERILOG "Gate sim library Verilog"
    if [[ -n "${ADDITIONAL_SIM_VERILOGS:-}" ]]; then
        for simv in ${ADDITIONAL_SIM_VERILOGS}; do
            if [[ -f "${simv}" ]]; then
                echo "[ok] additional sim Verilog: ${simv}"
            else
                echo "[missing] additional sim Verilog: ${simv}" >&2
                status=1
            fi
        done
    else
        echo "[skip] additional sim Verilog: none configured"
    fi

    case "${POSTSIM_NETLIST_MODE}" in
        dc)
            if [[ -f "${SYNTH_NETLIST}" ]]; then
                echo "[ok] postsim netlist from DC: ${SYNTH_NETLIST}"
            else
                echo "[warn] postsim netlist will come from DC, but synthesis output is not present yet: ${SYNTH_NETLIST}" >&2
            fi
            ;;
        custom)
            check_path_var CUSTOM_NETLIST "Custom postsim netlist"
            ;;
    esac

    case "${POSTSIM_SDF_MODE}" in
        dc)
            if [[ -f "${SYNTH_SDF}" ]]; then
                echo "[ok] postsim SDF from DC: ${SYNTH_SDF}"
            else
                echo "[warn] postsim SDF will come from DC, but synthesis output is not present yet: ${SYNTH_SDF}" >&2
            fi
            ;;
        icc2)
            if [[ -f "${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.sdf" ]]; then
                echo "[ok] postsim SDF from ICC2: ${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.sdf"
            else
                echo "[warn] postsim SDF will come from ICC2, but route output is not present yet: ${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.sdf" >&2
            fi
            ;;
        none)
            echo "[ok] postsim SDF mode: none"
            ;;
        custom)
            check_path_var POSTSIM_SDF "Custom postsim SDF"
            ;;
    esac
fi

if [[ "${stage}" == "fm" || "${stage}" == "all" ]]; then
    if [[ -f "${SYNTH_SVF}" ]]; then
        echo "[ok] FM SVF from DC: ${SYNTH_SVF}"
    else
        echo "[warn] FM will use SVF from DC, but synthesis output is not present yet: ${SYNTH_SVF}" >&2
    fi

    case "${FM_IMPLEMENTATION_MODE}" in
        dc)
            if [[ -f "${SYNTH_NETLIST}" ]]; then
                echo "[ok] FM implementation netlist from DC: ${SYNTH_NETLIST}"
            else
                echo "[warn] FM implementation netlist will come from DC, but synthesis output is not present yet: ${SYNTH_NETLIST}" >&2
            fi
            ;;
        icc2)
            if [[ -f "${ICC2_FINAL_NETLIST}" ]]; then
                echo "[ok] FM implementation netlist from ICC2: ${ICC2_FINAL_NETLIST}"
            else
                echo "[warn] FM implementation netlist will come from ICC2, but export output is not present yet: ${ICC2_FINAL_NETLIST}" >&2
            fi
            ;;
        custom)
            check_path_var CUSTOM_NETLIST "Custom FM implementation netlist"
            ;;
    esac
fi

if [[ "${stage}" == "icc2" || "${stage}" == "all" ]]; then
    check_path_var ICC2_TECH_FILE "ICC2 tech file"
    check_list_var ICC2_REFERENCE_LIBS "ICC2 reference libraries"
    check_path_var TLUPLUS_MAX "ICC2 TLU+ max"
    check_path_var TLUPLUS_MIN "ICC2 TLU+ min"
    check_path_var TLUPLUS_MAP "ICC2 TLU+ map"
    check_nonempty_var POWER_NET "Power net"
    check_nonempty_var GROUND_NET "Ground net"
    check_nonempty_var PLACE_SITE "Placement site"
    check_nonempty_var CORE_UTILIZATION "Core utilization"
    check_nonempty_var CORE_MARGIN_LEFT "Core margin left"
    check_nonempty_var CORE_MARGIN_BOTTOM "Core margin bottom"
    check_nonempty_var CORE_MARGIN_RIGHT "Core margin right"
    check_nonempty_var CORE_MARGIN_TOP "Core margin top"

    case "${ICC2_NETLIST_MODE}" in
        dc)
            if [[ -f "${SYNTH_NETLIST}" ]]; then
                echo "[ok] ICC2 netlist from DC: ${SYNTH_NETLIST}"
            else
                echo "[warn] ICC2 netlist will come from DC, but synthesis output is not present yet: ${SYNTH_NETLIST}" >&2
            fi
            ;;
        custom)
            check_path_var CUSTOM_NETLIST "Custom ICC2 netlist"
            ;;
    esac

    check_optional_path_var GDS_STREAM_OUT_MAP "GDS stream-out map"
fi

if [[ "${stage}" == "calibre_drc" || "${stage}" == "all" ]]; then
    check_path_var CALIBRE_DRC_RUNSET "Calibre DRC runset"
    check_path_var CALIBRE_LAYOUT_GDS "Calibre layout GDS"
fi

if [[ "${stage}" == "calibre_lvs" || "${stage}" == "all" ]]; then
    check_path_var CALIBRE_LVS_RUNSET "Calibre LVS runset"
    check_path_var CALIBRE_LAYOUT_GDS "Calibre layout GDS"
    check_path_var CALIBRE_SOURCE_NETLIST "Calibre source netlist"
fi

exit "${status}"
