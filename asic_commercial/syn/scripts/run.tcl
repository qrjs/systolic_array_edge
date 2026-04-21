# ====================================================================
# Standardized commercial synthesis runset for ws / is / os / dip.
#
# Usage examples:
#   dc_shell -f asic_commercial/syn/scripts/run.tcl
#   ARCH_LIST="ws dip" RUN_MODE=ultra CLK_PERIOD=1.0 \
#       dc_shell -f asic_commercial/syn/scripts/run.tcl
#   RUN_MODE=mixed GATED_ARCH_LIST=dip CLK_PERIOD=5.0 \
#       dc_shell -f asic_commercial/syn/scripts/run.tcl
#
# Environment variables:
#   ARCH_LIST       Space/comma-separated list. Default: "ws is os dip"
#   RUN_MODE        base | ultra | compare | mixed. Default: base
#   GATED_ARCH_LIST Only used by mixed mode. Default: dip
#   DIP_COMPILE_PROFILE
#                   gated_default | gated_area | gated_ultra_area | gated_auto
#                   Default: gated_auto
#   CONSTRAINT_MODE uniform | sdc. Default: uniform
#   DC_LIB_SEARCH_PATH Default: /home/ic_libs/TSMC.90/aci/sc-x/synopsys
#   DC_TARGET_LIBRARY  Default: slow.db
#   DC_LINK_LIBRARY    Default: "* slow.db"
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

proc file_exists_in_search_path {lib_name search_paths} {
    if {[file pathtype $lib_name] eq "absolute"} {
        return [file exists $lib_name]
    }

    foreach search_dir $search_paths {
        if {[file exists [file join $search_dir $lib_name]]} {
            return 1
        }
    }
    return 0
}

proc configure_libraries {} {
    set lib_search_path [env_or_default DC_LIB_SEARCH_PATH "/home/ic_libs/TSMC.90/aci/sc-x/synopsys"]
    set target_library_raw [env_or_default DC_TARGET_LIBRARY "slow.db"]
    set link_library_raw [env_or_default DC_LINK_LIBRARY "* slow.db"]
    set lib_search_paths [split $lib_search_path]

    set current_search_path [get_app_var search_path]
    foreach search_dir $lib_search_paths {
        if {[lsearch -exact $current_search_path $search_dir] < 0} {
            set current_search_path [concat $current_search_path [list $search_dir]]
        }
    }
    set_app_var search_path $current_search_path

    set_app_var target_library [split $target_library_raw]
    set_app_var link_library [split $link_library_raw]

    puts "Library setup:"
    puts "  LIB_SEARCH_PATH = $lib_search_path"
    puts "  TARGET_LIBRARY  = $target_library_raw"
    puts "  LINK_LIBRARY    = $link_library_raw"

    if {[regexp {your_library\.db} $target_library_raw] || [regexp {your_library\.db} $link_library_raw]} {
        error "Refusing to run with placeholder library name 'your_library.db'. Check your environment overrides."
    }

    foreach lib_name [concat [split $target_library_raw] [split $link_library_raw]] {
        if {$lib_name eq "" || $lib_name eq "*"} {
            continue
        }
        if {![file_exists_in_search_path $lib_name $lib_search_paths]} {
            error "Library '$lib_name' not found. Checked search path(s): $lib_search_path"
        }
    }
}

proc split_arch_list {raw_arch_list} {
    regsub -all {[,;]} $raw_arch_list " " normalized
    set arch_list {}
    foreach token [split $normalized " "] {
        set arch_name [string trim [string tolower $token]]
        if {$arch_name ne ""} {
            lappend arch_list $arch_name
        }
    }
    return $arch_list
}

