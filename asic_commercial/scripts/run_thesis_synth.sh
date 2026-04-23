#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/source_eda_env.sh"

die() {
    echo "[thesis-synth][ERROR] $*" >&2
    exit 1
}

require_tool() {
    local tool="$1"
    command -v "$tool" >/dev/null 2>&1 || die "required tool not found in PATH: $tool"
}

[[ -n "${TSMC90_ROOT:-}" ]] || die "TSMC90_ROOT is not set"
[[ -d "${TSMC90_ROOT}" ]] || die "TSMC90_ROOT is not a directory: ${TSMC90_ROOT}"

require_tool dc_shell

export REPO_ROOT
# shellcheck disable=SC1091
source "${REPO_ROOT}/asic_commercial/dip/config/libs.tsmc90.env"

target_db_name="$(basename "${TARGET_LIBRARY}")"
target_db_dir="$(dirname "${TARGET_LIBRARY}")"

export DC_LIB_SEARCH_PATH="${target_db_dir}"
export DC_TARGET_LIBRARY="${target_db_name}"
export DC_LINK_LIBRARY="* ${target_db_name}"

echo "[thesis-synth][INFO] Running WS/IS/OS legacy FIFO baseline"
ARCH_IMPL_STYLE=legacy \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
RUN_TAG=thesis_legacy_fifo_base_5ns \
"${REPO_ROOT}/asic_commercial/syn/scripts/run_dc.sh" base ws is os

echo "[thesis-synth][INFO] Running DiP std + gated_default"
ARCH_IMPL_STYLE=std \
CONSTRAINT_MODE=uniform \
CLK_PERIOD=5.0 \
GATED_ARCH_LIST=dip \
DIP_COMPILE_PROFILE=gated_default \
RUN_TAG=thesis_dip_std_cg_compile_5ns \
"${REPO_ROOT}/asic_commercial/syn/scripts/run_dc.sh" mixed dip

echo "[thesis-synth][PASS] thesis synthesis runs completed"
