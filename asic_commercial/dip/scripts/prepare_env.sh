#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
export FLOW_ROOT="${FLOW_ROOT:-$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)}"
export REPO_ROOT=$(builtin cd "${FLOW_ROOT}/../.." && /bin/pwd -P)
export CONFIG_DIR="${FLOW_ROOT}/config"
EDA_ENV_SCRIPT="${FLOW_ROOT}/../scripts/source_eda_env.sh"
[[ -f "${EDA_ENV_SCRIPT}" ]] && source "${EDA_ENV_SCRIPT}"
if [[ -z "${TSMC28_ROOT:-}" && -d "${REPO_ROOT}/TSMC28/PDK/Calibre" ]]; then
    export TSMC28_ROOT="${REPO_ROOT}/TSMC28"
fi
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

normalize_flavor() {
    local raw="${1:-default}"
    case "$raw" in
        "" | default | legacy) printf '%s\n' "default" ;;
        plain | gated) printf '%s\n' "$raw" ;;
        *) die "unsupported flavor: $raw" ;;
    esac
}

dc_basename_for_flavor() {
    local flavor
    flavor="$(normalize_flavor "$1")"
    case "$flavor" in
        default) printf '%s\n' "${DESIGN_NAME}_dc" ;;
        plain) printf '%s\n' "${DESIGN_NAME}_dc_plain" ;;
        gated) printf '%s\n' "${DESIGN_NAME}_dc_gated" ;;
    esac
}

choose_dc_netlist_by_flavor() {
    local flavor
    flavor="$(normalize_flavor "$1")"
    case "$flavor" in
        default) printf '%s\n' "$DEFAULT_DC_NETLIST" ;;
        plain) printf '%s\n' "$PLAIN_DC_NETLIST" ;;
        gated) printf '%s\n' "$GATED_DC_NETLIST" ;;
    esac
}

choose_dc_sdf_by_flavor() {
    local flavor
    flavor="$(normalize_flavor "$1")"
    case "$flavor" in
        default) printf '%s\n' "$DEFAULT_DC_SDF" ;;
        plain) printf '%s\n' "$PLAIN_DC_SDF" ;;
        gated) printf '%s\n' "$GATED_DC_SDF" ;;
    esac
}

choose_dc_svf_by_flavor() {
    local flavor
    flavor="$(normalize_flavor "$1")"
    case "$flavor" in
        default) printf '%s\n' "$DEFAULT_DC_SVF" ;;
        plain) printf '%s\n' "$PLAIN_DC_SVF" ;;
        gated) printf '%s\n' "$GATED_DC_SVF" ;;
    esac
}

choose_netlist() {
    local mode="$1"
    local flavor="${2:-default}"
    case "$mode" in
        dc) choose_dc_netlist_by_flavor "$flavor" ;;
        innovus | icc2) printf '%s\n' "$INNOVUS_NETLIST" ;;
        icc) printf '%s\n' "$ICC_NETLIST" ;;
        custom) printf '%s\n' "$(resolve_path "${CUSTOM_NETLIST:-}")" ;;
        open_source) printf '%s\n' "$OPEN_SOURCE_NETLIST" ;;
        *) die "unsupported netlist mode: $mode" ;;
    esac
}

choose_sdf() {
    local mode="$1"
    local flavor="${2:-default}"
    case "$mode" in
        none) printf '%s\n' "" ;;
        dc) choose_dc_sdf_by_flavor "$flavor" ;;
        innovus | icc2) printf '%s\n' "$INNOVUS_SDF" ;;
        icc) printf '%s\n' "$ICC_SDF" ;;
        custom) printf '%s\n' "$(resolve_path "${CUSTOM_SDF:-}")" ;;
        *) die "unsupported SDF mode: $mode" ;;
    esac
}

choose_svf() {
    local mode="$1"
    local flavor="${2:-default}"
    case "$mode" in
        dc | innovus | icc | icc2) choose_dc_svf_by_flavor "$flavor" ;;
        custom | none | open_source) printf '%s\n' "" ;;
        *) die "unsupported SVF mode: $mode" ;;
    esac
}

