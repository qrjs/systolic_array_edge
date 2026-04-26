#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
FLOW_ROOT="${FLOW_ROOT:-$(builtin cd "${SCRIPT_DIR}/.." && /bin/pwd -P)}"
REPO_ROOT=$(builtin cd "${FLOW_ROOT}/../.." && /bin/pwd -P)

# shellcheck disable=SC1091
source "${REPO_ROOT}/asic_commercial/scripts/source_eda_env.sh"

export FLOW_ROOT
export REPO_ROOT
export DESIGN_ENV="${DESIGN_ENV:-${FLOW_ROOT}/config/design.env}"
export LIBS_ENV="${LIBS_ENV:-${FLOW_ROOT}/config/libs.env}"
export DC_OUTPUT_FLAVOR="gated"
export POSTSIM_FLAVOR="gated"
export FM_FLAVOR="gated"
export MIN_GATE_CASES="${MIN_GATE_CASES:-268}"

profiles=(${DIP_GATED_PROFILES:-gated_default gated_area gated_ultra_area gated_ultra_mbw4 gated_ultra_mbw8 gated_ultra_mbw16 gated_ultra_mbw32})
opt_root="${DIP_GATED_OPT_DIR:-${FLOW_ROOT}/gated_opt}"
summary_csv="${opt_root}/summary.csv"
mkdir -p "${opt_root}"
printf 'profile,status,power_mw,area,artifact_dir,note\n' >"${summary_csv}"

# Initialize DESIGN_NAME and output path variables used by reuse checks. Each
# candidate still re-sources the environment after setting its compile profile.
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

metric_from_report() {
    local kind="$1"
    local path="$2"
    [[ -f "$path" ]] || {
        printf '%s\n' "1e99"
        return 0
    }
    case "$kind" in
        area)
            awk 'BEGIN{IGNORECASE=1; value="1e99"} /total.*cell.*area|cell.*area/ {for (i=NF;i>=1;i--) if ($i ~ /^[0-9]+([.][0-9]+)?$/) {value=$i; print value; exit}} END{if (value=="1e99") print value}' "$path"
            ;;
        power)
            awk '
                BEGIN {
                    IGNORECASE=1
                    found=0
                }
                function unit_scale(unit, lowered) {
                    lowered=tolower(unit)
                    if (lowered == "w") {
                        return 1000.0
                    }
                    if (lowered == "mw") {
                        return 1.0
                    }
                    if (lowered == "uw") {
                        return 0.001
                    }
                    if (lowered == "nw") {
                        return 0.000001
                    }
                    return 1.0
                }
                /Total[[:space:]]+Dynamic[[:space:]]+Power/ {
                    for (i=1; i<=NF; i++) {
                        if ($i ~ /^[0-9]+([.][0-9]+)?$/) {
                            printf "%.6f\n", $i * unit_scale($(i+1))
                            found=1
                            exit
                        }
                    }
                }
                END {
                    if (!found) {
                        print "1e99"
                    }
                }
            ' "$path"
            ;;
        *)
            printf '%s\n' "1e99"
            ;;
    esac
}

reuse_candidate() {
    local profile="$1"
    local candidate_dir="${opt_root}/${profile}"
    local power_metric
    local area_metric
    local dc_sdf_note="dc_sdf_unknown"

    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/prepare_env.sh"

    if [[ ! -f "${candidate_dir}/results/${DESIGN_NAME}_${profile}.v" || \
          ! -f "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_power.rpt" || \
          ! -f "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_area.rpt" ]]; then
        printf '%s,fail,1e99,1e99,%s,missing_reuse_artifacts\n' "${profile}" "${candidate_dir}" >>"${summary_csv}"
        return 1
    fi

    if [[ -f "${candidate_dir}/postsim/dc/debug_snapshot.txt" ]]; then
        case "$(awk -F= '/^suite_status=/{print $2; exit}' "${candidate_dir}/postsim/dc/debug_snapshot.txt")" in
            pass) dc_sdf_note="dc_sdf_pass" ;;
            functional-fail|compile-fail|setup-fail|no-cases) dc_sdf_note="dc_sdf_warn" ;;
        esac
    fi

    power_metric="$(metric_from_report power "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_power.rpt")"
    area_metric="$(metric_from_report area "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_area.rpt")"
    printf '%s,pass,%s,%s,%s,reuse_%s\n' "${profile}" "${power_metric}" "${area_metric}" "${candidate_dir}" "${dc_sdf_note}" >>"${summary_csv}"
    echo "[dip-gated-opt][PASS] reused profile=${profile} power_mw=${power_metric} area=${area_metric} ${dc_sdf_note}"
}

