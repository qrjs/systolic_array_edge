#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

CALIBRE_BIN="${CALIBRE_BIN:-calibre}"
require_tool "$CALIBRE_BIN"

runset="$(resolve_path "${CALIBRE_LVS_RUNSET:-}")"
require_file "Calibre LVS rule deck" "$runset"
require_file "Layout GDS" "$CALIBRE_LVS_GDS"
require_file "Source netlist" "$CALIBRE_SOURCE_NETLIST"

escape_sed_replacement() {
    printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

filter_lvs_source_cdl() {
    local input_cdl="$1"
    local ignore_cells="${CALIBRE_LVS_IGNORE_CELLS:-}"
    local drop_top_power_ports="${CALIBRE_LVS_DROP_TOP_POWER_PORTS:-0}"
    if [[ -z "$ignore_cells" && "$drop_top_power_ports" != "1" ]]; then
        printf '%s\n' "$input_cdl"
        return
    fi

    local filtered_cdl="${input_cdl%.cdl}_filtered.cdl"
    awk \
        -v cells="$ignore_cells" \
        -v drop_top_power_ports="$drop_top_power_ports" \
        -v top_cell="$DESIGN_NAME" \
        -v power_net="${POWER_NET:-VDD}" \
        -v ground_net="${GROUND_NET:-VSS}" '
        BEGIN {
            n = split(cells, names, /[[:space:]]+/)
            for (i = 1; i <= n; i++) {
                if (names[i] != "") {
                    ignore[names[i]] = 1
                }
            }
        }
        function filter_top_decl_line(line, arr, i, n_tokens, out, sep, token) {
            sub(/^[[:space:]]+/, "", line)
            if (line ~ /^\+/) {
                sub(/^\+[[:space:]]*/, "", line)
                out = "+"
                sep = " "
            } else {
                out = ""
                sep = ""
            }

            n_tokens = split(line, arr, /[[:space:]]+/)
            for (i = 1; i <= n_tokens; i++) {
                token = arr[i]
                if (token == "" || token == power_net || token == ground_net) {
                    continue
                }
                out = out sep token
                sep = " "
            }
            return out
        }
        {
            if (drop_top_power_ports == "1") {
                if (toupper($1) == ".SUBCKT") {
                    in_top_subckt_decl = ($2 == top_cell)
                    if (in_top_subckt_decl) {
                        filtered = filter_top_decl_line($0)
                        if (filtered !~ /^\+[[:space:]]*$/ && filtered != "") {
                            print filtered
                        }
                        next
                    }
                } else if (in_top_subckt_decl && $1 == "+") {
                    filtered = filter_top_decl_line($0)
                    if (filtered !~ /^\+[[:space:]]*$/ && filtered != "") {
                        print filtered
                    }
                    next
                } else {
                    in_top_subckt_decl = 0
                }
            }
        }
        /^[Xx]/ {
            for (cell in ignore) {
                pattern = "(^|[[:space:]])" cell "([[:space:]]|$)"
                if ($0 ~ pattern) {
                    next
                }
            }
        }
        { print }
    ' "$input_cdl" > "$filtered_cdl"
    echo "[dip-flow][INFO] filtered LVS source CDL: $filtered_cdl" >&2
    printf '%s\n' "$filtered_cdl"
}

configure_lvs_layout_text() {
    local deck="$1"
    local mode="${CALIBRE_LVS_TEXT_MODE:-gds}"
    case "$mode" in
        gds)
            return 0
            ;;
        ports_only)
            require_file "Calibre LVS port DEF" "$CALIBRE_LVS_PORT_DEF"
            python3 "${SCRIPT_DIR}/generate_calibre_port_text.py" \
                --def "$CALIBRE_LVS_PORT_DEF" \
                --top "$DESIGN_NAME" \
                --output "$CALIBRE_LVS_PORT_TEXT"
            python3 - "$deck" "$CALIBRE_LVS_PORT_TEXT" <<'PY'
import sys
from pathlib import Path