proc arch_config {repo_root arch_name} {
    switch -- $arch_name {
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
            error "Unsupported architecture '$arch_name' (expected ws/is/os/dip)"
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

proc apply_constraints {constraint_mode sdc_path clk_period} {
    if {$constraint_mode eq "sdc"} {
        read_sdc $sdc_path
    } elseif {$constraint_mode eq "uniform"} {
        apply_uniform_constraints clk $clk_period
    } else {
        error "Unsupported CONSTRAINT_MODE '$constraint_mode'"
    }
}

proc load_arch_design {top_name rtl_files check_path constraint_mode sdc_path clk_period} {
    remove_design -all
    configure_libraries
    analyze -format sverilog $rtl_files
    elaborate $top_name
    current_design $top_name
    link
    check_design > $check_path
    apply_constraints $constraint_mode $sdc_path $clk_period
}

proc numeric_metric_or_inf {value} {
    if {[string is double -strict $value]} {
        return $value
    }
    return 1.0e30
}

proc profile_beats_best {best_timing best_area best_dynamic candidate_timing candidate_area candidate_dynamic} {
    if {$best_timing eq ""} {
        return 1
    }

    set best_met [expr {$best_timing eq "MET"}]
    set candidate_met [expr {$candidate_timing eq "MET"}]
    if {$candidate_met && !$best_met} {
        return 1
    }
    if {$best_met && !$candidate_met} {
        return 0
    }

    set best_area_num [numeric_metric_or_inf $best_area]
    set candidate_area_num [numeric_metric_or_inf $candidate_area]
    if {$candidate_area_num < $best_area_num} {
        return 1
    }
    if {$candidate_area_num > $best_area_num} {
        return 0
    }

    set best_dynamic_num [numeric_metric_or_inf $best_dynamic]
    set candidate_dynamic_num [numeric_metric_or_inf $candidate_dynamic]
    if {$candidate_dynamic_num < $best_dynamic_num} {
        return 1
    }
    return 0
}

proc resolve_clk_period {actual_run_mode} {
    set shared_clk_period [env_or_default CLK_PERIOD ""]
    if {$actual_run_mode eq "base"} {
        return [env_or_default BASE_CLK_PERIOD [expr {$shared_clk_period ne "" ? $shared_clk_period : 5.0}]]
    }
    if {$actual_run_mode eq "ultra"} {
        return [env_or_default ULTRA_CLK_PERIOD [expr {$shared_clk_period ne "" ? $shared_clk_period : 1.0}]]
    }
    if {$actual_run_mode eq "mixed"} {
        return [env_or_default BASE_CLK_PERIOD [expr {$shared_clk_period ne "" ? $shared_clk_period : 5.0}]]
    }
    error "Unsupported run mode '$actual_run_mode' for clock-period resolution"
}

proc resolve_arch_run_mode {global_run_mode gated_arch_list arch_name} {
    if {$global_run_mode eq "mixed"} {
        if {[lsearch -exact $gated_arch_list $arch_name] >= 0} {
            return "gated"
        }
        return "base"
    }
    return $global_run_mode
}

proc compile_dip_gated_candidate {dip_compile_profile gate_path} {
    switch -- $dip_compile_profile {
        gated_default {
            set_clock_gating_style -minimum_bitwidth 4 \
                                   -positive_edge_logic {integrated} \
                                   -control_point before
            insert_clock_gating
            compile
        }
        gated_area {
            set_clock_gating_style -minimum_bitwidth 64 \
                                   -positive_edge_logic {integrated} \
                                   -control_point before
            insert_clock_gating
            set_max_area 0
            compile -map_effort high
        }
        gated_ultra_area {
            set_clock_gating_style -minimum_bitwidth 64 \
                                   -positive_edge_logic {integrated} \
                                   -control_point before
            insert_clock_gating
            set_max_area 0
            compile_ultra -gate_clock
        }
        default {
            error "Unsupported DIP gated candidate '$dip_compile_profile' (expected gated_default, gated_area, or gated_ultra_area)"
        }
    }

    report_clock_gating > $gate_path
}

proc run_dip_gated_profile {top_name rtl_files arch_report_dir check_path constraint_mode sdc_path clk_period} {
    set dip_compile_profile [string tolower [env_or_default DIP_COMPILE_PROFILE "gated_auto"]]

    if {$dip_compile_profile ne "gated_auto"} {
        load_arch_design $top_name $rtl_files $check_path $constraint_mode $sdc_path $clk_period
        compile_dip_gated_candidate $dip_compile_profile [file join $arch_report_dir gating_check.rpt]
        return
    }

    set candidate_profiles {gated_area gated_ultra_area}
    set best_profile ""
    set best_timing ""
    set best_area ""
    set best_dynamic ""
    set profile_trial_root [file join $arch_report_dir profile_trials]
    file mkdir $profile_trial_root

    foreach candidate_profile $candidate_profiles {
        set candidate_dir [file join $profile_trial_root $candidate_profile]
        file mkdir $candidate_dir

        set candidate_check [file join $candidate_dir check_design.rpt]
        set candidate_gate [file join $candidate_dir gating_check.rpt]
        set candidate_area [file join $candidate_dir area.rpt]
        set candidate_power [file join $candidate_dir power.rpt]
        set candidate_timing [file join $candidate_dir timing.rpt]

        load_arch_design $top_name $rtl_files $candidate_check $constraint_mode $sdc_path $clk_period
        compile_dip_gated_candidate $candidate_profile $candidate_gate
        report_area > $candidate_area
        report_power > $candidate_power
        report_timing > $candidate_timing

        set candidate_area_value [parse_area_report $candidate_area]
        set candidate_power_dict [parse_power_report $candidate_power]
        set candidate_timing_dict [parse_timing_report $candidate_timing]
        set candidate_dynamic_value [dict get $candidate_power_dict dynamic_mw]
        set candidate_timing_status [dict get $candidate_timing_dict timing_status]

        puts "DIP gated candidate $candidate_profile => timing=$candidate_timing_status area=$candidate_area_value dynamic=$candidate_dynamic_value"

        if {[profile_beats_best \
                $best_timing \
                $best_area \
                $best_dynamic \
                $candidate_timing_status \
                $candidate_area_value \
                $candidate_dynamic_value]} {
            set best_profile $candidate_profile
            set best_timing $candidate_timing_status
            set best_area $candidate_area_value
            set best_dynamic $candidate_dynamic_value
        }
    }

    if {$best_profile eq ""} {
        error "Failed to select a DIP gated compile profile"
    }

    puts "Selected DIP compile profile: $best_profile (timing=$best_timing area=$best_area dynamic=$best_dynamic)"
    load_arch_design $top_name $rtl_files $check_path $constraint_mode $sdc_path $clk_period
    compile_dip_gated_candidate $best_profile [file join $arch_report_dir gating_check.rpt]
}

proc run_one_arch {repo_root report_root mapped_root arch_name run_mode constraint_mode clk_period result_group} {
    set cfg [arch_config $repo_root $arch_name]
    set top_name [dict get $cfg top]
    set rtl_files [read_filelist [dict get $cfg filelist] $repo_root]

    if {[llength $rtl_files] == 0} {
        error "No RTL files resolved for architecture '$arch_name'"
    }

    set arch_report_dir [file join $report_root $result_group $arch_name]
    file mkdir $arch_report_dir
    file mkdir [file join $mapped_root $result_group]

    set check_path      [file join $arch_report_dir check_design.rpt]
    set area_path       [file join $arch_report_dir area.rpt]
    set power_path      [file join $arch_report_dir power.rpt]
    set timing_path     [file join $arch_report_dir timing.rpt]
    set violators_path  [file join $arch_report_dir violators.rpt]
    set qor_path        [file join $arch_report_dir qor.rpt]
    set gate_path       [file join $arch_report_dir gating_check.rpt]
    set netlist_path    [file join $mapped_root $result_group "${arch_name}_netlist.v"]
    set out_sdc_path    [file join $mapped_root $result_group "${arch_name}_constraints.sdc"]

    puts "===================================================================="
    puts "  Running $arch_name"
    puts "    top            = $top_name"
    puts "    run_mode       = $run_mode"
    puts "    constraint     = $constraint_mode"
    puts "    clk_period(ns) = $clk_period"
    puts "===================================================================="

    if {$run_mode eq "gated" && $arch_name eq "dip"} {
        run_dip_gated_profile \
            $top_name \
            $rtl_files \
            $arch_report_dir \
            $check_path \
            $constraint_mode \
            [dict get $cfg sdc] \
            $clk_period
    } else {
        load_arch_design $top_name $rtl_files $check_path $constraint_mode [dict get $cfg sdc] $clk_period

        if {$run_mode eq "ultra"} {
            set_clock_gating_style -minimum_bitwidth 4 \
                                   -positive_edge_logic {integrated} \
                                   -control_point before
            insert_clock_gating
            set_optimize_registers true
            set_max_area 0
            compile_ultra -gate_clock -retime -timing_high_effort_script
            report_clock_gating > $gate_path
        } elseif {$run_mode eq "gated"} {
            compile
        } elseif {$run_mode eq "base"} {
            compile
        } else {
            error "Unsupported RUN_MODE '$run_mode' (expected base, gated, or ultra)"
        }
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
        arch $arch_name \
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
set GATED_ARCH_LIST  [split_arch_list [env_or_default GATED_ARCH_LIST [expr {$RUN_MODE eq "mixed" ? "dip" : ""}]]]
set DIP_COMPILE_PROFILE [string tolower [env_or_default DIP_COMPILE_PROFILE "gated_auto"]]
set CONSTRAINT_MODE  [string tolower [env_or_default CONSTRAINT_MODE "uniform"]]
set REPORT_ROOT      [file normalize [env_or_default REPORT_ROOT [file join $SYN_ROOT reports]]]
set MAPPED_ROOT      [file normalize [env_or_default MAPPED_ROOT [file join $SYN_ROOT mapped]]]
set DRY_RUN          [env_or_default DRY_RUN "0"]

switch -- $RUN_MODE {
    base -
    ultra {
        set ACTIVE_RUN_MODES [list $RUN_MODE]
    }
    mixed {
        set ACTIVE_RUN_MODES {mixed}
    }
    compare {
        set ACTIVE_RUN_MODES {base ultra}
    }
    default {
        error "Unsupported RUN_MODE '$RUN_MODE' (expected base, ultra, compare, or mixed)"
    }
}

set RUN_TAG [env_or_default RUN_TAG "all_${RUN_MODE}_${CONSTRAINT_MODE}"]

if {$DRY_RUN eq "1"} {
    set dryrun_lib_search_path [env_or_default DC_LIB_SEARCH_PATH "/home/ic_libs/TSMC.90/aci/sc-x/synopsys"]
    set dryrun_target_library [env_or_default DC_TARGET_LIBRARY "slow.db"]
    set dryrun_link_library [env_or_default DC_LINK_LIBRARY {* slow.db}]
    puts "DRY_RUN enabled. Parsed configuration:"
    puts "  REPO_ROOT       = $REPO_ROOT"
    puts "  ARCH_LIST       = $ARCH_LIST"
    puts "  RUN_MODE        = $RUN_MODE"
    if {$RUN_MODE eq "mixed"} {
        puts "  GATED_ARCH_LIST = $GATED_ARCH_LIST"
        puts "  DIP_COMPILE_PROFILE = $DIP_COMPILE_PROFILE"
    }
    puts "  ACTIVE_MODES    = $ACTIVE_RUN_MODES"
    puts "  CONSTRAINT_MODE = $CONSTRAINT_MODE"
    puts "  LIB_SEARCH_PATH = $dryrun_lib_search_path"
    puts "  TARGET_LIBRARY  = $dryrun_target_library"
    puts "  LINK_LIBRARY    = $dryrun_link_library"
    if {[info exists ::env(TARGET_LIBRARY)] || [info exists ::env(LINK_LIBRARY)] || [info exists ::env(LIB_SEARCH_PATH)]} {
        puts "  NOTE            = Generic LIB_SEARCH_PATH/TARGET_LIBRARY/LINK_LIBRARY env vars are ignored by this script."
    }
    puts "  RUN_TAG         = $RUN_TAG"
    foreach actual_run_mode $ACTIVE_RUN_MODES {
        puts "  ${actual_run_mode}_clk_period = [resolve_clk_period $actual_run_mode]"
    }
    foreach arch_name $ARCH_LIST {
        set cfg [arch_config $REPO_ROOT $arch_name]
        set arch_run_mode [resolve_arch_run_mode $RUN_MODE $GATED_ARCH_LIST $arch_name]
        puts "  $arch_name => top=[dict get $cfg top], filelist=[dict get $cfg filelist], synth_mode=$arch_run_mode"
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

    foreach arch_name $ARCH_LIST {
        set arch_run_mode [resolve_arch_run_mode $RUN_MODE $GATED_ARCH_LIST $arch_name]
        lappend summary_rows [run_one_arch \
            $REPO_ROOT \
            $REPORT_ROOT \
            $MAPPED_ROOT \
            $arch_name \
            $arch_run_mode \
            $CONSTRAINT_MODE \
            $actual_clk_period \
            $result_group]
    }
}

write_summary_files $REPORT_ROOT $RUN_TAG $summary_rows
puts "All synthesis runs completed."
exit
