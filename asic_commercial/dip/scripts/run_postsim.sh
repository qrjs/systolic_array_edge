#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "${SCRIPT_DIR}/prepare_env.sh" >/dev/null

"${SCRIPT_DIR}/check_backend_inputs.sh" postsim

tool_bin="${VCS_BIN:-vcs}"
if ! command -v "${tool_bin}" >/dev/null 2>&1; then
    echo "error: cannot find VCS executable '${tool_bin}'" >&2
    echo "hint: set VCS_BIN if your installation uses a different command name" >&2
    exit 1
fi

if [[ ! -f "${POSTSIM_NETLIST}" ]]; then
    echo "error: postsim netlist does not exist: ${POSTSIM_NETLIST}" >&2
    echo "hint: run scripts/run_dc.sh first, or set POSTSIM_NETLIST_MODE=custom" >&2
    exit 1
fi

if [[ -n "${POSTSIM_SDF}" && ! -f "${POSTSIM_SDF}" ]]; then
    echo "error: postsim SDF does not exist: ${POSTSIM_SDF}" >&2
    echo "hint: rerun DC/ICC2 export, or set POSTSIM_SDF_MODE=none/custom" >&2
    exit 1
fi

if [[ -n "${VCS_LICENSE_FILE:-}" ]]; then
    export SNPSLMD_LICENSE_FILE="${VCS_LICENSE_FILE}"
    export SYNOPSYS_LICENSE_FILE="${VCS_LICENSE_FILE}"
    export LM_LICENSE_FILE="${VCS_LICENSE_FILE}"
fi

tb_file="${POSTSIM_ROOT}/tb/dip_core_postsim_file_tb.sv"
simv="${POSTSIM_WORK_DIR}/${DESIGN_NAME}_postsim.simv"
compile_log="${POSTSIM_LOG_DIR}/postsim.compile.log"
summary_log="${POSTSIM_LOG_DIR}/postsim_summary.log"

compile_cmd=(
    "${tool_bin}"
    -full64
    -sverilog
    "+incdir+${PROJECT_ROOT}"
    -timescale=1ns/1ps
    -debug_access+all
    -kdb
    -licwait
    10
    -l
    "${compile_log}"
    -top
    "${POSTSIM_TB_TOP}"
    -o
    "${simv}"
    "${SIM_LIBRARY_VERILOG}"
)

for sim_file in ${ADDITIONAL_SIM_VERILOGS:-}; do
    compile_cmd+=("${sim_file}")
done

compile_cmd+=(
    "${POSTSIM_NETLIST}"
    "${POSTSIM_TB_FILE}"
)

echo "[info] compiling gate-level simulation with ${tool_bin}"
"${compile_cmd[@]}"

run_one_case() {
    local input_file="$1"
    local expected_file="$2"
    local case_name
    local run_log
    local -a run_cmd

    case_name=$(basename "${input_file}" _input.txt)
    run_log="${POSTSIM_LOG_DIR}/${case_name}.run.log"
    run_cmd=(
        "${simv}"
        -l "${run_log}"
        "+INPUT=${input_file}"
        "+EXPECTED=${expected_file}"
    )

    if [[ -n "${POSTSIM_SDF}" ]]; then
        run_cmd+=("+SDF=${POSTSIM_SDF}")
    fi

    echo "[info] running case ${case_name}"
    "${run_cmd[@]}"

    if grep -Fq "${POSTSIM_PASS_MARKER}" "${run_log}"; then
        printf 'case=%s status=PASS\n' "${case_name}" >> "${summary_log}"
    else
        printf 'case=%s status=FAIL\n' "${case_name}" >> "${summary_log}"
        echo "error: postsim case failed: ${case_name}" >&2
        return 1
    fi
}

: > "${summary_log}"

case "${POSTSIM_MODE}" in
    file)
        if [[ -n "${INPUT:-}" || -n "${EXPECTED:-}" ]]; then
            if [[ -z "${INPUT:-}" || -z "${EXPECTED:-}" ]]; then
                echo "error: INPUT and EXPECTED must be provided together" >&2
                exit 1
            fi
            run_one_case "${INPUT}" "${EXPECTED}"
        else
            vector_dir="${VECTOR_DIR:-${PROJECT_ROOT}/test_vectors/txt}"
            shopt -s nullglob
            input_files=("${vector_dir}"/*_input.txt)
            shopt -u nullglob

            if [[ "${#input_files[@]}" -eq 0 ]]; then
                echo "error: no *_input.txt vectors found under ${vector_dir}" >&2
                exit 1
            fi

            for input_file in "${input_files[@]}"; do
                expected_file="${input_file%_input.txt}_expected.txt"
                if [[ ! -f "${expected_file}" ]]; then
                    echo "error: expected file not found for ${input_file}" >&2
                    exit 1
                fi
                run_one_case "${input_file}" "${expected_file}"
            done
        fi
        ;;
    selftest)
        run_log="${POSTSIM_LOG_DIR}/selftest.run.log"
        run_cmd=("${simv}" -l "${run_log}")
        if [[ -n "${POSTSIM_SDF}" ]]; then
            run_cmd+=("+SDF=${POSTSIM_SDF}")
        fi
        echo "[info] running selftest gate-level simulation"
        "${run_cmd[@]}"
        if grep -Fq "${POSTSIM_PASS_MARKER}" "${run_log}"; then
            printf 'case=selftest status=PASS\n' >> "${summary_log}"
        else
            printf 'case=selftest status=FAIL\n' >> "${summary_log}"
            echo "error: postsim selftest failed" >&2
            exit 1
        fi
        ;;
    *)
        echo "error: unsupported POSTSIM_MODE=${POSTSIM_MODE}" >&2
        echo "hint: use file or selftest in config/design.env" >&2
        exit 1
        ;;
esac

echo "[info] postsim summary: ${summary_log}"