choose_calibre_gds() {
    local mode="$1"
    case "$mode" in
        innovus | icc2) printf '%s\n' "$INNOVUS_GDS" ;;
        icc) printf '%s\n' "$ICC_GDS" ;;
        custom) printf '%s\n' "$(resolve_path "${CALIBRE_CUSTOM_GDS:-}")" ;;
        *) die "unsupported Calibre layout mode: $mode" ;;
    esac
}

choose_calibre_source() {
    local mode="$1"
    local flavor="${2:-default}"
    case "$mode" in
        dc) choose_dc_netlist_by_flavor "$flavor" ;;
        innovus | icc2) printf '%s\n' "$INNOVUS_LVS_NETLIST" ;;
        innovus_logic) printf '%s\n' "$INNOVUS_NETLIST" ;;
        icc) printf '%s\n' "$ICC_NETLIST" ;;
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

export TARGET_LIBRARY="${TARGET_LIBRARY:-}"
export LINK_LIBRARY="${LINK_LIBRARY:-}"
export MAX_CORES="${MAX_CORES:-8}"
export DC_USE_ULTRA="${DC_USE_ULTRA:-0}"
export SIM_LIBRARY_VERILOG="${SIM_LIBRARY_VERILOG:-}"
export ADDITIONAL_SIM_VERILOGS="${ADDITIONAL_SIM_VERILOGS:-}"
export INNOVUS_TECH_LEF="${INNOVUS_TECH_LEF:-}"
export INNOVUS_LEF_FILES="${INNOVUS_LEF_FILES:-}"
export INNOVUS_LIB_MAX="${INNOVUS_LIB_MAX:-}"
export INNOVUS_LIB_MIN="${INNOVUS_LIB_MIN:-}"
export INNOVUS_QRC_TECH_FILE="${INNOVUS_QRC_TECH_FILE:-}"
export INNOVUS_GDS_MAP="${INNOVUS_GDS_MAP:-}"
export INNOVUS_GDS_MERGE_FILES="${INNOVUS_GDS_MERGE_FILES:-}"
export INNOVUS_GDS_UNITS="${INNOVUS_GDS_UNITS:-1000}"
export INNOVUS_PATCH_VIA_METALS="${INNOVUS_PATCH_VIA_METALS:-0}"
export INNOVUS_GDS_LABEL_ALL_PIN_SHAPES="${INNOVUS_GDS_LABEL_ALL_PIN_SHAPES:-0}"
export INNOVUS_GDS_ATTACH_NET_NAME="${INNOVUS_GDS_ATTACH_NET_NAME:-}"
export INNOVUS_GDS_ATTACH_INSTANCE_NAME="${INNOVUS_GDS_ATTACH_INSTANCE_NAME:-}"
export INNOVUS_VIA_METAL_PATCH_TLEF="${INNOVUS_VIA_METAL_PATCH_TLEF:-$INNOVUS_TECH_LEF}"
export INNOVUS_VIA_METAL_PATCH_ENC_DBU="${INNOVUS_VIA_METAL_PATCH_ENC_DBU:-30}"
export INNOVUS_VIA_METAL_PATCH_GENERIC="${INNOVUS_VIA_METAL_PATCH_GENERIC:-1}"
export INNOVUS_REMAP_GDS_DATATYPES="${INNOVUS_REMAP_GDS_DATATYPES:-0}"
export INNOVUS_PROCESS_NODE="${INNOVUS_PROCESS_NODE:-28}"
export INNOVUS_IO_INPUT_LAYER="${INNOVUS_IO_INPUT_LAYER:-M2}"
export INNOVUS_IO_OUTPUT_LAYER="${INNOVUS_IO_OUTPUT_LAYER:-M2}"
export INNOVUS_IO_TOP_LAYER="${INNOVUS_IO_TOP_LAYER:-M3}"
export INNOVUS_CLOCK_PINS="${INNOVUS_CLOCK_PINS:-clk}"
export INNOVUS_IO_PIN_OFFSET="${INNOVUS_IO_PIN_OFFSET:-5.0}"
export ICC_BASE_MW_LIB="${ICC_BASE_MW_LIB:-}"
export ICC_REFERENCE_LIBS="${ICC_REFERENCE_LIBS:-}"
export ICC_TECH_FILE="${ICC_TECH_FILE:-}"
export ICC_CREATE_LIB_MODE="${ICC_CREATE_LIB_MODE:-auto}"
export ICC_OVERWRITE_LIB="${ICC_OVERWRITE_LIB:-1}"
export ICC_STREAM_FORMAT="${ICC_STREAM_FORMAT:-gds}"
export ICC_TLUPLUS_MAX="${ICC_TLUPLUS_MAX:-}"
export ICC_TLUPLUS_MIN="${ICC_TLUPLUS_MIN:-}"
export ICC_TLUPLUS_MAP="${ICC_TLUPLUS_MAP:-}"
export ICC_ITF_FILE="${ICC_ITF_FILE:-}"
export ICC_TECH2ITF_MAP="${ICC_TECH2ITF_MAP:-}"
export ICC_QRC_TECH_FILE="${ICC_QRC_TECH_FILE:-}"
export VIRTUOSO_TECH_LIB="${VIRTUOSO_TECH_LIB:-}"
export VIRTUOSO_STREAM_MAP="${VIRTUOSO_STREAM_MAP:-}"
export GDS_STREAM_OUT_MAP="${GDS_STREAM_OUT_MAP:-}"
export POWER_NET="${POWER_NET:-VDD}"
export GROUND_NET="${GROUND_NET:-VSS}"
export PLACE_SITE="${PLACE_SITE:-}"
export FLOORPLAN_ASPECT_RATIO="${FLOORPLAN_ASPECT_RATIO:-1.0}"
export CORE_UTILIZATION="${CORE_UTILIZATION:-0.55}"
export CORE_MARGIN_LEFT="${CORE_MARGIN_LEFT:-8}"
export CORE_MARGIN_BOTTOM="${CORE_MARGIN_BOTTOM:-8}"
export CORE_MARGIN_RIGHT="${CORE_MARGIN_RIGHT:-8}"
export CORE_MARGIN_TOP="${CORE_MARGIN_TOP:-8}"
export RING_LAYER_H="${RING_LAYER_H:-}"
export RING_LAYER_V="${RING_LAYER_V:-}"
export RING_WIDTH="${RING_WIDTH:-}"
export RING_SPACING="${RING_SPACING:-}"
export RING_OFFSET="${RING_OFFSET:-}"
export ADD_POWER_STRIPES="${ADD_POWER_STRIPES:-0}"
export STRIPE_LAYER="${STRIPE_LAYER:-}"
export STRIPE_WIDTH="${STRIPE_WIDTH:-}"
export STRIPE_SPACING="${STRIPE_SPACING:-}"
export STRIPE_SET_TO_SET_DISTANCE="${STRIPE_SET_TO_SET_DISTANCE:-}"
export CTS_BUFFER_LIST="${CTS_BUFFER_LIST:-}"
export FM_IMPLEMENTATION_MODE="${FM_IMPLEMENTATION_MODE:-dc}"
export FM_FLAVOR="$(normalize_flavor "${FM_FLAVOR:-default}")"
export POSTSIM_NETLIST_MODE="${POSTSIM_NETLIST_MODE:-dc}"
export POSTSIM_FLAVOR="$(normalize_flavor "${POSTSIM_FLAVOR:-default}")"
export POSTSIM_SDF_MODE="${POSTSIM_SDF_MODE:-dc}"
export INNOVUS_NETLIST_MODE="${INNOVUS_NETLIST_MODE:-dc}"
export INNOVUS_INPUT_FLAVOR="$(normalize_flavor "${INNOVUS_INPUT_FLAVOR:-default}")"
export DC_OUTPUT_FLAVOR="$(normalize_flavor "${DC_OUTPUT_FLAVOR:-default}")"
export DC_COMPILE_PROFILE="${DC_COMPILE_PROFILE:-${DIP_COMPILE_PROFILE:-}}"
export CALIBRE_SOURCE_FLAVOR="$(normalize_flavor "${CALIBRE_SOURCE_FLAVOR:-default}")"
export CUSTOM_NETLIST="${CUSTOM_NETLIST:-}"
export CUSTOM_SDF="${CUSTOM_SDF:-}"

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
export ICC_RESULTS_DIR="${RESULTS_DIR}/icc"
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
    "$ICC_WORK_DIR" "$ICC_LIB_DIR" "$ICC_REPORT_DIR" "$ICC_RESULTS_DIR" \
    "$FM_WORK_DIR" "$FM_REPORT_DIR" \
    "$CALIBRE_WORK_DIR" "$CALIBRE_REPORT_DIR" \
    "$VIRTUOSO_WORK_DIR"

