#!/usr/bin/env bash
set -euo pipefail

LMGRD_BIN="/home/app/synopsys/scl/2018.06/linux64/bin/lmgrd"
LICENSE_FILE="/home/app/synopsys/scl/2018.06/admin/license/Synopsys.dat"
LOG_FILE="/home/app/synopsys/scl/2018.06/admin/license/lmgrd.log"
RUN_LOG="/tmp/synopsys_license_start.log"

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

nohup "$LMGRD_BIN" -c "$LICENSE_FILE" -l "$LOG_FILE" >> "$RUN_LOG" 2>&1 &

echo "[$(date '+%F %T')] started lmgrd with $LICENSE_FILE" >> "$RUN_LOG"
