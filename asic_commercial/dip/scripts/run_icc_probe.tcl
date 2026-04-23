proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

set probe_lib [require_env ICC_PROBE_LIB]
set tech_file [require_env ICC_PROBE_TECH_FILE]
set ref_libs [split [require_env ICC_PROBE_REF_LIBS]]

puts "ICC probe starting"
puts "  probe_lib = $probe_lib"
puts "  tech_file = $tech_file"
puts "  ref_libs  = $ref_libs"

file delete -force $probe_lib
create_mw_lib $probe_lib -technology $tech_file -mw_reference_library $ref_libs
open_mw_lib $probe_lib
close_mw_lib

puts "ICC probe completed successfully"
quit
