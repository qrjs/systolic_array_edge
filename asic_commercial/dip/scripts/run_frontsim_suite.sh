#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VCS_BIN="${VCS_BIN:-vcs}"
require_tool "$VCS_BIN"
require_tool python3

export FRONTSIM_VECTOR_DIR="${FRONTSIM_VECTOR_DIR:-${POSTSIM_VECTOR_DIR:-${REPO_ROOT}/test_vectors/txt}}"
export FRONTSIM_SUITE_DIR="${FRONTSIM_SUITE_DIR:-${FLOW_ROOT}/frontsim/suites}"
export FRONTSIM_MIN_CASES="${FRONTSIM_MIN_CASES:-${MIN_VECTOR_CASES:-0}}"

echo "[dip-flow][INFO] Running RTL frontsim suite"
echo "[dip-flow][INFO]   design=${DESIGN_NAME}"
echo "[dip-flow][INFO]   vector_dir=${FRONTSIM_VECTOR_DIR}"
echo "[dip-flow][INFO]   output_dir=${FRONTSIM_SUITE_DIR}"

python3 "${REPO_ROOT}/utils/run_front_vector_suite.py" \
    --vector-dir "${FRONTSIM_VECTOR_DIR}" \
    --output-dir "${FRONTSIM_SUITE_DIR}"
