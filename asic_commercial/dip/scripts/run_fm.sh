#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

FM_BIN="${FM_BIN:-fm_shell}"
require_tool "$FM_BIN"

export DESIGN_NAME REPO_ROOT FILELIST RTL_WRAPPER FM_IMPL_NETLIST FM_SUMMARY_RPT TARGET_LIBRARY LINK_LIBRARY FM_SVF
"$FM_BIN" -f "${SCRIPT_DIR}/run_fm.tcl" | tee "$FM_LOG_FILE"
