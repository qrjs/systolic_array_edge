#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export FLOW_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
export RUNSET_ROOT=$(cd "${SCRIPT_DIR}/../../dip" && pwd)
exec "${RUNSET_ROOT}/scripts/run_calibre_lvs.sh" "$@"
