#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)

timestamp="$(date +%Y%m%d_%H%M%S)"
dest_root="${REPO_ROOT}/work/root_artifacts/${timestamp}"

mkdir -p "${dest_root}"

shopt -s nullglob

is_tracked() {
    git -C "${REPO_ROOT}" ls-files --error-unmatch -- "$1" >/dev/null 2>&1
}

move_if_untracked() {
    local rel="$1"
    local src="${REPO_ROOT}/${rel}"
    [[ -e "${src}" ]] || return 0
    if is_tracked "${rel}"; then
        echo "[tidy-workspace][SKIP] tracked file kept in place: ${rel}"
        return 0
    fi
    mv "${src}" "${dest_root}/"
    echo "[tidy-workspace][MOVE] ${rel} -> work/root_artifacts/${timestamp}/"
    moved=1
}

move_glob_if_untracked() {
    local pattern="$1"
    local path
    for path in "${REPO_ROOT}"/${pattern}; do
        [[ -e "${path}" ]] || continue
        move_if_untracked "$(basename "${path}")"
    done
}

moved=0

# Root-level tool spillover that does not belong in the source tree.
for rel in \
    command.log \
    default.svf \
    alib-52 \
    calibre_erc.db \
    calibre_erc.sum \
    FM_WORK \
    formality_svf \
    formality1_svf \
    formality.log \
    formality.lck \
    formality1.log \
    fm_shell_command.log \
    fm_shell_command.lck \
    fm_shell_command1.log \
    icc2_command.log \
    icc2_output.txt \
    icc_output.txt \
    lc_command.log \
    innovus.cmd \
    innovus.log \
    innovus.logv \
    lc_output.txt \
    power.rpt \
    rc_model.bin \
    streamOut.map \
    summaryReport \
    timingReports \
    ucli.key \
    vc_hdrs.h \
    csrc \
    verdiLog
do
    move_if_untracked "${rel}"
done

# Synopsys synthesis scratch files that sometimes land in the repo root.
move_glob_if_untracked "*.mr"
move_glob_if_untracked "*-verilog.pvl"
move_glob_if_untracked "*-verilog.syn"

# Calibre/Innovus/Formality reports and density spillover sometimes land in
# the repository root when a tool is launched outside its flow directory.
move_glob_if_untracked "*.rep"
move_glob_if_untracked "*.density"
move_glob_if_untracked "*.rpt"
move_glob_if_untracked "*.rpt.old"
move_glob_if_untracked "*.NO_TCDDMY*"
move_glob_if_untracked "innovus.cmd*"
move_glob_if_untracked "innovus.log*"
move_glob_if_untracked "cpd_pre_place_opt_*"
move_glob_if_untracked "*_via_layer_*.htmsummaryReport"
move_glob_if_untracked ".tmp_ctrl_file_*"

if [[ "${moved}" == "0" ]]; then
    rmdir "${dest_root}" 2>/dev/null || true
    rmdir "$(dirname "${dest_root}")" 2>/dev/null || true
    echo "[tidy-workspace][INFO] no root-level generated clutter found"
    exit 0
fi

echo "[tidy-workspace][PASS] workspace artifacts were collected under work/root_artifacts/${timestamp}/"