default_dc_basename="$(dc_basename_for_flavor default)"
plain_dc_basename="$(dc_basename_for_flavor plain)"
gated_dc_basename="$(dc_basename_for_flavor gated)"
selected_dc_basename="$(dc_basename_for_flavor "${DC_OUTPUT_FLAVOR}")"

export DEFAULT_DC_NETLIST="${RESULTS_DIR}/${default_dc_basename}.v"
export DEFAULT_DC_SDF="${RESULTS_DIR}/${default_dc_basename}.sdf"
export DEFAULT_DC_DDC="${RESULTS_DIR}/${default_dc_basename}.ddc"
export DEFAULT_DC_SVF="${RESULTS_DIR}/${default_dc_basename}.svf"
export DEFAULT_DC_EXPORTED_SDC="${RESULTS_DIR}/${default_dc_basename}.sdc"

export PLAIN_DC_NETLIST="${RESULTS_DIR}/${plain_dc_basename}.v"
export PLAIN_DC_SDF="${RESULTS_DIR}/${plain_dc_basename}.sdf"
export PLAIN_DC_DDC="${RESULTS_DIR}/${plain_dc_basename}.ddc"
export PLAIN_DC_SVF="${RESULTS_DIR}/${plain_dc_basename}.svf"
export PLAIN_DC_EXPORTED_SDC="${RESULTS_DIR}/${plain_dc_basename}.sdc"

