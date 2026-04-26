#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

VIRTUOSO_BIN="${VIRTUOSO_BIN:-virtuoso}"
STRMIN_BIN="${STRMIN_BIN:-strmin}"
require_tool "$VIRTUOSO_BIN"
require_tool "$STRMIN_BIN"

[[ -n "$VIRTUOSO_TECH_LIB" ]] || die "VIRTUOSO_TECH_LIB must be set before importing GDS into Virtuoso"
require_file "Virtuoso layout GDS" "$VIRTUOSO_LAYOUT_GDS"

layout_import_log="${VIRTUOSO_WORK_DIR}/${DESIGN_NAME}_strmin.log"
open_il="${VIRTUOSO_WORK_DIR}/open_${DESIGN_NAME}_layout.il"

"$STRMIN_BIN" \
    -library "$VIRTUOSO_LAYOUT_LIB" \
    -strmFile "$VIRTUOSO_LAYOUT_GDS" \
    -attachTechFileOfLib "$VIRTUOSO_TECH_LIB" \
    -topCell "$DESIGN_NAME" \
    -view layout \
    -logFile "$layout_import_log"

cat >"$open_il" <<EOF
let(()
  geOpen(?lib "$VIRTUOSO_LAYOUT_LIB" ?cell "$DESIGN_NAME" ?view "layout")
)
EOF

if [[ "${VIRTUOSO_WAIT:-0}" == "1" ]]; then
    exec "$VIRTUOSO_BIN" -replay "$open_il"
fi

"$VIRTUOSO_BIN" -replay "$open_il" >/dev/null 2>&1 &
virt_pid=$!
disown "$virt_pid" 2>/dev/null || true
echo "[dip-flow][PASS] Virtuoso import completed"
echo "[dip-flow][PASS]   layout_lib = ${VIRTUOSO_LAYOUT_LIB}"
echo "[dip-flow][PASS]   gds = ${VIRTUOSO_LAYOUT_GDS}"
echo "[dip-flow][PASS]   virtuoso_pid = ${virt_pid}"
