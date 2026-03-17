#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
FLOW_ROOT=${FLOW_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}
RUNSET_ROOT=${RUNSET_ROOT:-${FLOW_ROOT}}
DIP_ROOT="${FLOW_ROOT}"
PROJECT_ROOT=$(cd "${FLOW_ROOT}/../.." && pwd)

source "${FLOW_ROOT}/config/design.env"

if [[ -f "${FLOW_ROOT}/config/libs.env" ]]; then
    source "${FLOW_ROOT}/config/libs.env"
fi

required_design_vars=(
    DESIGN_NAME
    DESIGN_NICKNAME
    CLOCK_PORT
    RESET_PORT
    CLOCK_PERIOD_NS
    RTL_WRAPPER_REL
    FILELIST_REL
    SDC_REL
    OPEN_SOURCE_NETLIST_REL
    POSTSIM_MODE
    POSTSIM_TB_FILE_REL
    POSTSIM_TB_TOP
    POSTSIM_PASS_MARKER
)

for var_name in "${required_design_vars[@]}"; do
    if [[ -z "${!var_name:-}" ]]; then
        echo "error: ${var_name} is not set in config/design.env" >&2
        exit 1
    fi
done

export PROJECT_ROOT
export FLOW_ROOT
export RUNSET_ROOT
export DIP_ROOT
export DESIGN_NAME
export DESIGN_NICKNAME
export FLOW_NAME
export CLOCK_PORT
export RESET_PORT
export CLOCK_PERIOD_NS
export POSTSIM_MODE
export POSTSIM_TB_TOP
export POSTSIM_PASS_MARKER

export RTL_WRAPPER="${PROJECT_ROOT}/${RTL_WRAPPER_REL}"
export FILELIST="${PROJECT_ROOT}/${FILELIST_REL}"
export SDC_FILE="${PROJECT_ROOT}/${SDC_REL}"
export OPEN_SOURCE_NETLIST="${PROJECT_ROOT}/${OPEN_SOURCE_NETLIST_REL}"
export POSTSIM_TB_FILE="${FLOW_ROOT}/${POSTSIM_TB_FILE_REL}"

export LOG_DIR="${FLOW_ROOT}/logs"
export REPORT_DIR="${FLOW_ROOT}/reports"
export RESULT_DIR="${FLOW_ROOT}/results"
export DC_WORK_DIR="${FLOW_ROOT}/dc/work"
export SYNTH_DDC="${RESULT_DIR}/${DESIGN_NAME}_dc.ddc"
export SYNTH_NETLIST="${RESULT_DIR}/${DESIGN_NAME}_dc.v"
export SYNTH_SDC="${RESULT_DIR}/${DESIGN_NAME}_dc.sdc"
export SYNTH_SDF="${RESULT_DIR}/${DESIGN_NAME}_dc.sdf"
export SYNTH_SVF="${RESULT_DIR}/${DESIGN_NAME}_dc.svf"
export POSTSIM_ROOT="${FLOW_ROOT}/postsim"
export POSTSIM_LOG_DIR="${POSTSIM_ROOT}/logs"
export POSTSIM_WORK_DIR="${POSTSIM_ROOT}/work"
export FM_ROOT="${FLOW_ROOT}/fm"
export FM_REPORT_DIR="${REPORT_DIR}/fm"
export FM_RESULT_DIR="${RESULT_DIR}/fm"
export ICC2_ROOT="${FLOW_ROOT}/icc2"
export ICC2_WORK_DIR="${ICC2_ROOT}/work"
export ICC2_REPORT_DIR="${REPORT_DIR}/icc2"
export ICC2_RESULT_DIR="${RESULT_DIR}/icc2"
export ICC2_RUNSET="${RUNSET_ROOT}/icc2/run_icc2.tcl"
export ICC2_DESIGN_LIB="${ICC2_WORK_DIR}/${DESIGN_NAME}.dlib"
export ICC2_FINAL_NETLIST="${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.v"
export ICC2_FINAL_DEF="${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.def"
export ICC2_FINAL_SDF="${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.sdf"
export ICC2_FINAL_SPEF="${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.spef"
export ICC2_FINAL_GDS="${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.gds"
export CALIBRE_ROOT="${FLOW_ROOT}/calibre"
export CALIBRE_RUN_DIR="${CALIBRE_ROOT}/run"

