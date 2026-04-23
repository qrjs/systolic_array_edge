#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

ICC2_BIN="${ICC2_BIN:-icc2_shell}"
require_tool "$ICC2_BIN"

probe_lib="${ICC2_LIB_DIR}/${DESIGN_NAME}_probe.dlib"
probe_log="${LOGS_DIR}/${DESIGN_NAME}_icc2_probe.log"

export ICC2_PROBE_LIB="$probe_lib"
export ICC2_PROBE_TECH_FILE="$ICC2_TECH_FILE"
export ICC2_PROBE_REF_LIBS="$ICC2_REFERENCE_LIBS"
export ICC2_CREATE_LIB_MODE="${ICC2_CREATE_LIB_MODE:-tech_and_ref}"

echo "[dip-flow][INFO] Running ICC2 library probe"
echo "[dip-flow][INFO]   TECH_FILE = ${ICC2_TECH_FILE}"
echo "[dip-flow][INFO]   REF_LIBS  = ${ICC2_REFERENCE_LIBS}"
echo "[dip-flow][INFO]   CREATE_LIB_MODE = ${ICC2_CREATE_LIB_MODE}"

if "$ICC2_BIN" -f "${SCRIPT_DIR}/run_icc2_probe.tcl" | tee "$probe_log"; then
    echo "[dip-flow][PASS] ICC2 probe succeeded"
    echo "[dip-flow][PASS] Probe log: ${probe_log}"
else
    echo "[dip-flow][ERROR] ICC2 probe failed. Current library format is not compatible with the existing ICC2 flow." >&2
    echo "[dip-flow][ERROR] Stop at DC/FM/postsim for now, or adapt the backend library import flow before rerunning ICC2." >&2
    echo "[dip-flow][ERROR] Probe log: ${probe_log}" >&2
    exit 1
fi
