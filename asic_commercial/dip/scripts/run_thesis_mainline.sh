#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
FLOW_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
REPO_ROOT=$(cd "${FLOW_ROOT}/../.." && pwd)

# shellcheck disable=SC1091
source "${REPO_ROOT}/asic_commercial/scripts/source_eda_env.sh"

[[ -n "${SMIC40_PDK_ROOT:-}" ]] || {
    echo "[thesis-dip][ERROR] SMIC40_PDK_ROOT is not set" >&2
    exit 1
}

THESIS_VECTOR_DIR="${THESIS_VECTOR_DIR:-${REPO_ROOT}/test_vectors/txt}"
THESIS_POSTSIM_DC_DIR="${THESIS_POSTSIM_DC_DIR:-${FLOW_ROOT}/postsim/thesis_dc}"
THESIS_POSTSIM_ICC2_DIR="${THESIS_POSTSIM_ICC2_DIR:-${FLOW_ROOT}/postsim/thesis_icc2}"

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${FLOW_ROOT}/config/design.std.env"
export LIBS_ENV="${FLOW_ROOT}/config/libs.env"
export DIP_COMPILE_PROFILE="${DIP_COMPILE_PROFILE:-gated_default}"

"${REPO_ROOT}/asic_commercial/scripts/check_thesis_env.sh"

"${SCRIPT_DIR}/run_dc.sh"
python3 "${REPO_ROOT}/utils/run_gate_power_compare.py" \
    --arch dip \
    --vector-dir "${THESIS_VECTOR_DIR}" \
    --output-dir "${THESIS_POSTSIM_DC_DIR}" \
    --sdf-mode dc
"${SCRIPT_DIR}/run_icc2_probe.sh"
"${SCRIPT_DIR}/run_icc2.sh" all
POSTSIM_NETLIST_MODE=icc2 POSTSIM_SDF_MODE=icc2 \
python3 "${REPO_ROOT}/utils/run_gate_power_compare.py" \
    --arch dip \
    --vector-dir "${THESIS_VECTOR_DIR}" \
    --output-dir "${THESIS_POSTSIM_ICC2_DIR}" \
    --sdf-mode icc2

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

cat <<EOF
[thesis-dip][PASS] DiP thesis mainline completed
[thesis-dip][INFO] DC netlist  : ${DC_NETLIST}
[thesis-dip][INFO] DC sdf      : ${DC_SDF}
[thesis-dip][INFO] ICC2 netlist: ${ICC2_NETLIST}
[thesis-dip][INFO] ICC2 sdf    : ${ICC2_SDF}
[thesis-dip][INFO] ICC2 def    : ${ICC2_DEF}
[thesis-dip][INFO] ICC2 gds    : ${ICC2_GDS}
[thesis-dip][INFO] DC suite    : ${THESIS_POSTSIM_DC_DIR}/summary.md
[thesis-dip][INFO] ICC2 suite  : ${THESIS_POSTSIM_ICC2_DIR}/summary.md
[thesis-dip][INFO] Next step   : make thesis-icc2-gui
EOF
