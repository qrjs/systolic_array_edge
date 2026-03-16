#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DIP_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
PROJECT_ROOT=$(cd "${DIP_ROOT}/../.." && pwd)

source "${DIP_ROOT}/config/design.env"

if [[ -f "${DIP_ROOT}/config/libs.env" ]]; then
    source "${DIP_ROOT}/config/libs.env"
fi

export PROJECT_ROOT
export DIP_ROOT
export DESIGN_NAME
export DESIGN_NICKNAME
export CLOCK_PORT
export RESET_PORT
export CLOCK_PERIOD_NS

export RTL_WRAPPER="${PROJECT_ROOT}/${RTL_WRAPPER_REL}"
export FILELIST="${PROJECT_ROOT}/${FILELIST_REL}"
export SDC_FILE="${PROJECT_ROOT}/${SDC_REL}"
export OPEN_SOURCE_NETLIST="${PROJECT_ROOT}/${OPEN_SOURCE_NETLIST_REL}"

export LOG_DIR="${DIP_ROOT}/logs"
export REPORT_DIR="${DIP_ROOT}/reports"
export RESULT_DIR="${DIP_ROOT}/results"

mkdir -p "${LOG_DIR}" "${REPORT_DIR}" "${RESULT_DIR}"

echo "PROJECT_ROOT=${PROJECT_ROOT}"
echo "DESIGN_NAME=${DESIGN_NAME}"
echo "FILELIST=${FILELIST}"
echo "SDC_FILE=${SDC_FILE}"
echo "RESULT_DIR=${RESULT_DIR}"
