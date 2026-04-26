#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
export FLOW_ROOT=$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)
export RUNSET_ROOT=$(builtin cd "${SCRIPT_DIR}/../../dip" && /bin/pwd -P)
export INNOVUS_INPUT_FLAVOR="${INNOVUS_INPUT_FLAVOR:-plain}"
"${SCRIPT_DIR}/prepare_tsmc28_cache.sh"
exec "${RUNSET_ROOT}/scripts/check_backend_inputs.sh" "$@"
