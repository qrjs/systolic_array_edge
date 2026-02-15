#!/usr/bin/tclsh
# ==============================================================================
# IC Compiler II Synthesis + Place & Route Script
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
    puts "Error: MODE not set. Usage: icc2_shell -f run_icc2.tcl <is|os|ws>"
    puts "       or: MODE=is icc2_shell -f run_icc2.tcl"
    exit 1
}

puts "========================================"
puts "ICC2 Flow for Architecture: $MODE"
puts "========================================"

set DESIGN_NAME "matrix_multiplier_top"
set RFT_DESIGN_NAME "systolic_array_${MODE}_4x4"
if {$MODE == "ws"} {
    set RFT_DESIGN_NAME "systolic_array_4x4"
}

set ROOT_DIR  "/home/jrq/systolic_array_edge"
set RTL_PATH  "${ROOT_DIR}/${MODE}/src"
set LIB_PATH  "${ROOT_DIR}/lib"
set OUT_PATH  "${ROOT_DIR}/pnr/outputs/${MODE}"
set RPT_PATH  "${ROOT_DIR}/pnr/reports/${MODE}"
set NDM_PATH  "${ROOT_DIR}/pnr/ndm"

# Ensure output directories exist
file mkdir $OUT_PATH
file mkdir $RPT_PATH
file mkdir $NDM_PATH

# 1. Setup Libraries
# ------------------------------------------------------------------------------
puts "Loading SMIC40 PDK configuration..."
source ${LIB_PATH}/smic40_setup.tcl

# 2. Initialize Design
# ------------------------------------------------------------------------------
puts "Initializing ICC2 design..."
remove_design -all

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

# 5. Synthesis (using ICC2's DC utilities)
# ------------------------------------------------------------------------------
puts "Running synthesis..."
compile

# 6. Write Post-Synthesis Reports
# ------------------------------------------------------------------------------
puts "Generating post-synthesis reports..."
report_timing -max_paths 10 > ${RPT_PATH}/timing_post_syn.rpt
report_area > ${RPT_PATH}/area_post_syn.rpt
report_power > ${RPT_PATH}/power_post_syn.rpt

# 7. Initialize Floorplan
# ------------------------------------------------------------------------------
puts "Initializing floorplan..."
initialize_floorplan -core_utilization 0.7 -core_margins_by die -side m 5

# 8. Placement
# ------------------------------------------------------------------------------
puts "Running placement..."
place_pins -self
place_opt

# 9. CTS (Clock Tree Synthesis)
# ------------------------------------------------------------------------------
puts "Running CTS..."
create_clock_tree_spec
clock_tree_synthesis

# 10. Routing
# ------------------------------------------------------------------------------
puts "Running routing..."
route_design

# 11. Optimization
# ------------------------------------------------------------------------------
puts "Running post-route optimization..."
route_opt

# 12. Final Reports
# ------------------------------------------------------------------------------
puts "Generating final reports..."
report_timing -max_paths 20 > ${RPT_PATH}/timing_final.rpt
report_area > ${RPT_PATH}/area_final.rpt
report_power > ${RPT_PATH}/power_final.rpt
report_utilization > ${RPT_PATH}/utilization.rpt

# 13. Write Outputs
# ------------------------------------------------------------------------------
puts "Writing outputs..."

# Write netlist
write_verilog -hierarchy -pg > ${OUT_PATH}/${DESIGN_NAME}_icc2.v

# Write SDC
write_sdc > ${OUT_PATH}/${DESIGN_NAME}_icc2.sdc

# Write DEF
write_def -version 5.7 > ${OUT_PATH}/${DESIGN_NAME}_icc2.def

# Write GDS (requires tech file mapping)
# write_gds > ${OUT_PATH}/${DESIGN_NAME}_icc2.gds

# Write NDM library
write_ndm -lib_root ${DESIGN_NAME}_ndm > ${NDM_PATH}/${DESIGN_NAME}_${MODE}.ndm

puts "========================================"
puts "ICC2 Flow Completed for $MODE"
puts "========================================"
puts "Outputs:"
puts "  Netlist: ${OUT_PATH}/${DESIGN_NAME}_icc2.v"
puts "  SDC:     ${OUT_PATH}/${DESIGN_NAME}_icc2.sdc"
puts "  DEF:     ${OUT_PATH}/${DESIGN_NAME}_icc2.def"
puts "  NDM:     ${NDM_PATH}/${DESIGN_NAME}_${MODE}.ndm"
puts "========================================"
puts "Reports in: ${RPT_PATH}/"
puts "========================================"

exit
