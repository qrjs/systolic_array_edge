#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/../../.." && pwd)
ORFS_HOME=${ORFS_HOME:-${HOME}/OpenROAD-flow-scripts}
DESIGN_CONFIG="${PROJECT_ROOT}/asic/flows/openroad/dip/nangate45/config.mk"
RUN_MODE=${ORFS_RUN_MODE:-docker}

if [[ $# -eq 0 ]]; then
    set -- synth
fi

translated_args=()
for arg in "$@"; do
    if [[ "${arg}" == "netlist" ]]; then
        translated_args+=("results/nangate45/dip4x4/base/1_2_yosys.v")
    else
        translated_args+=("${arg}")
    fi
done
set -- "${translated_args[@]}"

if [[ ! -f "${DESIGN_CONFIG}" ]]; then
    echo "error: missing DESIGN_CONFIG at ${DESIGN_CONFIG}" >&2
    exit 1
fi

if [[ ! -f "${ORFS_HOME}/flow/Makefile" ]]; then
    echo "error: ORFS not found at ${ORFS_HOME}" >&2
    echo "hint: set ORFS_HOME or extract OpenROAD-flow-scripts under ~/OpenROAD-flow-scripts" >&2
    exit 1
fi

run_local() {
    local make_args=(
        --file="${ORFS_HOME}/flow/Makefile"
        "DESIGN_CONFIG=${DESIGN_CONFIG}"
    )

    if command -v yosys >/dev/null 2>&1; then
        make_args+=("YOSYS_EXE=$(command -v yosys)")
    fi

    if command -v openroad >/dev/null 2>&1; then
        make_args+=("OPENROAD_EXE=$(command -v openroad)")
    fi

    (
        cd "${PROJECT_ROOT}"
        make "${make_args[@]}" "$@"
    )
}

run_docker() {
    docker run --rm \
        -u "$(id -u)":"$(id -g)" \
        -v "${ORFS_HOME}":/OpenROAD-flow-scripts \
        -v "${PROJECT_ROOT}":"${PROJECT_ROOT}" \
        -w "${PROJECT_ROOT}" \
        openroad/orfs \
        bash -lc "source /OpenROAD-flow-scripts/env.sh >/dev/null 2>&1 || true; make --file=/OpenROAD-flow-scripts/flow/Makefile DESIGN_CONFIG=${DESIGN_CONFIG} $*"
}

case "${RUN_MODE}" in
    local)
        run_local "$@"
        ;;
    docker)
        run_docker "$@"
        ;;
    *)
        echo "error: unsupported ORFS_RUN_MODE=${RUN_MODE}" >&2
        echo "hint: use ORFS_RUN_MODE=local or ORFS_RUN_MODE=docker" >&2
        exit 1
        ;;
esac