deck = Path(sys.argv[1])
port_text = Path(sys.argv[2]).resolve()
lines = deck.read_text(errors="ignore").splitlines()
port_text_lines = port_text.read_text(errors="ignore").splitlines()
filtered = []
insert_after = None
for line in lines:
    if line.lstrip().startswith("LAYER MAP") and "TEXTTYPE" in line:
        continue
    stripped = line.strip()
    if stripped.startswith("TEXT LAYER") or stripped.startswith("PORT LAYER TEXT"):
        insert_after = len(filtered)
    filtered.append(line)

payload = ["// External top-level port labels inserted by run_calibre_lvs.sh."]
payload.extend(port_text_lines)
payload.append("// End external top-level port labels.")
if insert_after is None:
    filtered = payload + [""] + filtered
else:
    insert_at = insert_after + 1
    filtered = filtered[:insert_at] + payload + filtered[insert_at:]

deck.write_text("\n".join(filtered) + "\n")
PY
            ;;
        none)
            sed -i -E \
                -e '/^[[:space:]]*LAYER MAP[[:space:]]+[0-9]+[[:space:]]+TEXTTYPE[[:space:]]+/d' \
                -e '/^[[:space:]]*TEXT LAYER[[:space:]]+/d' \
                -e '/^[[:space:]]*PORT LAYER TEXT[[:space:]]+/d' \
                "$deck"
            ;;
        *)
            die "unsupported CALIBRE_LVS_TEXT_MODE '$mode' (expected gds, ports_only, or none)"
            ;;
    esac
}

configure_lvs_deck_switches() {
    local deck="$1"
    if [[ "${CALIBRE_LVS_STD_LIB:-0}" == "1" ]]; then
        if grep -Eq '^[[:space:]]*//[[:space:]]*#define[[:space:]]+STD_LIB\b' "$deck"; then
            sed -i -E 's|^[[:space:]]*//[[:space:]]*#define[[:space:]]+STD_LIB\b|#define STD_LIB|' "$deck"
        elif ! grep -Eq '^[[:space:]]*#define[[:space:]]+STD_LIB\b' "$deck"; then
            python3 - "$deck" <<'PY'
import sys
from pathlib import Path

deck = Path(sys.argv[1])
lines = deck.read_text(errors="ignore").splitlines()
out = []
inserted = False
for line in lines:
    out.append(line)
    if not inserted and line.strip() == "tvf::VERBATIM {":
        out.append("#define STD_LIB")
        inserted = True
if not inserted:
    out.insert(0, "#define STD_LIB")
deck.write_text("\n".join(out) + "\n")
PY
        fi
    fi
}

source_for_lvs="$CALIBRE_SOURCE_NETLIST"
case "$source_for_lvs" in
    *.v|*.vg|*.sv)
        if [[ "${CALIBRE_LVS_UNIQUE_CASE_NETS:-0}" == "1" ]]; then
            python3 "${SCRIPT_DIR}/normalize_lvs_verilog_case.py" \
                --input "$source_for_lvs" \
                --output "$CALIBRE_LVS_NORMALIZED_VERILOG" \
                --report "$CALIBRE_LVS_CASE_REPORT"
            source_for_lvs="$CALIBRE_LVS_NORMALIZED_VERILOG"
            echo "[dip-flow][INFO] normalized LVS Verilog: $source_for_lvs"
        fi
        verilog_for_v2lvs="$source_for_lvs"
        V2LVS_BIN="${V2LVS_BIN:-v2lvs}"
        require_tool "$V2LVS_BIN"
        source_spice="$(resolve_path "${CALIBRE_LVS_SOURCE_SPICE:-}")"
        require_file "Calibre LVS source SPICE library" "$source_spice"
        source_for_lvs="${CALIBRE_LVS_SOURCE_CDL:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_source.cdl}"
        mkdir -p "$(dirname "$source_for_lvs")"
        echo "[dip-flow][INFO] v2lvs source CDL: $source_for_lvs"
        "$V2LVS_BIN" \
            -v "$verilog_for_v2lvs" \
            -lsp "$source_spice" \
            -s "$source_spice" \
            -s1 "${POWER_NET:-VDD}" \
            -s0 "${GROUND_NET:-VSS}" \
            -addpin "${POWER_NET:-VDD}" \
            -addpin "${GROUND_NET:-VSS}" \
            -o "$source_for_lvs" \
            -log "${CALIBRE_WORK_DIR}/${DESIGN_NAME}_v2lvs.log"
        source_for_lvs="$(filter_lvs_source_cdl "$source_for_lvs")"
        ;;
