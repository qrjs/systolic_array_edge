#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
export FLOW_ROOT=$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)
export RUNSET_ROOT=$(builtin cd "${SCRIPT_DIR}/../../dip" && /bin/pwd -P)
export POSTSIM_FLAVOR="${POSTSIM_FLAVOR:-plain}"
exec "${RUNSET_ROOT}/scripts/run_postsim_suite.sh" "$@"
