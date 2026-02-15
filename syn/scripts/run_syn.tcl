# ==============================================================================
# Design Compiler Synthesis Script
# Project: systolic_array_edge
# Architectures: is (Input Stationary), os (Output Stationary), ws (Weight Stationary)
# ==============================================================================

# 0. Configuration Setup
# ------------------------------------------------------------------------------
# Get MODE from environment variable or use first argument
if {[info exists ::env(MODE)]} {
    set MODE $::env(MODE)
} elseif {[llength $::argv] > 0} {
    set MODE [lindex $::argv 0]
} else {
    puts "Error: MODE not set. Usage: dc_shell -f run_syn.tcl <is|os|ws>"
    puts "       or: MODE=is dc_shell -f run_syn.tcl"
    exit 1
}

puts "Starting Synthesis for Architecture: $MODE"

set DESIGN_NAME "matrix_multiplier_top"
set RFT_DESIGN_NAME "systolic_array_${MODE}_4x4"
if {$MODE == "ws"} {
    set RFT_DESIGN_NAME "systolic_array_4x4"
}

set ROOT_DIR  "../.."
set RTL_PATH  "${ROOT_DIR}/${MODE}/src"
set LIB_PATH  "${ROOT_DIR}/lib"
set OUT_PATH  "../outputs/${MODE}"
set RPT_PATH  "../reports/${MODE}"

# Ensure output directories exist
file mkdir $OUT_PATH
file mkdir $RPT_PATH

# 1. Setup Libraries
# ------------------------------------------------------------------------------
# Load SMIC40 PDK Configuration
source ${LIB_PATH}/smic40_setup.tcl

# Use Slow-Slow corner for synthesis (worst-case timing)
set TARGET_LIBRARY_FILES $DB_SS
set SYMBOL_LIBRARY_FILES $DB_TT

set search_path [concat  . $RTL_PATH ${PDK_ROOT}/sc9mc_base_rvt_c40/r1p1/db $search_path]
set target_library $TARGET_LIBRARY_FILES
set symbol_library $SYMBOL_LIBRARY_FILES
set link_library [concat * $target_library]

# 2. Read Design
# ------------------------------------------------------------------------------
remove_design -all

# Read all Verilog files in the architecture specific directory
set rtl_files [glob -nocomplain ${RTL_PATH}/*.v]
if {[llength $rtl_files] == 0} {
    puts "Error: No verilog files found in $RTL_PATH"
    exit 1
}

analyze -format verilog $rtl_files
elaborate $DESIGN_NAME

current_design $DESIGN_NAME
link

# 3. Define Constraints
# ------------------------------------------------------------------------------
create_clock -name "clk" -period 10.0 [get_ports clk]
set_input_delay  2.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 2.0 -clock clk [all_outputs]

check_design

# 4. Compile
# ------------------------------------------------------------------------------
compile -map_effort medium

# 5. Write Outputs
# ------------------------------------------------------------------------------
write -format verilog -hierarchy -output ${OUT_PATH}/${DESIGN_NAME}.v
write -format ddc     -hierarchy -output ${OUT_PATH}/${DESIGN_NAME}.ddc
write_sdc ${OUT_PATH}/${DESIGN_NAME}.sdc

# 6. Generate Reports
# ------------------------------------------------------------------------------
report_area > ${RPT_PATH}/area.rpt
report_timing > ${RPT_PATH}/timing.rpt
report_power > ${RPT_PATH}/power.rpt

puts "Synthesis Completed for $MODE"
exit
