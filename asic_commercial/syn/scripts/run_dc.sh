#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
    cat <<'EOF'
Usage:
  run_dc.sh [base|ultra|compare|mixed] [arch ...]
  run_dc.sh --dry-run [base|ultra|compare|mixed] [arch ...]

Examples:
  ./asic_commercial/syn/scripts/run_dc.sh
  ./asic_commercial/syn/scripts/run_dc.sh compare
  ./asic_commercial/syn/scripts/run_dc.sh mixed
  ./asic_commercial/syn/scripts/run_dc.sh base ws dip
  ./asic_commercial/syn/scripts/run_dc.sh --dry-run mixed ws is os dip

Environment overrides:
  CONSTRAINT_MODE=uniform|sdc
  RUN_TAG=<tag>
  BASE_CLK_PERIOD=<ns>
  ULTRA_CLK_PERIOD=<ns>
  CLK_PERIOD=<ns>          # shared fallback for both modes
  GATED_ARCH_LIST=<archs>  # mixed mode only, default: dip
EOF
}

dry_run=0
if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run=1
    shift
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

run_mode="${1:-base}"
case "$run_mode" in
    base|ultra|compare|mixed) shift || true ;;
    "")
        run_mode="base"
        ;;
    *)
        usage
        echo "Error: unsupported run mode '$run_mode'" >&2
        exit 1
        ;;
esac

if [[ $# -gt 0 ]]; then
    export ARCH_LIST="$*"
fi
export RUN_MODE="$run_mode"
if [[ "$run_mode" == "mixed" && -z "${GATED_ARCH_LIST:-}" ]]; then
    export GATED_ARCH_LIST="dip"
fi

if [[ "$dry_run" == "1" || "${DRY_RUN:-0}" == "1" ]]; then
    export DRY_RUN=1
    exec tclsh "$SCRIPT_DIR/run.tcl"
fi

exec dc_shell -f "$SCRIPT_DIR/run.tcl"