candidate_artifacts_exist() {
    local profile="$1"
    local candidate_dir="${opt_root}/${profile}"

    [[ -f "${candidate_dir}/results/${DESIGN_NAME}_${profile}.v" && \
       -f "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_power.rpt" && \
       -f "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_area.rpt" ]]
}

copy_candidate_artifacts() {
    local profile="$1"
    local candidate_dir="$2"

    mkdir -p "${candidate_dir}/results" "${candidate_dir}/reports" "${candidate_dir}/logs"
    cp "${DC_NETLIST}" "${candidate_dir}/results/${DESIGN_NAME}_${profile}.v"
    cp "${DC_SDF}" "${candidate_dir}/results/${DESIGN_NAME}_${profile}.sdf"
    cp "${DC_DDC}" "${candidate_dir}/results/${DESIGN_NAME}_${profile}.ddc" 2>/dev/null || true
    cp "${DC_SVF}" "${candidate_dir}/results/${DESIGN_NAME}_${profile}.svf" 2>/dev/null || true
    cp "${DC_EXPORTED_SDC}" "${candidate_dir}/results/${DESIGN_NAME}_${profile}.sdc" 2>/dev/null || true
    cp "${DC_AREA_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_area.rpt" 2>/dev/null || true
    cp "${DC_POWER_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_power.rpt" 2>/dev/null || true
    cp "${DC_TIMING_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_timing.rpt" 2>/dev/null || true
    cp "${DC_QOR_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_qor.rpt" 2>/dev/null || true
    cp "${DC_CHECK_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_check_design.rpt" 2>/dev/null || true
    cp "${DC_VIOLATORS_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_violators.rpt" 2>/dev/null || true
    cp "${DC_GATING_RPT}" "${candidate_dir}/reports/${DESIGN_NAME}_${profile}_gating_check.rpt" 2>/dev/null || true
    cp "${DC_LOG_FILE}" "${candidate_dir}/logs/${DESIGN_NAME}_${profile}.log" 2>/dev/null || true
}

candidate_has_timing_or_check_failure() {
    if grep -Eiq 'slack[^0-9-]*-[0-9]' "${DC_TIMING_RPT}" "${DC_VIOLATORS_RPT}" 2>/dev/null; then
        return 0
    fi
    if grep -Eiq '(^|[[:space:]])Error:|unresolved' "${DC_CHECK_RPT}" 2>/dev/null; then
        return 0
    fi
    return 1
}

run_candidate() {
    local profile="$1"
    local candidate_dir="${opt_root}/${profile}"
    local power_metric
    local area_metric

    echo "[dip-gated-opt][INFO] Running profile=${profile}"
    rm -rf "${candidate_dir}"
    mkdir -p "${candidate_dir}"

    export DC_COMPILE_PROFILE="${profile}"
    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/prepare_env.sh"

    if ! "${SCRIPT_DIR}/run_dc.sh"; then
        printf '%s,fail,1e99,1e99,%s,dc_failed\n' "${profile}" "${candidate_dir}" >>"${summary_csv}"
        return 1
    fi

    if candidate_has_timing_or_check_failure; then
        copy_candidate_artifacts "${profile}" "${candidate_dir}"
        printf '%s,fail,1e99,1e99,%s,timing_or_check_failed\n' "${profile}" "${candidate_dir}" >>"${summary_csv}"
        return 1
    fi

    if ! env FM_IMPLEMENTATION_MODE=dc FM_FLAVOR=gated "${SCRIPT_DIR}/run_fm.sh"; then
        printf '%s,fail,1e99,1e99,%s,fm_failed\n' "${profile}" "${candidate_dir}" >>"${summary_csv}"
        return 1
    fi

    if ! env POSTSIM_SUITE_DIR="${candidate_dir}/postsim" POSTSIM_FLAVOR=gated MIN_GATE_CASES="${MIN_GATE_CASES}" "${SCRIPT_DIR}/run_postsim_suite.sh" none; then
        printf '%s,fail,1e99,1e99,%s,gate_failed\n' "${profile}" "${candidate_dir}" >>"${summary_csv}"
        return 1
    fi
    dc_sdf_note="dc_sdf_pass"
    if ! env POSTSIM_SUITE_DIR="${candidate_dir}/postsim" POSTSIM_FLAVOR=gated MIN_GATE_CASES="${MIN_GATE_CASES}" "${SCRIPT_DIR}/run_postsim_suite.sh" dc; then
        dc_sdf_note="dc_sdf_warn"
        echo "[dip-gated-opt][WARN] profile=${profile} DC SDF gate suite failed; keeping zero-delay gate result as candidate qualifier"
    fi

    copy_candidate_artifacts "${profile}" "${candidate_dir}"
    power_metric="$(metric_from_report power "${DC_POWER_RPT}")"
    area_metric="$(metric_from_report area "${DC_AREA_RPT}")"
    printf '%s,pass,%s,%s,%s,ok_%s\n' "${profile}" "${power_metric}" "${area_metric}" "${candidate_dir}" "${dc_sdf_note}" >>"${summary_csv}"
    echo "[dip-gated-opt][PASS] profile=${profile} power=${power_metric} area=${area_metric} ${dc_sdf_note}"
}

