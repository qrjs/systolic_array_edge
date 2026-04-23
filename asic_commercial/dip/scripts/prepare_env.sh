#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export FLOW_ROOT="${FLOW_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
export REPO_ROOT=$(cd "${FLOW_ROOT}/../.." && pwd)
export CONFIG_DIR="${FLOW_ROOT}/config"
EDA_ENV_SCRIPT="${FLOW_ROOT}/../scripts/source_eda_env.sh"
[[ -f "${EDA_ENV_SCRIPT}" ]] && source "${EDA_ENV_SCRIPT}"
DESIGN_ENV_INPUT="${DESIGN_ENV:-${CONFIG_DIR}/design.env}"
LIBS_ENV_INPUT="${LIBS_ENV:-${CONFIG_DIR}/libs.env}"

die() {
    echo "[dip-flow][ERROR] $*" >&2
    exit 1
}

require_file() {
    local label="$1"
    local path="$2"
    [[ -f "$path" ]] || die "$label not found: $path"
}

require_tool() {
    local tool="$1"
    command -v "$tool" >/dev/null 2>&1 || die "required tool not found in PATH: $tool"
}

resolve_path() {
    local raw="${1:-}"
    if [[ -z "$raw" ]]; then
        return 0
    fi
    if [[ "$raw" = /* ]]; then
        printf '%s\n' "$raw"
    else
        printf '%s\n' "${REPO_ROOT}/${raw}"
    fi
}

resolve_repo_or_flow_path() {
    local raw="${1:-}"
    if [[ -z "$raw" ]]; then
        return 0
    fi
    if [[ "$raw" = /* ]]; then
        printf '%s\n' "$raw"
    elif [[ -e "${FLOW_ROOT}/${raw}" ]]; then
        printf '%s\n' "${FLOW_ROOT}/${raw}"
    else
        printf '%s\n' "${REPO_ROOT}/${raw}"
    fi
}

split_path_list() {
    local raw="${1:-}"
    local out_name="$2"
    eval "$out_name=()"
    [[ -z "$raw" ]] && return 0
    local item
    set -f
    for item in $raw; do
        eval "$out_name+=(\"\$item\")"
    done
    set +f
}

choose_netlist() {
    local mode="$1"
    case "$mode" in
        dc) printf '%s\n' "$DC_NETLIST" ;;
        innovus | icc2) printf '%s\n' "$INNOVUS_NETLIST" ;;
        custom) printf '%s\n' "$(resolve_path "${CUSTOM_NETLIST:-}")" ;;
        open_source) printf '%s\n' "$OPEN_SOURCE_NETLIST" ;;
        *) die "unsupported netlist mode: $mode" ;;
    esac
}

choose_sdf() {
    local mode="$1"
    case "$mode" in
        none) printf '%s\n' "" ;;
        dc) printf '%s\n' "$DC_SDF" ;;
        innovus | icc2) printf '%s\n' "$INNOVUS_SDF" ;;
        custom) printf '%s\n' "$(resolve_path "${CUSTOM_SDF:-}")" ;;
        *) die "unsupported SDF mode: $mode" ;;
    esac
}

choose_calibre_gds() {
    local mode="$1"
    case "$mode" in
        innovus | icc2) printf '%s\n' "$INNOVUS_GDS" ;;
        custom) printf '%s\n' "$(resolve_path "${CALIBRE_CUSTOM_GDS:-}")" ;;
        *) die "unsupported Calibre layout mode: $mode" ;;
    esac
}

choose_calibre_source() {
    local mode="$1"
    case "$mode" in
        dc) printf '%s\n' "$DC_NETLIST" ;;
        innovus | icc2) printf '%s\n' "$INNOVUS_NETLIST" ;;
        custom) printf '%s\n' "$(resolve_path "${CALIBRE_CUSTOM_SOURCE_NETLIST:-}")" ;;
        *) die "unsupported Calibre source mode: $mode" ;;
    esac
}

export DESIGN_ENV="$(resolve_repo_or_flow_path "$DESIGN_ENV_INPUT")"
export LIBS_ENV="$(resolve_repo_or_flow_path "$LIBS_ENV_INPUT")"

require_file "design env" "$DESIGN_ENV"
require_file "libs env" "$LIBS_ENV"

# shellcheck disable=SC1090
source "$DESIGN_ENV"
# shellcheck disable=SC1090
source "$LIBS_ENV"

export RTL_WRAPPER=$(resolve_path "${RTL_WRAPPER_REL}")
export FILELIST=$(resolve_path "${FILELIST_REL}")
export SDC_FILE=$(resolve_path "${SDC_REL}")
export OPEN_SOURCE_NETLIST=$(resolve_path "${OPEN_SOURCE_NETLIST_REL:-}")
default_frontsim_tb_file="$(resolve_repo_or_flow_path "${FRONTSIM_TB_FILE_REL}")"
export FRONTSIM_TB_FILE="$(resolve_repo_or_flow_path "${FRONTSIM_TB_FILE_OVERRIDE:-$default_frontsim_tb_file}")"
export FRONTSIM_TB_TOP="${FRONTSIM_TB_TOP_OVERRIDE:-${FRONTSIM_TB_TOP}}"
export FRONTSIM_PASS_MARKER="${FRONTSIM_PASS_MARKER_OVERRIDE:-${FRONTSIM_PASS_MARKER}}"
default_postsim_tb_file="$(resolve_repo_or_flow_path "${POSTSIM_TB_FILE_REL}")"
export POSTSIM_TB_FILE="$(resolve_repo_or_flow_path "${POSTSIM_TB_FILE_OVERRIDE:-$default_postsim_tb_file}")"
export POSTSIM_TB_TOP="${POSTSIM_TB_TOP_OVERRIDE:-${POSTSIM_TB_TOP}}"
export POSTSIM_PASS_MARKER="${POSTSIM_PASS_MARKER_OVERRIDE:-${POSTSIM_PASS_MARKER}}"

export RESULTS_DIR="${FLOW_ROOT}/results"
export REPORTS_DIR="${FLOW_ROOT}/reports"
export LOGS_DIR="${FLOW_ROOT}/logs"
export DC_WORK_DIR="${FLOW_ROOT}/dc/work"
export FRONTSIM_WORK_DIR="${FLOW_ROOT}/frontsim/work"
export FRONTSIM_LOG_DIR="${FLOW_ROOT}/frontsim/logs"
export POSTSIM_WORK_DIR="${FLOW_ROOT}/postsim/work"
export POSTSIM_LOG_DIR="${FLOW_ROOT}/postsim/logs"
export POSTSIM_SUITE_DIR="${POSTSIM_SUITE_DIR:-${FLOW_ROOT}/postsim/suites}"
export INNOVUS_WORK_DIR="${FLOW_ROOT}/innovus/work"
export INNOVUS_REPORT_DIR="${REPORTS_DIR}/innovus"
export INNOVUS_RESULTS_DIR="${RESULTS_DIR}/innovus"
export ICC2_WORK_DIR="${ICC2_WORK_DIR:-${INNOVUS_WORK_DIR}}"
export ICC2_LIB_DIR="${ICC2_LIB_DIR:-${FLOW_ROOT}/icc2/lib}"
export ICC2_REPORT_DIR="${ICC2_REPORT_DIR:-${INNOVUS_REPORT_DIR}}"
export ICC2_RESULTS_DIR="${ICC2_RESULTS_DIR:-${INNOVUS_RESULTS_DIR}}"
export ICC_WORK_DIR="${FLOW_ROOT}/icc/work"
export ICC_LIB_DIR="${FLOW_ROOT}/icc/lib"
export ICC_REPORT_DIR="${REPORTS_DIR}/icc"
export FM_WORK_DIR="${FLOW_ROOT}/fm/work"
export FM_REPORT_DIR="${REPORTS_DIR}/fm"
export CALIBRE_WORK_DIR="${FLOW_ROOT}/calibre/work"
export CALIBRE_REPORT_DIR="${REPORTS_DIR}/calibre"
export VIRTUOSO_WORK_DIR="${FLOW_ROOT}/virtuoso"

mkdir -p \
    "$RESULTS_DIR" "$REPORTS_DIR" "$LOGS_DIR" \
    "$DC_WORK_DIR" "$FRONTSIM_WORK_DIR" "$FRONTSIM_LOG_DIR" \
    "$POSTSIM_WORK_DIR" "$POSTSIM_LOG_DIR" "$POSTSIM_SUITE_DIR" \
    "$INNOVUS_WORK_DIR" "$INNOVUS_REPORT_DIR" "$INNOVUS_RESULTS_DIR" \
    "$ICC2_LIB_DIR" \
    "$ICC_WORK_DIR" "$ICC_LIB_DIR" "$ICC_REPORT_DIR" \
    "$FM_WORK_DIR" "$FM_REPORT_DIR" \
    "$CALIBRE_WORK_DIR" "$CALIBRE_REPORT_DIR" \
    "$VIRTUOSO_WORK_DIR"

export DC_NETLIST="${RESULTS_DIR}/${DESIGN_NAME}_dc.v"
export DC_SDF="${RESULTS_DIR}/${DESIGN_NAME}_dc.sdf"
export DC_DDC="${RESULTS_DIR}/${DESIGN_NAME}_dc.ddc"
export DC_SVF="${RESULTS_DIR}/${DESIGN_NAME}_dc.svf"
export DC_EXPORTED_SDC="${RESULTS_DIR}/${DESIGN_NAME}_dc.sdc"
export DC_AREA_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_area.rpt"
export DC_POWER_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_power.rpt"
export DC_TIMING_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_timing.rpt"
export DC_QOR_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_qor.rpt"
export DC_CHECK_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_check_design.rpt"
export DC_VIOLATORS_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_violators.rpt"
export DC_GATING_RPT="${REPORTS_DIR}/${DESIGN_NAME}_dc_gating_check.rpt"
export DC_LOG_FILE="${LOGS_DIR}/${DESIGN_NAME}_dc.log"

export INNOVUS_INPUT_NETLIST="${INNOVUS_INPUT_NETLIST:-$DC_NETLIST}"
export INNOVUS_NETLIST="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}_innovus.v"
export INNOVUS_SDF="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}_innovus.sdf"
export INNOVUS_DEF="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}.def"
export INNOVUS_GDS="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}.gds"
export INNOVUS_MMMC_FILE="${INNOVUS_WORK_DIR}/${DESIGN_NAME}_view_definition.tcl"
export INNOVUS_CHECKPOINT_PREFIX="${INNOVUS_WORK_DIR}/${DESIGN_NAME}"
export INNOVUS_TIMING_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_timing.rpt"
export INNOVUS_POWER_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_power.rpt"
export INNOVUS_AREA_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_area.rpt"
export INNOVUS_QOR_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_qor.rpt"
export INNOVUS_LOG_FILE="${LOGS_DIR}/${DESIGN_NAME}_innovus.log"
export ICC2_INPUT_NETLIST="${ICC2_INPUT_NETLIST:-${INNOVUS_INPUT_NETLIST}}"
export ICC2_DESIGN_LIB="${ICC2_DESIGN_LIB:-${ICC2_LIB_DIR}/${DESIGN_NAME}.dlib}"
export ICC2_GDS="${ICC2_GDS:-${INNOVUS_GDS}}"
export ICC2_NETLIST="${ICC2_NETLIST:-${INNOVUS_NETLIST}}"
export ICC2_SDF="${ICC2_SDF:-${INNOVUS_SDF}}"
export ICC2_DEF="${ICC2_DEF:-${INNOVUS_DEF}}"
export ICC2_LOG_FILE="${ICC2_LOG_FILE:-${INNOVUS_LOG_FILE}}"

export FRONTSIM_SIMV="${FRONTSIM_WORK_DIR}/${DESIGN_NAME}_rtl.simv"
export FRONTSIM_COMPILE_LOG="${FRONTSIM_LOG_DIR}/${DESIGN_NAME}_rtl_compile.log"
export FRONTSIM_RUN_LOG="${FRONTSIM_LOG_DIR}/${DESIGN_NAME}_rtl_run.log"
export FRONTSIM_VECTOR_INPUT="${FRONTSIM_INPUT:-${REPO_ROOT}/test_vectors/txt/signed_mix_input.txt}"
export FRONTSIM_VECTOR_EXPECTED="${FRONTSIM_EXPECTED:-${REPO_ROOT}/test_vectors/txt/signed_mix_expected.txt}"
export FRONTSIM_CASE="${FRONTSIM_CASE:-${CASE:-}}"
export FRONTSIM_VCD_PATH="${FRONTSIM_VCD_PATH:-}"

export POSTSIM_NETLIST="$(choose_netlist "${POSTSIM_NETLIST_MODE:-dc}")"
export POSTSIM_SDF="$(choose_sdf "${POSTSIM_SDF_MODE:-dc}")"
export POSTSIM_SIMV="${POSTSIM_WORK_DIR}/${DESIGN_NAME}_gate.simv"
export POSTSIM_COMPILE_LOG="${POSTSIM_LOG_DIR}/${DESIGN_NAME}_compile.log"
export POSTSIM_RUN_LOG="${POSTSIM_LOG_DIR}/${DESIGN_NAME}_run.log"
export POSTSIM_VECTOR_DIR="${POSTSIM_VECTOR_DIR:-${REPO_ROOT}/test_vectors/txt}"
export POSTSIM_STAGES="${POSTSIM_STAGES:-none dc innovus}"
export POSTSIM_VECTOR_INPUT="${POSTSIM_INPUT:-${REPO_ROOT}/test_vectors/txt/signed_mix_input.txt}"
export POSTSIM_VECTOR_EXPECTED="${POSTSIM_EXPECTED:-${REPO_ROOT}/test_vectors/txt/signed_mix_expected.txt}"
export POSTSIM_CASE="${POSTSIM_CASE:-${CASE:-}}"
export POSTSIM_VCD_PATH="${POSTSIM_VCD_PATH:-}"

export FM_IMPL_NETLIST="$(choose_netlist "${FM_IMPLEMENTATION_MODE:-dc}")"
export FM_LOG_FILE="${LOGS_DIR}/${DESIGN_NAME}_fm.log"
export FM_SUMMARY_RPT="${FM_REPORT_DIR}/${DESIGN_NAME}_fm_summary.rpt"

export INNOVUS_INPUT_NETLIST="$(choose_netlist "${INNOVUS_NETLIST_MODE:-dc}")"
export ICC2_INPUT_NETLIST="$(choose_netlist "${ICC2_NETLIST_MODE:-${INNOVUS_NETLIST_MODE:-dc}}")"
export ICC_LOG_FILE="${LOGS_DIR}/${DESIGN_NAME}_icc.log"

export CALIBRE_GDS="$(choose_calibre_gds "${CALIBRE_LAYOUT_MODE:-innovus}")"
export CALIBRE_SOURCE_NETLIST="$(choose_calibre_source "${CALIBRE_SOURCE_MODE:-innovus}")"

export VIRTUOSO_LAYOUT_GDS="${VIRTUOSO_LAYOUT_GDS:-$INNOVUS_GDS}"
export VIRTUOSO_LAYOUT_LIB="${VIRTUOSO_LAYOUT_LIB:-${DESIGN_NICKNAME}_layout}"
export VIRTUOSO_TECH_LIB="${VIRTUOSO_TECH_LIB:-}"
