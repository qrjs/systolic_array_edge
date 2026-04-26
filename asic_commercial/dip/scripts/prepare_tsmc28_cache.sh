#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && /bin/pwd -P)
REPO_ROOT=$(builtin cd "${SCRIPT_DIR}/../../.." && /bin/pwd -P)

TSMC28_ROOT="${TSMC28_ROOT:-/opt/eda_tools/TSMC28}"
TSMC28_ROOT="${TSMC28_ROOT%/}"
TSMC28_CACHE_ROOT="${TSMC28_CACHE_ROOT:-${REPO_ROOT}/asic_commercial/pdk_cache/tsmc28_icc}"
TSMC28_12T_RELEASE="${TSMC28_12T_RELEASE:-${TSMC28_ROOT}/logic/tcbn28hpcplusbwp12t40p140_180a/AN61001_20180514}"
TSMC28_STACK="${TSMC28_STACK:-10lm5X2Y2ZUTRDL}"
TSMC28_STACK_DIRECTION="${TSMC28_STACK_DIRECTION:-VHV}"
TSMC28_PREPARE_ICC_RC="${TSMC28_PREPARE_ICC_RC:-0}"
TSMC28_GENERATE_ICC_TLUPLUS="${TSMC28_GENERATE_ICC_TLUPLUS:-0}"
if [[ "$TSMC28_GENERATE_ICC_TLUPLUS" == "1" ]]; then
    TSMC28_PREPARE_ICC_RC="1"
fi

die() {
    echo "[dip-flow][ERROR] $*" >&2
    exit 1
}

require_file() {
    local path="$1"
    [[ -f "$path" ]] || die "missing file: $path"
}

extract_if_missing() {
    local archive="$1"
    local marker="$2"
    if [[ -e "$marker" ]]; then
        echo "[dip-flow][INFO] cache hit: $marker"
        return 0
    fi

    echo "[dip-flow][INFO] extracting $(basename "$archive")"
    tar --overwrite -xzf "$archive" -C "${TSMC28_CACHE_ROOT}/logic"
}

extract_zip_targz_if_missing() {
    local zip_file="$1"
    local inner_targz="$2"
    local dest_dir="$3"
    local marker="$4"
    if [[ -e "$marker" ]]; then
        echo "[dip-flow][INFO] cache hit: $marker"
        return 0
    fi

    command -v unzip >/dev/null 2>&1 || die "unzip not found in PATH"
    mkdir -p "$dest_dir"
    echo "[dip-flow][INFO] extracting ${inner_targz} from $(basename "$zip_file")"
    unzip -p "$zip_file" "$inner_targz" | tar --overwrite -xzf - -C "$dest_dir"
}

extract_nested_targz_if_missing() {
    local outer_archive="$1"
    local inner_targz="$2"
    local dest_dir="$3"
    local marker="$4"
    if [[ -e "$marker" ]]; then
        echo "[dip-flow][INFO] cache hit: $marker"
        return 0
    fi

    mkdir -p "$dest_dir"
    echo "[dip-flow][INFO] extracting ${inner_targz} from $(basename "$outer_archive")"
    tar -xOzf "$outer_archive" "$inner_targz" | tar --overwrite -xzf - -C "$dest_dir"
}

generate_prtf_if_missing() {
    local prtf_root="$1"
    local input_prtf="$2"
    local output_prtf="$3"
    if [[ -f "$output_prtf" ]]; then
        echo "[dip-flow][INFO] cache hit: $output_prtf"
        return 0
    fi

    command -v tclsh >/dev/null 2>&1 || die "tclsh not found in PATH"
    [[ -f "${prtf_root}/GenPRTF.tcl" ]] || die "missing GenPRTF.tcl under $prtf_root"
    [[ -f "${prtf_root}/${input_prtf}" ]] || die "missing input PRTF: ${prtf_root}/${input_prtf}"

    echo "[dip-flow][INFO] generating $(basename "$output_prtf")"
    (
        cd "$prtf_root"
        tclsh GenPRTF.tcl \
            -InputPRTF "$input_prtf" \
            -CellHeight 12 \
            -VRP 0.14 \
            -HRP 0.1 \
            -GcellMultiple 3
    )
    [[ -f "$output_prtf" ]] || die "failed to generate PRTF: $output_prtf"
}

