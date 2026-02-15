#!/usr/bin/tclsh
# ==============================================================================
# IC Compiler II Synthesis Script (using DC Utilities)
# Project: systolic_array_edge
# Architectures: is (Input Stationary), os (Output Stationary), ws (Weight Stationary)
# ==============================================================================

# 0. Configuration Setup
# ------------------------------------------------------------------------------
# Get MODE from environment variable or command line argument
if {[info exists ::env(MODE)]} {
    set MODE $::env(MODE)
} elseif {[llength $::argv] > 0} {
    set MODE [lindex $::argv 0]
} else {
    puts "Error: MODE not set. Usage: icc2_shell -f run_icc2_syn.tcl <is|os|ws>"
    puts "       or: MODE=is icc2_shell -f run_icc2_syn.tcl"
    exit 1
}

puts "========================================"
puts "ICC2 Synthesis for Architecture: $MODE"
puts "========================================"

set DESIGN_NAME "matrix_multiplier_top"
set RFT_DESIGN_NAME "systolic_array_${MODE}_4x4"
if {$MODE == "ws"} {
    set RFT_DESIGN_NAME "systolic_array_4x4"
}

set ROOT_DIR  "/home/jrq/systolic_array_edge"
set RTL_PATH  "${ROOT_DIR}/${MODE}/src"
set LIB_PATH  "${ROOT_DIR}/lib"
set OUT_PATH  "${ROOT_DIR}/syn/outputs/${MODE}"
set RPT_PATH  "${ROOT_DIR}/syn/reports/${MODE}"

# Ensure output directories exist
file mkdir $OUT_PATH
file mkdir $RPT_PATH

# 1. Setup Libraries
# ------------------------------------------------------------------------------
puts "Loading SMIC40 PDK configuration..."
source ${LIB_PATH}/smic40_setup.tcl

# Set up libraries for ICC2 synthesis
# ICC2 uses .lib files for timing analysis
set target_library "${LIB_DIR}/sc9mc_logic0040ll_base_rvt_c40_ss_typical_max_0p99v_125c.lib"
set link_library "* ${LIB_DIR}/sc9mc_logic0040ll_base_rvt_c40_ss_typical_max_0p99v_125c.lib"

# 3. Read RTL and Elaborate
# ------------------------------------------------------------------------------
puts "Reading RTL files for $MODE..."

# Read all Verilog files in the architecture specific directory
set rtl_files [glob -nocomplain ${RTL_PATH}/*.v]
if {[llength $rtl_files] == 0} {
    puts "Error: No verilog files found in $RTL_PATH"
    exit 1
}

foreach rtl_file $rtl_files {
    puts "  Reading: $rtl_file"
    read_verilog $rtl_file
}

# Elaborate the design
puts "Elaborating design: $DESIGN_NAME"
elaborate $DESIGN_NAME

current_design $DESIGN_NAME
link

# 4. Apply Constraints
# ------------------------------------------------------------------------------
puts "Applying design constraints..."

create_clock -name "clk" -period 10.0 [get_ports clk]
set_input_delay  2.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 2.0 -clock clk [all_outputs]
set_load 0.1 [all_outputs]

set_unconnected -ports NO

# Check design
check_design -unloaded

# 5. Synthesis (using ICC2's DC utilities)
# ------------------------------------------------------------------------------
puts "Running synthesis..."
compile

# 6. Write Outputs
# ------------------------------------------------------------------------------
puts "Writing outputs..."
write_verilog -hierarchy > ${OUT_PATH}/${DESIGN_NAME}_icc2.v
write_sdc > ${OUT_PATH}/${DESIGN_NAME}_icc2.sdc

# 7. Generate Reports
# ------------------------------------------------------------------------------
puts "Generating reports..."
report_timing -max_paths 10 > ${RPT_PATH}/timing_icc2.rpt
report_area > ${RPT_PATH}/area_icc2.rpt
report_power > ${RPT_PATH}/power_icc2.rpt
report_resources > ${RPT_PATH}/resources_icc2.rpt

puts "========================================"
puts "Synthesis Completed for $MODE"
puts "========================================"
puts "Outputs:"
puts "  Netlist: ${OUT_PATH}/${DESIGN_NAME}_icc2.v"
puts "  SDC:     ${OUT_PATH}/${DESIGN_NAME}_icc2.sdc"
puts "========================================"
puts "Reports in: ${RPT_PATH}/"
puts "========================================"

exit
