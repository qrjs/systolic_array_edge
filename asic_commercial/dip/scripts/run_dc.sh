#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

DC_BIN="${DC_BIN:-dc_shell}"
require_tool "$DC_BIN"

case "${DC_OUTPUT_FLAVOR:-default}" in
    plain)
        export DIP_COMPILE_PROFILE="plain"
        ;;
    gated)
        export DIP_COMPILE_PROFILE="${DIP_GATED_COMPILE_PROFILE:-gated_default}"
        ;;
esac

export DESIGN_NAME FILELIST SDC_FILE REPO_ROOT DC_WORK_DIR
export TARGET_LIBRARY LINK_LIBRARY MAX_CORES DC_USE_ULTRA DIP_COMPILE_PROFILE
export DC_NETLIST DC_SDF DC_DDC DC_SVF DC_EXPORTED_SDC DC_GATING_RPT
export DC_AREA_RPT DC_POWER_RPT DC_TIMING_RPT DC_QOR_RPT DC_CHECK_RPT DC_VIOLATORS_RPT

"$DC_BIN" -f "${SCRIPT_DIR}/run_dc.tcl" | tee "$DC_LOG_FILE"
