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

set probe_lib [require_env ICC2_PROBE_LIB]
set tech_file [require_env ICC2_PROBE_TECH_FILE]
set ref_libs [split [require_env ICC2_PROBE_REF_LIBS]]

puts "ICC2 probe starting"
puts "  probe_lib = $probe_lib"
puts "  tech_file = $tech_file"
puts "  ref_libs  = $ref_libs"
maybe_configure_icc_shell_exec

file delete -force $probe_lib
create_lib $probe_lib -technology $tech_file -ref_libs $ref_libs
open_lib $probe_lib
close_lib

puts "ICC2 probe completed successfully"
quit
