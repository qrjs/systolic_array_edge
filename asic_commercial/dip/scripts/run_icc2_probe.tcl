proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

set probe_lib [require_env ICC2_PROBE_LIB]
set tech_file [require_env ICC2_PROBE_TECH_FILE]
set ref_libs [split [require_env ICC2_PROBE_REF_LIBS]]

puts "ICC2 probe starting"
puts "  probe_lib = $probe_lib"
puts "  tech_file = $tech_file"
puts "  ref_libs  = $ref_libs"

file delete -force $probe_lib
create_lib $probe_lib -technology $tech_file -ref_libs $ref_libs
open_lib $probe_lib
close_lib

puts "ICC2 probe completed successfully"
quit
