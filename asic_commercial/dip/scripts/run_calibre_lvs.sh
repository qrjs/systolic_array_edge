#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

CALIBRE_BIN="${CALIBRE_BIN:-calibre}"
require_tool "$CALIBRE_BIN"

runset="$(resolve_path "${CALIBRE_LVS_RUNSET:-}")"
require_file "Calibre LVS runset" "$runset"
require_file "Layout GDS" "$CALIBRE_GDS"
require_file "Source netlist" "$CALIBRE_SOURCE_NETLIST"

exec "$CALIBRE_BIN" -lvs -hier -runset "$runset" -batch