custom_netlist="${CUSTOM_NETLIST:-}"
if [[ -n "${custom_netlist}" && "${custom_netlist}" != /* ]]; then
    custom_netlist="${PROJECT_ROOT}/${custom_netlist}"
fi
export CUSTOM_NETLIST="${custom_netlist}"

postsim_netlist_mode="${POSTSIM_NETLIST_MODE:-dc}"
case "${postsim_netlist_mode}" in
    dc)
        export POSTSIM_NETLIST="${SYNTH_NETLIST}"
        ;;
    custom)
        export POSTSIM_NETLIST="${CUSTOM_NETLIST}"
        ;;
    *)
        echo "error: unsupported POSTSIM_NETLIST_MODE=${postsim_netlist_mode}" >&2
        echo "hint: use dc or custom" >&2
        exit 1
        ;;
esac

postsim_sdf_mode="${POSTSIM_SDF_MODE:-dc}"
case "${postsim_sdf_mode}" in
    dc)
        export POSTSIM_SDF="${SYNTH_SDF}"
        ;;
    icc2)
        export POSTSIM_SDF="${ICC2_RESULT_DIR}/${DESIGN_NAME}_icc2.sdf"
        ;;
    none)
        export POSTSIM_SDF=""
        ;;
    custom)
        custom_sdf="${CUSTOM_SDF:-}"
        if [[ -n "${custom_sdf}" && "${custom_sdf}" != /* ]]; then
            custom_sdf="${PROJECT_ROOT}/${custom_sdf}"
        fi
        export POSTSIM_SDF="${custom_sdf}"
        ;;
    *)
        echo "error: unsupported POSTSIM_SDF_MODE=${postsim_sdf_mode}" >&2
        echo "hint: use dc, icc2, none, or custom" >&2
        exit 1
        ;;
esac

icc2_netlist_mode="${ICC2_NETLIST_MODE:-dc}"
case "${icc2_netlist_mode}" in
    dc)
        export ICC2_NETLIST="${SYNTH_NETLIST}"
        ;;
    custom)
        export ICC2_NETLIST="${CUSTOM_NETLIST}"
        ;;
    *)
        echo "error: unsupported ICC2_NETLIST_MODE=${icc2_netlist_mode}" >&2
        echo "hint: use dc or custom" >&2
        exit 1
        ;;
esac

gds_map_file="${GDS_STREAM_OUT_MAP:-}"
if [[ -n "${gds_map_file}" && "${gds_map_file}" != /* ]]; then
    gds_map_file="${PROJECT_ROOT}/${gds_map_file}"
fi
export GDS_STREAM_OUT_MAP="${gds_map_file}"
export POSTSIM_NETLIST_MODE="${postsim_netlist_mode}"
export POSTSIM_SDF_MODE="${postsim_sdf_mode}"
export ICC2_NETLIST_MODE="${icc2_netlist_mode}"

fm_mode="${FM_IMPLEMENTATION_MODE:-dc}"
case "${fm_mode}" in
    dc)
        export FM_IMPLEMENTATION_NETLIST="${SYNTH_NETLIST}"
        ;;
    icc2)
        export FM_IMPLEMENTATION_NETLIST="${ICC2_FINAL_NETLIST}"
        ;;
    custom)
        export FM_IMPLEMENTATION_NETLIST="${CUSTOM_NETLIST}"
        ;;
    *)
        echo "error: unsupported FM_IMPLEMENTATION_MODE=${fm_mode}" >&2
        echo "hint: use dc, icc2, or custom" >&2
        exit 1
        ;;
esac
export FM_IMPLEMENTATION_MODE="${fm_mode}"

calibre_custom_gds="${CALIBRE_CUSTOM_GDS:-}"
if [[ -n "${calibre_custom_gds}" && "${calibre_custom_gds}" != /* ]]; then
    calibre_custom_gds="${PROJECT_ROOT}/${calibre_custom_gds}"
fi
export CALIBRE_CUSTOM_GDS="${calibre_custom_gds}"

calibre_custom_netlist="${CALIBRE_CUSTOM_SOURCE_NETLIST:-}"
if [[ -n "${calibre_custom_netlist}" && "${calibre_custom_netlist}" != /* ]]; then
    calibre_custom_netlist="${PROJECT_ROOT}/${calibre_custom_netlist}"
fi
export CALIBRE_CUSTOM_SOURCE_NETLIST="${calibre_custom_netlist}"

calibre_layout_mode="${CALIBRE_LAYOUT_MODE:-icc2}"
case "${calibre_layout_mode}" in
    icc2)
        export CALIBRE_LAYOUT_GDS="${ICC2_FINAL_GDS}"
        ;;
    custom)
        export CALIBRE_LAYOUT_GDS="${CALIBRE_CUSTOM_GDS}"
        ;;
    *)
        echo "error: unsupported CALIBRE_LAYOUT_MODE=${calibre_layout_mode}" >&2
        echo "hint: use icc2 or custom" >&2
        exit 1
        ;;
esac
export CALIBRE_LAYOUT_MODE="${calibre_layout_mode}"

calibre_source_mode="${CALIBRE_SOURCE_MODE:-icc2}"
case "${calibre_source_mode}" in
    icc2)
        export CALIBRE_SOURCE_NETLIST="${ICC2_FINAL_NETLIST}"
        ;;
    custom)
        export CALIBRE_SOURCE_NETLIST="${CALIBRE_CUSTOM_SOURCE_NETLIST}"
        ;;
    *)
        echo "error: unsupported CALIBRE_SOURCE_MODE=${calibre_source_mode}" >&2
        echo "hint: use icc2 or custom" >&2
        exit 1
        ;;
esac
export CALIBRE_SOURCE_MODE="${calibre_source_mode}"

mkdir -p \
    "${LOG_DIR}" \
    "${REPORT_DIR}" \
    "${RESULT_DIR}" \
    "${DC_WORK_DIR}" \
    "${POSTSIM_LOG_DIR}" \
    "${POSTSIM_WORK_DIR}" \
    "${FM_REPORT_DIR}" \
    "${FM_RESULT_DIR}" \
    "${ICC2_WORK_DIR}" \
    "${ICC2_REPORT_DIR}" \
    "${ICC2_RESULT_DIR}" \
    "${CALIBRE_RUN_DIR}"

echo "PROJECT_ROOT=${PROJECT_ROOT}"
echo "FLOW_ROOT=${FLOW_ROOT}"
echo "DESIGN_NAME=${DESIGN_NAME}"
echo "FILELIST=${FILELIST}"
echo "SDC_FILE=${SDC_FILE}"
echo "RESULT_DIR=${RESULT_DIR}"
echo "POSTSIM_NETLIST=${POSTSIM_NETLIST}"
echo "FM_IMPLEMENTATION_NETLIST=${FM_IMPLEMENTATION_NETLIST}"
echo "ICC2_NETLIST=${ICC2_NETLIST}"
