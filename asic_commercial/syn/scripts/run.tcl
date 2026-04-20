# ====================================================================
# Standardized commercial synthesis runset for ws / is / os / dip.
#
# Usage examples:
#   dc_shell -f asic_commercial/syn/scripts/run.tcl
#   ARCH_LIST="ws dip" RUN_MODE=ultra CLK_PERIOD=1.0 \
#       dc_shell -f asic_commercial/syn/scripts/run.tcl
#
# Environment variables:
#   ARCH_LIST       Space/comma-separated list. Default: "ws is os dip"
#   RUN_MODE        base | ultra | compare. Default: base
#   CONSTRAINT_MODE uniform | sdc. Default: uniform
#   CLK_PERIOD      Shared fallback period in ns for uniform constraints.
#   BASE_CLK_PERIOD Default: 5.0
#   ULTRA_CLK_PERIOD Default: 1.0
#   RUN_TAG         Output subdirectory tag. Default: all_<run_mode>_<constraint_mode>
#   REPORT_ROOT     Default: asic_commercial/syn/reports
#   MAPPED_ROOT     Default: asic_commercial/syn/mapped
#   DRY_RUN         1 => parse config only, skip DC commands
# ====================================================================

proc env_or_default {name default_value} {
    if {[info exists ::env($name)] && $::env($name) ne ""} {
        return $::env($name)
    }
    return $default_value
}

proc split_arch_list {raw_arch_list} {
    regsub -all {[,;]} $raw_arch_list " " normalized
    set arch_list {}
    foreach token [split $normalized " "] {
        set arch [string trim [string tolower $token]]
        if {$arch ne ""} {
            lappend arch_list $arch
        }
    }
    return $arch_list
}

proc arch_config {repo_root arch} {
    switch -- $arch {
        ws {
            return [dict create \
                top ws_core_top_4x4 \
                filelist [file join $repo_root asic ws filelist.f] \
                sdc [file join $repo_root asic ws constraints ws_core_top_4x4.sdc]]
        }
        is {
            return [dict create \
                top is_core_top_4x4 \
                filelist [file join $repo_root asic is filelist.f] \
                sdc [file join $repo_root asic is constraints is_core_top_4x4.sdc]]
        }
        os {
            return [dict create \
                top os_core_top_4x4 \
                filelist [file join $repo_root asic os filelist.f] \
                sdc [file join $repo_root asic os constraints os_core_top_4x4.sdc]]
        }
        dip {
            return [dict create \
                top dip_core_top_4x4 \
                filelist [file join $repo_root asic dip filelist.f] \
                sdc [file join $repo_root asic dip constraints dip_core_top_4x4.sdc]]
        }
        default {
            error "Unsupported architecture '$arch' (expected ws/is/os/dip)"
        }
    }
}

proc read_filelist {filelist_path repo_root} {
    set fh [open $filelist_path r]
    set rtl_files {}
    while {[gets $fh line] >= 0} {
        set trimmed [string trim $line]
        if {$trimmed eq ""} {
            continue
        }
        if {[string match "#*" $trimmed]} {
            continue
        }

        if {[file pathtype $trimmed] eq "absolute"} {
            lappend rtl_files $trimmed
        } else {
            lappend rtl_files [file normalize [file join $repo_root $trimmed]]
        }
    }
    close $fh
    return $rtl_files
}

proc read_text_file {path} {
    set fh [open $path r]
    set text [read $fh]
    close $fh
    return $text
}

proc power_to_mw {value unit} {
    switch -- $unit {
        mW { return $value }
        uW { return [expr {$value * 1.0e-3}] }
        nW { return [expr {$value * 1.0e-6}] }
        pW { return [expr {$value * 1.0e-9}] }
        default { error "Unsupported power unit '$unit'" }
    }
}

proc parse_area_report {path} {
    set text [read_text_file $path]
    if {[regexp {Total cell area:\s*([0-9.eE+-]+)} $text -> area]} {
        return $area
    }
    return "NA"
}

proc parse_power_report {path} {
    set text [read_text_file $path]
    set dynamic_mw "NA"
    set leakage_mw "NA"

    if {[regexp {Total Dynamic Power\s*=\s*([0-9.eE+-]+)\s*([munp]W)} $text -> dyn_value dyn_unit]} {
        set dynamic_mw [format %.6f [power_to_mw $dyn_value $dyn_unit]]
    }
    if {[regexp {Cell Leakage Power\s*=\s*([0-9.eE+-]+)\s*([munp]W)} $text -> leak_value leak_unit]} {
        set leakage_mw [format %.6f [power_to_mw $leak_value $leak_unit]]
    }

    return [dict create dynamic_mw $dynamic_mw leakage_mw $leakage_mw]
}

proc parse_timing_report {path} {
    set text [read_text_file $path]
    if {[regexp {slack \((MET|VIOLATED)\)\s*([-0-9.eE+]+)} $text -> status slack]} {
        return [dict create slack_ns $slack timing_status $status]
    }
    return [dict create slack_ns "NA" timing_status "UNKNOWN"]
}

