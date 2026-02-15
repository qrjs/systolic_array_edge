# SMIC40 PDK Library Setup
# For DC Synthesis and ICC2 Place & Route

# ============================================================================
# PDK Root Directory
# ============================================================================
set PDK_ROOT "/home/jrq/SMIC40_PDK/pdk"

# ============================================================================
# Standard Cell Libraries (for DC)
# ============================================================================
set DB_DIR "${PDK_ROOT}/sc9mc_base_rvt_c40/r1p1/db"

# Process corners:
# ff: fast-fast (1.21V, -40C or 125C)
# ss: slow-slow (0.99V, 125C or -40C)
# tt: typical-typical (1.10V, 25C)

set DB_FF "${DB_DIR}/sc9mc_logic0040ll_base_rvt_c40_ff_typical_min_1p21v_125c.db"
set DB_SS "${DB_DIR}/sc9mc_logic0040ll_base_rvt_c40_ss_typical_max_0p99v_125c.db"
set DB_TT "${DB_DIR}/sc9mc_logic0040ll_base_rvt_c40_tt_typical_max_1p10v_25c.db"

# ============================================================================
# Liberty Libraries (Timing)
# ============================================================================
set LIB_DIR "${PDK_ROOT}/sc9mc_base_rvt_c40/r1p1/lib"

set LIB_FF "${LIB_DIR}/sc9mc_logic0040ll_base_rvt_c40_ff_typical_min_1p21v_125c.lib"
set LIB_SS "${LIB_DIR}/sc9mc_logic0040ll_base_rvt_c40_ss_typical_max_0p99v_125c.lib"
set LIB_TT "${LIB_DIR}/sc9mc_logic0040ll_base_rvt_c40_tt_typical_max_1p10v_25c.lib"

# ============================================================================
# Technology File (for ICC2)
# ============================================================================
set TF_FILE "${PDK_ROOT}/40nm_TF/PDK/SPDK40LL_1125_1TM_OA_CDS_V1.4/smic40ll_1125_1tm_oa_cds_1P9M_2012_10_11_v1.4/smic40ll/techfile.tf"

# ============================================================================
# Reference Library (for ICC2)
# ============================================================================
# OA reference library path
set REF_LIB "${PDK_ROOT}/40nm_TF/PDK/SPDK40LL_1125_1TM_OA_CDS_V1.4/smic40ll_1125_1tm_oa_cds_1P9M_2012_10_11_v1.4/smic40ll"

# ============================================================================
# Operating Conditions
# ============================================================================
set OPERATING_COND "PVT_1P10V_25C"  ;# Typical condition

# ============================================================================
# Wireload Model
# ============================================================================
set WIRELOAD_MODEL "smic40ll_wl40"

# ============================================================================
# IO Libraries (if needed for P&R)
# ============================================================================
set IO_LIBS [list \
    "${REF_LIB}/ntdio11ll" \
    "${REF_LIB}/ndio11ll" \
    "${REF_LIB}/pdio11ll" \
    "${REF_LIB}/ntdio25ll" \
    "${REF_LIB}/ndio25ll" \
    "${REF_LIB}/pdio25ll" \
]

puts "========================================"
puts "SMIC40 PDK Library Configuration Loaded"
puts "========================================"
puts "PDK Root: ${PDK_ROOT}"
puts "Target Library (SS): ${DB_SS}"
puts "Link Library: ${DB_TT}"
puts "Tech File: ${TF_FILE}"
puts "Ref Library: ${REF_LIB}"
puts "========================================"