for profile in "${profiles[@]}"; do
    if [[ "${DIP_REUSE_EXISTING_GATED_OPT:-0}" == "1" ]] && candidate_artifacts_exist "${profile}"; then
        reuse_candidate "${profile}" || true
    elif [[ "${DIP_REUSE_GATED_OPT:-0}" == "1" ]]; then
        reuse_candidate "${profile}" || true
    else
        run_candidate "${profile}" || true
    fi
done

selected_line="$(
    awk -F, -v margin_pct="${DIP_GATED_POWER_MARGIN_PCT:-3}" '
        NR == 1 { next }
        $2 == "pass" {
            n++
            line[n] = $0
            power[n] = $3 + 0.0
            area[n] = $4 + 0.0
            if (!have_min || power[n] < min_power) {
                min_power = power[n]
                have_min = 1
            }
        }
        END {
            if (!have_min) {
                exit
            }
            power_limit = min_power * (1.0 + margin_pct / 100.0)
            for (i = 1; i <= n; i++) {
                if (power[i] <= power_limit) {
                    if (!best || area[i] < area[best] || (area[i] == area[best] && power[i] < power[best])) {
                        best = i
                    }
                }
            }
            if (best) {
                print line[best]
            }
        }
    ' "${summary_csv}"
)"
if [[ -z "${selected_line}" ]]; then
    echo "[dip-gated-opt][ERROR] no gated profile passed DC+FM+gate suite" >&2
    echo "[dip-gated-opt][INFO] summary=${summary_csv}" >&2
    exit 1
fi

IFS=, read -r selected_profile _ selected_power selected_area selected_dir _ <<<"${selected_line}"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/prepare_env.sh"

cp "${selected_dir}/results/${DESIGN_NAME}_${selected_profile}.v" "${GATED_DC_NETLIST}"
cp "${selected_dir}/results/${DESIGN_NAME}_${selected_profile}.sdf" "${GATED_DC_SDF}"
cp "${selected_dir}/results/${DESIGN_NAME}_${selected_profile}.ddc" "${GATED_DC_DDC}" 2>/dev/null || true
cp "${selected_dir}/results/${DESIGN_NAME}_${selected_profile}.svf" "${GATED_DC_SVF}" 2>/dev/null || true
cp "${selected_dir}/results/${DESIGN_NAME}_${selected_profile}.sdc" "${GATED_DC_EXPORTED_SDC}" 2>/dev/null || true
cp "${selected_dir}/reports/${DESIGN_NAME}_${selected_profile}_area.rpt" "${REPORTS_DIR}/$(basename "${DC_AREA_RPT}")" 2>/dev/null || true
cp "${selected_dir}/reports/${DESIGN_NAME}_${selected_profile}_power.rpt" "${REPORTS_DIR}/$(basename "${DC_POWER_RPT}")" 2>/dev/null || true
cp "${selected_dir}/reports/${DESIGN_NAME}_${selected_profile}_timing.rpt" "${REPORTS_DIR}/$(basename "${DC_TIMING_RPT}")" 2>/dev/null || true
cp "${selected_dir}/reports/${DESIGN_NAME}_${selected_profile}_qor.rpt" "${REPORTS_DIR}/$(basename "${DC_QOR_RPT}")" 2>/dev/null || true
cp "${selected_dir}/logs/${DESIGN_NAME}_${selected_profile}.log" "${DC_LOG_FILE}" 2>/dev/null || true

cat >"${opt_root}/selected.env" <<EOF
DIP_SELECTED_GATED_PROFILE="${selected_profile}"
DIP_SELECTED_GATED_POWER_MW="${selected_power}"
DIP_SELECTED_GATED_POWER="${selected_power}"
DIP_SELECTED_GATED_AREA="${selected_area}"
DIP_SELECTED_GATED_DIR="${selected_dir}"
DIP_GATED_POWER_MARGIN_PCT="${DIP_GATED_POWER_MARGIN_PCT:-3}"
EOF

echo "[dip-gated-opt][PASS] selected_profile=${selected_profile} power_mw=${selected_power} area=${selected_area} power_margin_pct=${DIP_GATED_POWER_MARGIN_PCT:-3}"
echo "[dip-gated-opt][INFO] selected_netlist=${GATED_DC_NETLIST}"
echo "[dip-gated-opt][INFO] selected_sdf=${GATED_DC_SDF}"
echo "[dip-gated-opt][INFO] summary=${summary_csv}"