proc parse_black_box_flag {path} {
    set text [read_text_file $path]
    if {[regexp {black box \(unknown\) components} $text]} {
        return "yes"
    }
    if {[regexp {unresolved references} $text]} {
        return "yes"
    }
    return "no"
}

proc apply_uniform_constraints {clk_name clk_period} {
    create_clock -name $clk_name -period $clk_period [get_ports $clk_name]
    set_ideal_network [get_ports $clk_name]
    set_dont_touch_network [get_ports $clk_name]

    set excluded_inputs [get_ports [list $clk_name rst_n]]
    set data_inputs [remove_from_collection [all_inputs] $excluded_inputs]
    if {[sizeof_collection $data_inputs] > 0} {
        set input_delay [expr {$clk_period * 0.2}]
        set_input_delay $input_delay -clock $clk_name $data_inputs
    }

    if {[sizeof_collection [all_outputs]] > 0} {
        set output_delay [expr {$clk_period * 0.2}]
        set_output_delay $output_delay -clock $clk_name [all_outputs]
        set_load 0.05 [all_outputs]
    }

    set_false_path -from [get_ports rst_n]
}

proc resolve_clk_period {actual_run_mode} {
    set shared_clk_period [env_or_default CLK_PERIOD ""]
    if {$actual_run_mode eq "base"} {
        return [env_or_default BASE_CLK_PERIOD [expr {$shared_clk_period ne "" ? $shared_clk_period : 5.0}]]
    }
    if {$actual_run_mode eq "ultra"} {
        return [env_or_default ULTRA_CLK_PERIOD [expr {$shared_clk_period ne "" ? $shared_clk_period : 1.0}]]
    }
    error "Unsupported run mode '$actual_run_mode' for clock-period resolution"
}

proc run_one_arch {repo_root report_root mapped_root arch run_mode constraint_mode clk_period result_group} {
    set cfg [arch_config $repo_root $arch]
    set top_name [dict get $cfg top]
    set rtl_files [read_filelist [dict get $cfg filelist] $repo_root]

    if {[llength $rtl_files] == 0} {
        error "No RTL files resolved for architecture '$arch'"
    }

    set arch_report_dir [file join $report_root $result_group $arch]
    file mkdir $arch_report_dir
    file mkdir [file join $mapped_root $result_group]

    set check_path      [file join $arch_report_dir check_design.rpt]
    set area_path       [file join $arch_report_dir area.rpt]
    set power_path      [file join $arch_report_dir power.rpt]
    set timing_path     [file join $arch_report_dir timing.rpt]
    set violators_path  [file join $arch_report_dir violators.rpt]
    set qor_path        [file join $arch_report_dir qor.rpt]
    set gate_path       [file join $arch_report_dir gating_check.rpt]
    set netlist_path    [file join $mapped_root $result_group "${arch}_netlist.v"]
    set out_sdc_path    [file join $mapped_root $result_group "${arch}_constraints.sdc"]

    puts "===================================================================="
    puts "  Running $arch"
    puts "    top            = $top_name"
    puts "    run_mode       = $run_mode"
    puts "    constraint     = $constraint_mode"
    puts "    clk_period(ns) = $clk_period"
    puts "===================================================================="

    remove_design -all
    analyze -format sverilog $rtl_files
    elaborate $top_name
    current_design $top_name
    link
    check_design > $check_path

    if {$constraint_mode eq "sdc"} {
        read_sdc [dict get $cfg sdc]
    } elseif {$constraint_mode eq "uniform"} {
        apply_uniform_constraints clk $clk_period
    } else {
        error "Unsupported CONSTRAINT_MODE '$constraint_mode'"
    }

    if {$run_mode eq "ultra"} {
        set_clock_gating_style -minimum_bitwidth 4 \
                               -positive_edge_logic {integrated} \
                               -control_point before
        insert_clock_gating
        set_optimize_registers true
        set_max_area 0
        compile_ultra -gate_clock -retime -timing_high_effort_script
        report_clock_gating > $gate_path
    } elseif {$run_mode eq "base"} {
        compile
    } else {
        error "Unsupported RUN_MODE '$run_mode' (expected base or ultra)"
    }

    report_qor > $qor_path
    report_timing > $timing_path
    report_area > $area_path
    report_power > $power_path
    report_constraint -all_violators > $violators_path

    change_names -rules verilog -hierarchy
    write -format verilog -hierarchy -output $netlist_path
    write_sdc $out_sdc_path

    set area [parse_area_report $area_path]
    set power_dict [parse_power_report $power_path]
    set timing_dict [parse_timing_report $timing_path]
    set has_black_box [parse_black_box_flag $area_path]

    return [dict create \
        arch $arch \
        top $top_name \
        run_mode $run_mode \
        constraint_mode $constraint_mode \
        clk_period_ns $clk_period \
        area $area \
        dynamic_mw [dict get $power_dict dynamic_mw] \
        leakage_mw [dict get $power_dict leakage_mw] \
        slack_ns [dict get $timing_dict slack_ns] \
        timing_status [dict get $timing_dict timing_status] \
        black_box $has_black_box]
}

