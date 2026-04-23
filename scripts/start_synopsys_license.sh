#!/usr/bin/env bash
set -euo pipefail

RUN_LOG="/tmp/synopsys_license_start.log"

pick_first_existing() {
  local path
  for path in "$@"; do
    [[ -e "$path" ]] || continue
    printf '%s\n' "$path"
    return 0
  done
  return 1
}

LMGRD_BIN="${LMGRD_BIN:-$(
  pick_first_existing \
    /home/synopsys/scl/*/linux64/bin/lmgrd \
    /home/app/synopsys/scl/*/linux64/bin/lmgrd \
  2>/dev/null || true
)}"

LICENSE_FILE="${LICENSE_FILE:-$(
  pick_first_existing \
    /home/synopsys/license/Synopsys.dat \
    /home/synopsys/scl/*/admin/license/Synopsys.dat \
    /home/app/synopsys/scl/*/admin/license/Synopsys.dat \
  2>/dev/null || true
)}"

LOG_FILE="${LOG_FILE:-$(
  pick_first_existing \
    /home/synopsys/license/lmgrd.log \
    /home/synopsys/scl/*/admin/license/lmgrd.log \
    /home/app/synopsys/scl/*/admin/license/lmgrd.log \
  2>/dev/null || true
)}"

if [ ! -x "$LMGRD_BIN" ]; then
  echo "[$(date '+%F %T')] missing lmgrd: $LMGRD_BIN" >> "$RUN_LOG"
  exit 1
fi

if [ ! -f "$LICENSE_FILE" ]; then
  echo "[$(date '+%F %T')] missing license file: $LICENSE_FILE" >> "$RUN_LOG"
  exit 1
fi

if pgrep -f "lmgrd -c $LICENSE_FILE" >/dev/null 2>&1; then
  echo "[$(date '+%F %T')] lmgrd already running" >> "$RUN_LOG"
  exit 0
fi

mkdir -p "$(dirname "$LOG_FILE")"
nohup "$LMGRD_BIN" -c "$LICENSE_FILE" -l "$LOG_FILE" >> "$RUN_LOG" 2>&1 &

echo "[$(date '+%F %T')] started lmgrd with $LICENSE_FILE" >> "$RUN_LOG"