export GATED_DC_NETLIST="${RESULTS_DIR}/${gated_dc_basename}.v"
export GATED_DC_SDF="${RESULTS_DIR}/${gated_dc_basename}.sdf"
export GATED_DC_DDC="${RESULTS_DIR}/${gated_dc_basename}.ddc"
export GATED_DC_SVF="${RESULTS_DIR}/${gated_dc_basename}.svf"
export GATED_DC_EXPORTED_SDC="${RESULTS_DIR}/${gated_dc_basename}.sdc"

export DC_NETLIST="${RESULTS_DIR}/${selected_dc_basename}.v"
export DC_SDF="${RESULTS_DIR}/${selected_dc_basename}.sdf"
export DC_DDC="${RESULTS_DIR}/${selected_dc_basename}.ddc"
export DC_SVF="${RESULTS_DIR}/${selected_dc_basename}.svf"
export DC_EXPORTED_SDC="${RESULTS_DIR}/${selected_dc_basename}.sdc"
export DC_AREA_RPT="${REPORTS_DIR}/${selected_dc_basename}_area.rpt"
export DC_POWER_RPT="${REPORTS_DIR}/${selected_dc_basename}_power.rpt"
export DC_TIMING_RPT="${REPORTS_DIR}/${selected_dc_basename}_timing.rpt"
export DC_QOR_RPT="${REPORTS_DIR}/${selected_dc_basename}_qor.rpt"
export DC_CHECK_RPT="${REPORTS_DIR}/${selected_dc_basename}_check_design.rpt"
export DC_VIOLATORS_RPT="${REPORTS_DIR}/${selected_dc_basename}_violators.rpt"
export DC_GATING_RPT="${REPORTS_DIR}/${selected_dc_basename}_gating_check.rpt"
export DC_LOG_FILE="${LOGS_DIR}/${selected_dc_basename}.log"

export INNOVUS_INPUT_NETLIST="${INNOVUS_INPUT_NETLIST:-$DC_NETLIST}"
export INNOVUS_NETLIST="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}_innovus.v"
export INNOVUS_LVS_NETLIST="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}_innovus_lvs.v"
export INNOVUS_SDF="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}_innovus.sdf"
export INNOVUS_DEF="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}.def"
export INNOVUS_GDS="${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}.gds"
export INNOVUS_GDS_UNPATCHED="${INNOVUS_GDS_UNPATCHED:-${INNOVUS_RESULTS_DIR}/${DESIGN_NAME}.pre_via_metal_patch.gds}"
export INNOVUS_GDS_PATCH_MANIFEST="${INNOVUS_GDS_PATCH_MANIFEST:-${INNOVUS_WORK_DIR}/${DESIGN_NAME}_gds_patch.env}"
export CALIBRE_LVS_USE_UNPATCHED_GDS="${CALIBRE_LVS_USE_UNPATCHED_GDS:-1}"
USER_CALIBRE_LVS_GDS="${CALIBRE_LVS_GDS:-}"
if [[ -f "${INNOVUS_GDS_PATCH_MANIFEST}" ]]; then
    # shellcheck disable=SC1090
    source "${INNOVUS_GDS_PATCH_MANIFEST}"
