#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

check_filelist_entries() {
    local line
    while IFS= read -r line; do
        line="${line%%#*}"
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        [[ -z "$line" ]] && continue
        require_file "filelist entry" "$(resolve_path "$line")"
    done <"$FILELIST"
}

require_file "RTL wrapper" "$RTL_WRAPPER"
require_file "filelist" "$FILELIST"
require_file "SDC" "$SDC_FILE"
require_file "frontsim TB" "$FRONTSIM_TB_FILE"
require_file "postsim TB" "$POSTSIM_TB_FILE"
check_filelist_entries

cat <<EOF
[dip-flow][PASS] handoff inputs look complete
  FLOW_ROOT=${FLOW_ROOT}
  DESIGN_NAME=${DESIGN_NAME}
  FILELIST=${FILELIST}
  SDC=${SDC_FILE}
  FRONTSIM_TB=${FRONTSIM_TB_FILE}
  POSTSIM_TB=${POSTSIM_TB_FILE}
EOF
