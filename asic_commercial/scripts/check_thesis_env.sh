#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/../.." && pwd)
FLOW_ROOT="${REPO_ROOT}/asic_commercial/dip"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/source_eda_env.sh"

die() {
    echo "[thesis-check][ERROR] $*" >&2
    exit 1
}

require_tool() {
    local tool="$1"
    command -v "$tool" >/dev/null 2>&1 || die "required tool not found in PATH: $tool"
}

check_icc_shell() {
    if command -v icc_shell >/dev/null 2>&1; then
        return 0
    fi
    [[ -n "${ICC_SHELL_EXEC:-}" && -x "${ICC_SHELL_EXEC}" ]] || \
        die "icc_shell not found in PATH and ICC_SHELL_EXEC is not executable"
}

check_path() {
    local label="$1"
    local path="$2"
    if [[ -z "$path" || ! -e "$path" ]]; then
        die "${label} missing: ${path:-<empty>}"
    fi
    echo "[thesis-check][OK]   ${label}: $path"
}

[[ -n "${SMIC40_PDK_ROOT:-}" ]] || die "SMIC40_PDK_ROOT is not set"
[[ -d "${SMIC40_PDK_ROOT}" ]] || die "SMIC40_PDK_ROOT is not a directory: ${SMIC40_PDK_ROOT}"

require_tool dc_shell
check_icc_shell
require_tool icc2_shell
require_tool vcs

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${FLOW_ROOT}/config/design.std.env"
export LIBS_ENV="${FLOW_ROOT}/config/libs.env"
export DIP_COMPILE_PROFILE="${DIP_COMPILE_PROFILE:-gated_default}"

# shellcheck disable=SC1091
source "${FLOW_ROOT}/scripts/prepare_env.sh"

"${FLOW_ROOT}/scripts/check_handoff.sh"
"${FLOW_ROOT}/scripts/check_backend_inputs.sh" dc

check_path "SIM_LIBRARY_VERILOG" "${SIM_LIBRARY_VERILOG}"
check_path "ICC2_TECH_FILE" "${ICC2_TECH_FILE}"
check_path "ICC2_REFERENCE_LIBS" "${ICC2_REFERENCE_LIBS}"
check_path "GDS_STREAM_OUT_MAP" "${GDS_STREAM_OUT_MAP}"

echo "[thesis-check][INFO] DESIGN_NAME=${DESIGN_NAME}"
echo "[thesis-check][INFO] CLOCK_PERIOD_NS=${CLOCK_PERIOD_NS}"
echo "[thesis-check][INFO] TARGET_LIBRARY=${TARGET_LIBRARY}"
echo "[thesis-check][INFO] ICC2_TECH_FILE=${ICC2_TECH_FILE}"
echo "[thesis-check][INFO] ICC_SHELL_EXEC=${ICC_SHELL_EXEC:-<auto-not-found>}"
echo "[thesis-check][PASS] thesis environment looks ready"