fi
if [[ -n "$USER_CALIBRE_LVS_GDS" ]]; then
    export CALIBRE_LVS_GDS="$USER_CALIBRE_LVS_GDS"
elif [[ "${CALIBRE_LVS_USE_UNPATCHED_GDS:-0}" != "1" ]]; then
    unset CALIBRE_LVS_GDS
fi
export INNOVUS_MMMC_FILE="${INNOVUS_WORK_DIR}/${DESIGN_NAME}_view_definition.tcl"
export INNOVUS_CHECKPOINT_PREFIX="${INNOVUS_WORK_DIR}/${DESIGN_NAME}"
export INNOVUS_TIMING_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_timing.rpt"
export INNOVUS_POWER_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_power.rpt"
export INNOVUS_AREA_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_area.rpt"
export INNOVUS_QOR_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_qor.rpt"
export INNOVUS_PIN_ASSIGN_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_pin_assignment.rpt"
export INNOVUS_CONNECTIVITY_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_connectivity.rpt"
export INNOVUS_DRC_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_drc.rpt"
export INNOVUS_ROUTE_RPT="${INNOVUS_REPORT_DIR}/${DESIGN_NAME}_route.rpt"
export INNOVUS_LOG_FILE="${LOGS_DIR}/${DESIGN_NAME}_innovus.log"
export ICC2_INPUT_NETLIST="${ICC2_INPUT_NETLIST:-${INNOVUS_INPUT_NETLIST}}"
export ICC2_DESIGN_LIB="${ICC2_DESIGN_LIB:-${ICC2_LIB_DIR}/${DESIGN_NAME}.dlib}"
export ICC2_GDS="${ICC2_GDS:-${INNOVUS_GDS}}"
export ICC2_NETLIST="${ICC2_NETLIST:-${INNOVUS_NETLIST}}"
export ICC2_SDF="${ICC2_SDF:-${INNOVUS_SDF}}"
export ICC2_DEF="${ICC2_DEF:-${INNOVUS_DEF}}"
export ICC2_LOG_FILE="${ICC2_LOG_FILE:-${INNOVUS_LOG_FILE}}"
export ICC_INPUT_NETLIST="${ICC_INPUT_NETLIST:-${INNOVUS_INPUT_NETLIST}}"
export ICC_DESIGN_LIB="${ICC_DESIGN_LIB:-${ICC_LIB_DIR}/${DESIGN_NAME}.mwlib}"
export ICC_NETLIST="${ICC_RESULTS_DIR}/${DESIGN_NAME}_icc.v"
export ICC_SDF="${ICC_RESULTS_DIR}/${DESIGN_NAME}_icc.sdf"
export ICC_DEF="${ICC_RESULTS_DIR}/${DESIGN_NAME}_icc.def"
export ICC_GDS="${ICC_RESULTS_DIR}/${DESIGN_NAME}.gds"
export ICC_TIMING_RPT="${ICC_REPORT_DIR}/${DESIGN_NAME}_timing.rpt"
export ICC_POWER_RPT="${ICC_REPORT_DIR}/${DESIGN_NAME}_power.rpt"
export ICC_AREA_RPT="${ICC_REPORT_DIR}/${DESIGN_NAME}_area.rpt"
export ICC_QOR_RPT="${ICC_REPORT_DIR}/${DESIGN_NAME}_qor.rpt"

