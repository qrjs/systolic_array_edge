#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

ICC2_BIN="${ICC2_BIN:-icc2_shell}"
require_tool "$ICC2_BIN"

export ICC2_STEP="all"
"$ICC2_BIN" -gui