compile_db_if_missing() {
    local lib_file="$1"
    local db_file="$2"

    if [[ -f "$db_file" ]]; then
        echo "[dip-flow][INFO] cache hit: $db_file"
        return 0
    fi

    command -v lc_shell >/dev/null 2>&1 || die "lc_shell not found in PATH"
    mkdir -p "$(dirname "$db_file")"
    echo "[dip-flow][INFO] compiling $(basename "$lib_file") -> $(basename "$db_file")"
    lc_shell -f /dev/stdin <<TCL
set lib_obj [read_lib -return_lib_collection "$lib_file"]
set lib_name [get_object_name \$lib_obj]
write_lib \$lib_name -format db -output "$db_file"
quit
TCL
}

[[ -d "$TSMC28_ROOT" ]] || die "TSMC28_ROOT not found: $TSMC28_ROOT"
[[ -d "$TSMC28_12T_RELEASE" ]] || die "12T release directory not found: $TSMC28_12T_RELEASE"

mkdir -p "${TSMC28_CACHE_ROOT}/logic"

APT_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_170a_apt.tar.gz"
APF_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_170a_apf.tar.gz"
SEF_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_170a_sef.tar.gz"
VLG_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_170a_vlg.tar.gz"
SPI_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_170a_spi.tar.gz"
GDS_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_170a_gds.tar.gz"
NLDM_ARCHIVE="${TSMC28_12T_RELEASE}/tcbn28hpcplusbwp12t40p140_180a_nldm.tar.gz"
PRTF_SYN_ZIP="${TSMC28_ROOT}/TF/tn28clpr002s1_1_5a.zip"
PRTF_CAD_ZIP="${TSMC28_ROOT}/TF/tn28clpr002e1_1_5a.zip"
TLUPLUS_ARCHIVE="${TSMC28_ROOT}/TF/RC_TLUplus_cln28hpc+_1p9m_4x2y2r_ut-alrdl_9corners_1.3a.tar.gz"
QRC_10M5X2Y2Z_ARCHIVE="${TSMC28_ROOT}/TF/RC_QRC_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a.tar.gz"
STARRC_10M5X2Y2Z_ARCHIVE="${TSMC28_ROOT}/TF/RC_Star-RCXT_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a.tar.gz"

require_file "$APT_ARCHIVE"
require_file "$APF_ARCHIVE"
require_file "$SEF_ARCHIVE"
require_file "$VLG_ARCHIVE"
require_file "$SPI_ARCHIVE"
require_file "$GDS_ARCHIVE"
require_file "$NLDM_ARCHIVE"
require_file "$PRTF_SYN_ZIP"
require_file "$PRTF_CAD_ZIP"
require_file "$TLUPLUS_ARCHIVE"
require_file "$QRC_10M5X2Y2Z_ARCHIVE"
if [[ "$TSMC28_PREPARE_ICC_RC" == "1" ]]; then
    require_file "$STARRC_10M5X2Y2Z_ARCHIVE"
fi

extract_if_missing \
    "$APT_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/milkyway/tcbn28hpcplusbwp12t40p140_170a/cell_frame_VHV_0d5_0/tcbn28hpcplusbwp12t40p140"
extract_if_missing \
    "$APF_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/milkyway/tcbn28hpcplusbwp12t40p140_170a/frame_only_VHV_0d5_0/tcbn28hpcplusbwp12t40p140"
extract_if_missing \
    "$SEF_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp12t40p140_170a/lef/tcbn28hpcplusbwp12t40p140.lef"
extract_if_missing \
    "$VLG_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Front_End/verilog/tcbn28hpcplusbwp12t40p140_170a/tcbn28hpcplusbwp12t40p140.v"
extract_if_missing \
    "$SPI_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/spice/tcbn28hpcplusbwp12t40p140_170a/tcbn28hpcplusbwp12t40p140_170a.spi"