export FRONTSIM_SIMV="${FRONTSIM_WORK_DIR}/${DESIGN_NAME}_rtl.simv"
export FRONTSIM_COMPILE_LOG="${FRONTSIM_LOG_DIR}/${DESIGN_NAME}_rtl_compile.log"
export FRONTSIM_RUN_LOG="${FRONTSIM_LOG_DIR}/${DESIGN_NAME}_rtl_run.log"
export FRONTSIM_VECTOR_INPUT="${FRONTSIM_INPUT:-${REPO_ROOT}/test_vectors/txt/signed_mix_input.txt}"
export FRONTSIM_VECTOR_EXPECTED="${FRONTSIM_EXPECTED:-${REPO_ROOT}/test_vectors/txt/signed_mix_expected.txt}"
export FRONTSIM_CASE="${FRONTSIM_CASE:-${CASE:-}}"
export FRONTSIM_VCD_PATH="${FRONTSIM_VCD_PATH:-}"

export POSTSIM_NETLIST="$(choose_netlist "${POSTSIM_NETLIST_MODE:-dc}" "${POSTSIM_FLAVOR}")"
export POSTSIM_SDF="$(choose_sdf "${POSTSIM_SDF_MODE:-dc}" "${POSTSIM_FLAVOR}")"
export POSTSIM_SIMV="${POSTSIM_WORK_DIR}/${DESIGN_NAME}_gate.simv"
export POSTSIM_COMPILE_LOG="${POSTSIM_LOG_DIR}/${DESIGN_NAME}_compile.log"
export POSTSIM_RUN_LOG="${POSTSIM_LOG_DIR}/${DESIGN_NAME}_run.log"
export POSTSIM_VECTOR_DIR="${POSTSIM_VECTOR_DIR:-${REPO_ROOT}/test_vectors/txt}"
export POSTSIM_STAGES="${POSTSIM_STAGES:-none dc innovus}"
export POSTSIM_DISABLE_TIMING_CHECKS="${POSTSIM_DISABLE_TIMING_CHECKS:-0}"
export POSTSIM_DIP_STREAM_CAPTURE="${POSTSIM_DIP_STREAM_CAPTURE:-0}"
export POSTSIM_NEG_TCHK="${POSTSIM_NEG_TCHK:-1}"
export POSTSIM_FORCE_CLOCK_GATES_OPEN="${POSTSIM_FORCE_CLOCK_GATES_OPEN:-0}"
export POSTSIM_VECTOR_INPUT="${POSTSIM_INPUT:-${REPO_ROOT}/test_vectors/txt/signed_mix_input.txt}"
export POSTSIM_VECTOR_EXPECTED="${POSTSIM_EXPECTED:-${REPO_ROOT}/test_vectors/txt/signed_mix_expected.txt}"
export POSTSIM_CASE="${POSTSIM_CASE:-${CASE:-}}"
export POSTSIM_VCD_PATH="${POSTSIM_VCD_PATH:-}"

export FM_IMPL_NETLIST="$(choose_netlist "${FM_IMPLEMENTATION_MODE:-dc}" "${FM_FLAVOR}")"
export FM_SVF="${FM_SVF:-$(choose_svf "${FM_IMPLEMENTATION_MODE:-dc}" "${FM_FLAVOR}")}"
fm_report_tag="${DESIGN_NAME}_fm_${FM_IMPLEMENTATION_MODE}_${FM_FLAVOR}"
export FM_LOG_FILE="${LOGS_DIR}/${fm_report_tag}.log"
export FM_SUMMARY_RPT="${FM_REPORT_DIR}/${fm_report_tag}_summary.rpt"

export INNOVUS_INPUT_NETLIST="$(choose_netlist "${INNOVUS_NETLIST_MODE:-dc}" "${INNOVUS_INPUT_FLAVOR}")"
export ICC2_INPUT_NETLIST="$(choose_netlist "${ICC2_NETLIST_MODE:-${INNOVUS_NETLIST_MODE:-dc}}" "${INNOVUS_INPUT_FLAVOR}")"
export ICC_INPUT_NETLIST="$(choose_netlist "${ICC_NETLIST_MODE:-${INNOVUS_NETLIST_MODE:-dc}}" "${INNOVUS_INPUT_FLAVOR}")"
export ICC_LOG_FILE="${LOGS_DIR}/${DESIGN_NAME}_icc.log"

