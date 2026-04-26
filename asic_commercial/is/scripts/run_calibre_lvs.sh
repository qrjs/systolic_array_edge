#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
export FLOW_ROOT=$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)
export RUNSET_ROOT=$(builtin cd "${SCRIPT_DIR}/../../dip" && /bin/pwd -P)
exec "${RUNSET_ROOT}/scripts/run_calibre_lvs.sh" "$@"