esac
require_file "Calibre LVS source CDL/SPICE" "$source_for_lvs"

prepared_deck="${CALIBRE_LVS_DECK:-${CALIBRE_WORK_DIR}/${DESIGN_NAME}_lvs.rule}"
gds_esc="$(escape_sed_replacement "$CALIBRE_LVS_GDS")"
top_esc="$(escape_sed_replacement "$DESIGN_NAME")"
source_esc="$(escape_sed_replacement "$source_for_lvs")"
results_esc="$(escape_sed_replacement "${CALIBRE_LVS_RESULTS_DB:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_lvs_drc.results}")"
report_esc="$(escape_sed_replacement "${CALIBRE_LVS_RPT:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_lvs.rep}")"

mkdir -p "$(dirname "$prepared_deck")" "$CALIBRE_REPORT_DIR"
sed \
    -e "s/LAYOUT PATH \"lvs_top.gds\"/LAYOUT PATH \"${gds_esc}\"/" \
    -e "s/LAYOUT PRIMARY \"lvs_top\"/LAYOUT PRIMARY \"${top_esc}\"/" \
    -e "s/SOURCE PATH \"lvs_top.cdl\"/SOURCE PATH \"${source_esc}\"/" \
    -e "s/SOURCE PRIMARY \"lvs_top\"/SOURCE PRIMARY \"${top_esc}\"/" \
    -e "s/DRC RESULTS DATABASE \"calibre_drc.db\"/DRC RESULTS DATABASE \"${results_esc}\"/" \
    -e "s/LVS REPORT \"lvs.rep\"/LVS REPORT \"${report_esc}\"/" \
    "$runset" > "$prepared_deck"

configure_lvs_deck_switches "$prepared_deck"
configure_lvs_layout_text "$prepared_deck"

if [[ -n "${CALIBRE_LVS_GLOBALS_ARE_PORTS:-}" ]]; then
    if grep -Eq '^[[:space:]]*LVS GLOBALS ARE PORTS[[:space:]]+(YES|NO)' "$prepared_deck"; then
        sed -i -E \
            "s/^[[:space:]]*LVS GLOBALS ARE PORTS[[:space:]]+(YES|NO)/LVS GLOBALS ARE PORTS ${CALIBRE_LVS_GLOBALS_ARE_PORTS}/" \
            "$prepared_deck"
    elif grep -Eq '^[[:space:]]*LVS IGNORE PORTS[[:space:]]+(YES|NO)' "$prepared_deck"; then
        sed -i -E \
            "/^[[:space:]]*LVS IGNORE PORTS[[:space:]]+(YES|NO)/a LVS GLOBALS ARE PORTS ${CALIBRE_LVS_GLOBALS_ARE_PORTS}" \
            "$prepared_deck"
    else
        printf '\nLVS GLOBALS ARE PORTS %s\n' "$CALIBRE_LVS_GLOBALS_ARE_PORTS" >> "$prepared_deck"
    fi
fi

echo "[dip-flow][INFO] Calibre LVS deck: $prepared_deck"
echo "[dip-flow][INFO] Calibre LVS GDS: $CALIBRE_LVS_GDS"
echo "[dip-flow][INFO] Calibre LVS STD_LIB: ${CALIBRE_LVS_STD_LIB:-0}"
echo "[dip-flow][INFO] Calibre LVS text mode: ${CALIBRE_LVS_TEXT_MODE:-gds}"
echo "[dip-flow][INFO] Calibre LVS report: ${CALIBRE_LVS_RPT:-${CALIBRE_REPORT_DIR}/${DESIGN_NAME}_lvs.rep}"
exec "$CALIBRE_BIN" -lvs -hier "$prepared_deck"