proc write_summary_files {report_root run_tag summary_rows} {
    set summary_dir [file join $report_root $run_tag]
    file mkdir $summary_dir

    set csv_path [file join $summary_dir summary.csv]
    set md_path  [file join $summary_dir summary.md]

    set csv_fh [open $csv_path w]
    puts $csv_fh "arch,top,run_mode,constraint_mode,clk_period_ns,area,dynamic_mw,leakage_mw,slack_ns,timing_status,black_box"
    foreach row $summary_rows {
        puts $csv_fh [join [list \
            [dict get $row arch] \
            [dict get $row top] \
            [dict get $row run_mode] \
            [dict get $row constraint_mode] \
            [dict get $row clk_period_ns] \
            [dict get $row area] \
            [dict get $row dynamic_mw] \
            [dict get $row leakage_mw] \
            [dict get $row slack_ns] \
            [dict get $row timing_status] \
            [dict get $row black_box]] ","]
    }
    close $csv_fh

    set md_fh [open $md_path w]
    puts $md_fh "# Synthesis Summary"
    puts $md_fh ""
    puts $md_fh "| Arch | Top | Mode | Constraint | Clk (ns) | Area | Dynamic (mW) | Leakage (mW) | Slack (ns) | Timing | Black Box |"
    puts $md_fh "| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |"
    foreach row $summary_rows {
        puts $md_fh [format "| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |" \
            [dict get $row arch] \
            [dict get $row top] \
            [dict get $row run_mode] \
            [dict get $row constraint_mode] \
            [dict get $row clk_period_ns] \
            [dict get $row area] \
            [dict get $row dynamic_mw] \
            [dict get $row leakage_mw] \
            [dict get $row slack_ns] \
            [dict get $row timing_status] \
            [dict get $row black_box]]
    }
    close $md_fh

    puts "Summary CSV : $csv_path"
    puts "Summary MD  : $md_path"
}

set SCRIPT_DIR       [file normalize [file dirname [info script]]]
set SYN_ROOT         [file normalize [file join $SCRIPT_DIR ..]]
set REPO_ROOT        [file normalize [file join $SCRIPT_DIR .. .. ..]]
set ARCH_LIST        [split_arch_list [env_or_default ARCH_LIST "ws is os dip"]]
set RUN_MODE         [string tolower [env_or_default RUN_MODE "base"]]
set CONSTRAINT_MODE  [string tolower [env_or_default CONSTRAINT_MODE "uniform"]]
set REPORT_ROOT      [file normalize [env_or_default REPORT_ROOT [file join $SYN_ROOT reports]]]
set MAPPED_ROOT      [file normalize [env_or_default MAPPED_ROOT [file join $SYN_ROOT mapped]]]
set DRY_RUN          [env_or_default DRY_RUN "0"]

switch -- $RUN_MODE {
    base -
    ultra {
        set ACTIVE_RUN_MODES [list $RUN_MODE]
    }
    compare {
        set ACTIVE_RUN_MODES {base ultra}
    }
    default {
        error "Unsupported RUN_MODE '$RUN_MODE' (expected base, ultra, or compare)"
    }
}

set RUN_TAG [env_or_default RUN_TAG "all_${RUN_MODE}_${CONSTRAINT_MODE}"]

if {$DRY_RUN eq "1"} {
    puts "DRY_RUN enabled. Parsed configuration:"
    puts "  REPO_ROOT       = $REPO_ROOT"
    puts "  ARCH_LIST       = $ARCH_LIST"
    puts "  RUN_MODE        = $RUN_MODE"
    puts "  ACTIVE_MODES    = $ACTIVE_RUN_MODES"
    puts "  CONSTRAINT_MODE = $CONSTRAINT_MODE"
    puts "  RUN_TAG         = $RUN_TAG"
    foreach actual_run_mode $ACTIVE_RUN_MODES {
        puts "  ${actual_run_mode}_clk_period = [resolve_clk_period $actual_run_mode]"
    }
    foreach arch $ARCH_LIST {
        set cfg [arch_config $REPO_ROOT $arch]
        puts "  $arch => top=[dict get $cfg top], filelist=[dict get $cfg filelist]"
    }
    exit 0
}

file mkdir $REPORT_ROOT
file mkdir $MAPPED_ROOT

set summary_rows {}
foreach actual_run_mode $ACTIVE_RUN_MODES {
    set actual_clk_period [resolve_clk_period $actual_run_mode]
    if {$RUN_MODE eq "compare"} {
        set result_group [file join $RUN_TAG $actual_run_mode]
    } else {
        set result_group $RUN_TAG
    }

    foreach arch $ARCH_LIST {
        lappend summary_rows [run_one_arch \
            $REPO_ROOT \
            $REPORT_ROOT \
            $MAPPED_ROOT \
            $arch \
            $actual_run_mode \
            $CONSTRAINT_MODE \
            $actual_clk_period \
            $result_group]
    }
}

write_summary_files $REPORT_ROOT $RUN_TAG $summary_rows
puts "All synthesis runs completed."
exit
