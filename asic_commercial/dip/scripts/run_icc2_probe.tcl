proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

proc maybe_configure_icc_shell_exec {} {
    set icc_shell_exec ""
    if {[info exists ::env(ICC_SHELL_EXEC)] && $::env(ICC_SHELL_EXEC) ne ""} {
        set icc_shell_exec $::env(ICC_SHELL_EXEC)
    } else {
        catch {set icc_shell_exec [exec which icc_shell]}
    }

    if {$icc_shell_exec ne ""} {
        puts "  icc_shell_exec = $icc_shell_exec"
        catch {set_app_options -name lib.configuration.icc_shell_exec -value $icc_shell_exec}
    } else {
        puts "  icc_shell_exec = <not found>"
    }
}

proc create_probe_lib {probe_lib tech_file ref_libs} {
    set create_mode "tech_and_ref"
    if {[info exists ::env(ICC2_CREATE_LIB_MODE)] && $::env(ICC2_CREATE_LIB_MODE) ne ""} {
        set create_mode [string tolower $::env(ICC2_CREATE_LIB_MODE)]
    }

    switch -- $create_mode {
        ref_only {
            puts "  create_lib mode = ref_only"
            create_lib $probe_lib -ref_libs $ref_libs
        }
        tech_and_ref {
            puts "  create_lib mode = tech_and_ref"
            create_lib $probe_lib -technology $tech_file -ref_libs $ref_libs
        }
        auto {
            puts "  create_lib mode = auto"
            if {$tech_file ne "" && [file exists $tech_file]} {
                puts "  auto path = use technology file"
                create_lib $probe_lib -technology $tech_file -ref_libs $ref_libs
            } else {
                puts "  auto path = use ref libs only"
                create_lib $probe_lib -ref_libs $ref_libs
            }
        }
        default {
            error "Unsupported ICC2_CREATE_LIB_MODE '$create_mode' (expected tech_and_ref, ref_only, or auto)"
        }
    }
}

set probe_lib [require_env ICC2_PROBE_LIB]
set tech_file ""
if {[info exists ::env(ICC2_PROBE_TECH_FILE)] && $::env(ICC2_PROBE_TECH_FILE) ne ""} {
    set tech_file $::env(ICC2_PROBE_TECH_FILE)
}
set ref_libs [split [require_env ICC2_PROBE_REF_LIBS]]

puts "ICC2 probe starting"
puts "  probe_lib = $probe_lib"
puts "  tech_file = $tech_file"
puts "  ref_libs  = $ref_libs"
maybe_configure_icc_shell_exec

file delete -force $probe_lib
create_probe_lib $probe_lib $tech_file $ref_libs
open_lib $probe_lib
close_lib

puts "ICC2 probe completed successfully"
quit
