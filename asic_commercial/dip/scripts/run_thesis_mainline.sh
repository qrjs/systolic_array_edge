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
THESIS_POSTSIM_DIR="${THESIS_POSTSIM_DIR:-${FLOW_ROOT}/postsim/thesis}"

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${FLOW_ROOT}/config/design.std.env"
export LIBS_ENV="${FLOW_ROOT}/config/libs.env"
export DIP_COMPILE_PROFILE="${DIP_COMPILE_PROFILE:-gated_default}"

"${REPO_ROOT}/asic_commercial/scripts/check_thesis_env.sh"

"${SCRIPT_DIR}/run_dc.sh"
POSTSIM_VECTOR_DIR="${THESIS_VECTOR_DIR}" POSTSIM_SUITE_DIR="${THESIS_POSTSIM_DIR}" \
    "${SCRIPT_DIR}/run_postsim_suite.sh" none
POSTSIM_VECTOR_DIR="${THESIS_VECTOR_DIR}" POSTSIM_SUITE_DIR="${THESIS_POSTSIM_DIR}" \
    "${SCRIPT_DIR}/run_postsim_suite.sh" dc
"${SCRIPT_DIR}/run_innovus.sh" all
POSTSIM_VECTOR_DIR="${THESIS_VECTOR_DIR}" POSTSIM_SUITE_DIR="${THESIS_POSTSIM_DIR}" \
    "${SCRIPT_DIR}/run_postsim_suite.sh" innovus
"${SCRIPT_DIR}/run_virtuoso_layout.sh"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

cat <<EOF
[thesis-dip][PASS] DiP thesis mainline completed
[thesis-dip][INFO] DC netlist       : ${DC_NETLIST}
[thesis-dip][INFO] DC sdf           : ${DC_SDF}
[thesis-dip][INFO] Innovus netlist  : ${INNOVUS_NETLIST}
[thesis-dip][INFO] Innovus sdf      : ${INNOVUS_SDF}
[thesis-dip][INFO] Innovus def      : ${INNOVUS_DEF}
[thesis-dip][INFO] Innovus gds      : ${INNOVUS_GDS}
[thesis-dip][INFO] no-sdf suite     : ${THESIS_POSTSIM_DIR}/none/summary.md
[thesis-dip][INFO] dc-sdf suite     : ${THESIS_POSTSIM_DIR}/dc/summary.md
[thesis-dip][INFO] innovus-sdf suite: ${THESIS_POSTSIM_DIR}/innovus/summary.md
[thesis-dip][INFO] Virtuoso lib     : ${VIRTUOSO_LAYOUT_LIB}
[thesis-dip][INFO] Next step        : make thesis-innovus-gui
EOF
