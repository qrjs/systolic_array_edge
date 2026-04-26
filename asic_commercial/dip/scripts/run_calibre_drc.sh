#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

CALIBRE_BIN="${CALIBRE_BIN:-calibre}"
require_tool "$CALIBRE_BIN"

runset="$(resolve_path "${CALIBRE_DRC_RUNSET:-}")"
require_file "Calibre DRC rule deck" "$runset"
require_file "Layout GDS" "$CALIBRE_GDS"

escape_sed_replacement() {
    printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

prepared_deck="${CALIBRE_DRC_DECK:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_drc.rule}"
profile="${CALIBRE_DRC_PROFILE:-foundry}"
gds_esc="$(escape_sed_replacement "$CALIBRE_GDS")"
top_esc="$(escape_sed_replacement "$DESIGN_NAME")"
results_esc="$(escape_sed_replacement "${CALIBRE_DRC_RESULTS_DB:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_drc.results}")"
report_esc="$(escape_sed_replacement "${CALIBRE_DRC_RPT:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_drc.rep}")"

mkdir -p "$(dirname "$prepared_deck")" "$CALIBRE_REPORT_DIR"
sed \
    -e "s/LAYOUT PATH \"GDSFILENAME\"/LAYOUT PATH \"${gds_esc}\"/" \
    -e "s/LAYOUT PRIMARY \"TOPCELLNAME\"/LAYOUT PRIMARY \"${top_esc}\"/" \
    -e "s/DRC RESULTS DATABASE \"DRC_RES.db\"/DRC RESULTS DATABASE \"${results_esc}\"/" \
    -e "s/DRC SUMMARY REPORT \"DRC.rep\"/DRC SUMMARY REPORT \"${report_esc}\"/" \
    "$runset" > "$prepared_deck"

case "$profile" in
    foundry|strict)
        ;;
    block|backend)
        # Block-level stdcell P&R has no sealring, bumps, package RDL, full-chip
        # window, or signoff density context. Keep FEOL/BEOL geometry checks on,
        # but disable rules that are only meaningful at chip/package/DFM level.
        sed -i -E \
            -e 's/^#DEFINE[[:space:]]+(FULL_CHIP|WITH_SEALRING|WITH_APRDL|WITH_POLYIMIDE|AP_28K_THICKNESS|GUIDELINE_ESD|GUIDELINE_ANALOG|DATATYPE_WARNING|CHECK_LOW_DENSITY)\b.*/#UNDEFINE \1/' \
            -e 's/^#DEFINE[[:space:]]+(Recommended|Analog|Guideline|First_priority|Manufacturing_concern|Device_performace)\b.*/#UNDEFINE \1/' \
            -e 's/^#DEFINE[[:space:]]+(_[A-Za-z0-9_]+_)[[:space:]]*$/#UNDEFINE \1/' \
            "$prepared_deck"
        if [[ "$profile" == "backend" ]]; then
            # P&R closure cannot fix foundry stdcell-internal FEOL. This profile
            # checks only the routed BEOL shapes around the placed stdcell block.
            sed -i -E \
                -e 's/^#DEFINE[[:space:]]+FRONT_END\b.*/#UNDEFINE FRONT_END/' \
                -e 's/^\/\/#DEFINE[[:space:]]+BACK_END\b.*/#DEFINE BACK_END/' \
                "$prepared_deck"
        fi
        ;;
    *)
        echo "[dip-flow][ERROR] unsupported CALIBRE_DRC_PROFILE='$profile' (expected backend, block, foundry, or strict)" >&2
        exit 1
        ;;
esac

echo "[dip-flow][INFO] Calibre DRC deck: $prepared_deck"
echo "[dip-flow][INFO] Calibre DRC profile: $profile"
echo "[dip-flow][INFO] Calibre DRC report: ${CALIBRE_DRC_RPT:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_drc.rep}"
exec "$CALIBRE_BIN" -drc -hier "$prepared_deck"