export CALIBRE_GDS="$(choose_calibre_gds "${CALIBRE_LAYOUT_MODE:-innovus}")"
export CALIBRE_SOURCE_NETLIST="$(choose_calibre_source "${CALIBRE_SOURCE_MODE:-innovus}" "${CALIBRE_SOURCE_FLAVOR}")"
export CALIBRE_LVS_USE_UNPATCHED_GDS="${CALIBRE_LVS_USE_UNPATCHED_GDS:-1}"
if [[ -z "${CALIBRE_LVS_GDS:-}" ]]; then
    case "${CALIBRE_LAYOUT_MODE:-innovus}" in
        innovus|icc2)
            if [[ "$CALIBRE_LVS_USE_UNPATCHED_GDS" == "1" && -n "${INNOVUS_LAST_UNPATCHED_GDS:-}" && -f "${INNOVUS_LAST_UNPATCHED_GDS}" ]]; then
                export CALIBRE_LVS_GDS="${INNOVUS_LAST_UNPATCHED_GDS}"
            elif [[ "$CALIBRE_LVS_USE_UNPATCHED_GDS" == "1" && -f "${INNOVUS_GDS_UNPATCHED}" ]]; then
                export CALIBRE_LVS_GDS="${INNOVUS_GDS_UNPATCHED}"
            else
                export CALIBRE_LVS_GDS="${CALIBRE_GDS}"
            fi
            ;;
        *)
            export CALIBRE_LVS_GDS="${CALIBRE_GDS}"
            ;;
    esac
else
    export CALIBRE_LVS_GDS="$(resolve_path "${CALIBRE_LVS_GDS}")"
fi
export CALIBRE_DRC_DECK="${CALIBRE_DRC_DECK:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_drc.rule}"
export CALIBRE_LVS_DECK="${CALIBRE_LVS_DECK:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_lvs.rule}"
export CALIBRE_DRC_RPT="${CALIBRE_DRC_RPT:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_drc.rep}"
export CALIBRE_LVS_RPT="${CALIBRE_LVS_RPT:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_lvs.rep}"
export CALIBRE_DRC_RESULTS_DB="${CALIBRE_DRC_RESULTS_DB:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_drc.results}"
export CALIBRE_LVS_RESULTS_DB="${CALIBRE_LVS_RESULTS_DB:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_lvs_drc.results}"
export CALIBRE_LVS_SOURCE_CDL="${CALIBRE_LVS_SOURCE_CDL:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_source.cdl}"
export CALIBRE_LVS_UNIQUE_CASE_NETS="${CALIBRE_LVS_UNIQUE_CASE_NETS:-0}"
export CALIBRE_LVS_NORMALIZED_VERILOG="${CALIBRE_LVS_NORMALIZED_VERILOG:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_lvs_case_normalized.v}"
export CALIBRE_LVS_CASE_REPORT="${CALIBRE_LVS_CASE_REPORT:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_lvs_case_normalized.rpt}"
export CALIBRE_LVS_TEXT_MODE="${CALIBRE_LVS_TEXT_MODE:-gds}"
export CALIBRE_LVS_PORT_DEF="${CALIBRE_LVS_PORT_DEF:-${INNOVUS_DEF}}"
export CALIBRE_LVS_PORT_TEXT="${CALIBRE_LVS_PORT_TEXT:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_lvs_ports.svrf}"
export CALIBRE_LVS_STD_LIB="${CALIBRE_LVS_STD_LIB:-0}"
export CALIBRE_LVS_IGNORE_CELLS="${CALIBRE_LVS_IGNORE_CELLS:-}"
export CALIBRE_LVS_DROP_TOP_POWER_PORTS="${CALIBRE_LVS_DROP_TOP_POWER_PORTS:-0}"
export CALIBRE_LVS_GLOBALS_ARE_PORTS="${CALIBRE_LVS_GLOBALS_ARE_PORTS:-}"
export CALIBRE_DRC_PROFILE="${CALIBRE_DRC_PROFILE:-foundry}"

export VIRTUOSO_LAYOUT_GDS="${VIRTUOSO_LAYOUT_GDS:-$INNOVUS_GDS}"
export VIRTUOSO_LAYOUT_LIB="${VIRTUOSO_LAYOUT_LIB:-${DESIGN_NICKNAME}_layout}"
export VIRTUOSO_TECH_LIB="${VIRTUOSO_TECH_LIB:-}"