extract_if_missing \
    "$GDS_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/gds/tcbn28hpcplusbwp12t40p140_170a/tcbn28hpcplusbwp12t40p140.gds"
extract_if_missing \
    "$NLDM_ARCHIVE" \
    "${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140tt0p9v25c.lib"

TARGET_LIB="${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140tt0p9v25c.lib"
TARGET_DB="${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140tt0p9v25c.db"
PRTF_ROOT="${TSMC28_CACHE_ROOT}/prtf"
PRTF_SYN_ROOT="${PRTF_ROOT}/N28_PRTF_Syn_v1d5a"
PRTF_CAD_ROOT="${PRTF_ROOT}/N28_PRTF_Cad_v1d5a"
ICC_TECH_FILE="${PRTF_SYN_ROOT}/tsmcn28_${TSMC28_STACK}.tf"
INNOVUS_TECH_LEF="${PRTF_CAD_ROOT}/tsmcn28_${TSMC28_STACK}.tlef"
TLUPLUS_DIR="${TSMC28_CACHE_ROOT}/rc/tluplus/1p9m_4x2y2r/typical"
QRC_10M5X2Y2Z_DIR="${TSMC28_CACHE_ROOT}/rc/qrc/1p10m_5x2y2z/typical"
STARRC_10M5X2Y2Z_DIR="${TSMC28_CACHE_ROOT}/rc/starrc/1p10m_5x2y2z/typical"
TLUPLUS_10M5X2Y2Z="${STARRC_10M5X2Y2Z_DIR}/cln28hpc+_1p10m+ut-alrdl_5x2y2z_typical.tluplus"

require_file "$TARGET_LIB"
compile_db_if_missing "$TARGET_LIB" "$TARGET_DB"
extract_zip_targz_if_missing \
    "$PRTF_SYN_ZIP" \
    "N28_PRTF_Syn_v1d5a.tar.gz" \
    "$PRTF_ROOT" \
    "${PRTF_SYN_ROOT}/PR_tech/Synopsys/TechFile/${TSMC28_STACK_DIRECTION}/tsmcn28_${TSMC28_STACK}.tf"
extract_zip_targz_if_missing \
    "$PRTF_CAD_ZIP" \
    "N28_PRTF_Cad_v1d5a.tar.gz" \
    "$PRTF_ROOT" \
    "${PRTF_CAD_ROOT}/PR_tech/Cadence/LefHeader/${TSMC28_STACK_DIRECTION}/tsmcn28_${TSMC28_STACK}.tlef"
generate_prtf_if_missing \
    "$PRTF_SYN_ROOT" \
    "PR_tech/Synopsys/TechFile/${TSMC28_STACK_DIRECTION}/tsmcn28_${TSMC28_STACK}.tf" \
    "$ICC_TECH_FILE"
generate_prtf_if_missing \
    "$PRTF_CAD_ROOT" \
    "PR_tech/Cadence/LefHeader/${TSMC28_STACK_DIRECTION}/tsmcn28_${TSMC28_STACK}.tlef" \
    "$INNOVUS_TECH_LEF"
extract_nested_targz_if_missing \
    "$TLUPLUS_ARCHIVE" \
    "RC_TLUplus_cln28hpc+_1p09m+ut-alrdl_4x2y2r_typical.tar.gz" \
    "$TLUPLUS_DIR" \
    "${TLUPLUS_DIR}/cln28hpc+_1p09m+ut-alrdl_4x2y2r_typical.tluplus"
extract_nested_targz_if_missing \
    "$QRC_10M5X2Y2Z_ARCHIVE" \
    "RC_QRC_cln28hpc+_1p10m+ut-alrdl_5x2y2z_typical.tar.gz" \
    "$QRC_10M5X2Y2Z_DIR" \
    "${QRC_10M5X2Y2Z_DIR}/qrcTechFile"
