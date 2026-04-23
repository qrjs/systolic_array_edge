#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

ICC_BIN="${ICC_SHELL_EXEC:-$(command -v icc_shell || true)}"
[[ -n "${ICC_BIN}" && -x "${ICC_BIN}" ]] || die "icc_shell not found; set ICC_SHELL_EXEC or add icc_shell to PATH"

probe_lib="${ICC_LIB_DIR}/${DESIGN_NAME}_probe.mwlib"
probe_log="${LOGS_DIR}/${DESIGN_NAME}_icc_probe.log"

export ICC_PROBE_LIB="$probe_lib"
export ICC_PROBE_TECH_FILE="${ICC_TECH_FILE:-$ICC2_TECH_FILE}"
export ICC_PROBE_REF_LIBS="${ICC_REFERENCE_LIBS:-$ICC2_REFERENCE_LIBS}"

echo "[dip-flow][INFO] Running ICC library probe"
echo "[dip-flow][INFO]   ICC_BIN  = ${ICC_BIN}"
echo "[dip-flow][INFO]   TECH_FILE = ${ICC_PROBE_TECH_FILE}"
echo "[dip-flow][INFO]   REF_LIBS  = ${ICC_PROBE_REF_LIBS}"

if "$ICC_BIN" -f "${SCRIPT_DIR}/run_icc_probe.tcl" | tee "$probe_log"; then
    echo "[dip-flow][PASS] ICC probe succeeded"
    echo "[dip-flow][PASS] Probe log: ${probe_log}"
else
    echo "[dip-flow][ERROR] ICC probe failed. Current library format is not compatible with the ICC flow yet." >&2
    echo "[dip-flow][ERROR] Probe log: ${probe_log}" >&2
    exit 1
fi