if [[ "$TSMC28_PREPARE_ICC_RC" == "1" ]]; then
    extract_nested_targz_if_missing \
        "$STARRC_10M5X2Y2Z_ARCHIVE" \
        "RC_Star-RCXT_cln28hpc+_1p10m+ut-alrdl_5x2y2z_typical.tar.gz" \
        "$STARRC_10M5X2Y2Z_DIR" \
        "${STARRC_10M5X2Y2Z_DIR}/cln28hpc+_1p10m+ut-alrdl_5x2y2z_typical.itf"
fi

if [[ "$TSMC28_PREPARE_ICC_RC" == "1" && ! -f "$TLUPLUS_10M5X2Y2Z" && "$TSMC28_GENERATE_ICC_TLUPLUS" == "1" ]]; then
    GRDGENXO_BIN="${GRDGENXO_BIN:-$(command -v grdgenxo || true)}"
    if [[ -z "$GRDGENXO_BIN" && -x /home/synopsys/starrc/O-2018.06-SP1/bin/grdgenxo ]]; then
        GRDGENXO_BIN=/home/synopsys/starrc/O-2018.06-SP1/bin/grdgenxo
    fi
    [[ -n "$GRDGENXO_BIN" ]] || die "grdgenxo not found in PATH"
    echo "[dip-flow][INFO] generating $(basename "$TLUPLUS_10M5X2Y2Z")"
    "$GRDGENXO_BIN" \
        -itf2TLUPlus \
        -i "${STARRC_10M5X2Y2Z_DIR}/cln28hpc+_1p10m+ut-alrdl_5x2y2z_typical.itf" \
        -o "$TLUPLUS_10M5X2Y2Z"
elif [[ -f "$TLUPLUS_10M5X2Y2Z" ]]; then
    echo "[dip-flow][INFO] cache hit: $TLUPLUS_10M5X2Y2Z"
fi

cat <<EOF
[dip-flow][PASS] TSMC28 cache is ready
[dip-flow][INFO] cache root       : ${TSMC28_CACHE_ROOT}
[dip-flow][INFO] metal stack      : ${TSMC28_STACK} (${TSMC28_STACK_DIRECTION})
[dip-flow][INFO] target db        : ${TARGET_DB}
[dip-flow][INFO] sim verilog      : ${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Front_End/verilog/tcbn28hpcplusbwp12t40p140_170a/tcbn28hpcplusbwp12t40p140.v
[dip-flow][INFO] cell spice       : ${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/spice/tcbn28hpcplusbwp12t40p140_170a/tcbn28hpcplusbwp12t40p140_170a.spi
[dip-flow][INFO] cell gds         : ${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/gds/tcbn28hpcplusbwp12t40p140_170a/tcbn28hpcplusbwp12t40p140.gds
[dip-flow][INFO] cell lef         : ${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp12t40p140_170a/lef/tcbn28hpcplusbwp12t40p140.lef
[dip-flow][INFO] synopsys tech    : ${ICC_TECH_FILE}
[dip-flow][INFO] innovus tech lef : ${INNOVUS_TECH_LEF}
[dip-flow][INFO] tluplus 9m       : ${TLUPLUS_DIR}/cln28hpc+_1p09m+ut-alrdl_4x2y2r_typical.tluplus
[dip-flow][INFO] innovus qrc hint : ${QRC_10M5X2Y2Z_DIR}/qrcTechFile
[dip-flow][INFO] mw base lib      : ${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/milkyway/tcbn28hpcplusbwp12t40p140_170a/frame_only_VHV_0d5_0/tcbn28hpcplusbwp12t40p140
[dip-flow][INFO] mw ref lib       : ${TSMC28_CACHE_ROOT}/logic/TSMCHOME/digital/Back_End/milkyway/tcbn28hpcplusbwp12t40p140_170a/cell_frame_VHV_0d5_0/tcbn28hpcplusbwp12t40p140
EOF
if [[ "$TSMC28_PREPARE_ICC_RC" == "1" || -f "$TLUPLUS_10M5X2Y2Z" ]]; then
    echo "[dip-flow][INFO] tluplus 10m      : ${TLUPLUS_10M5X2Y2Z}"
fi
