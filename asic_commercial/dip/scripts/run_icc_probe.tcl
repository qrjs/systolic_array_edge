proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

proc fail {message} {
    puts stderr $message
    exit 1
}

set probe_lib [require_env ICC_PROBE_LIB]
set tech_file [require_env ICC_PROBE_TECH_FILE]
set ref_libs [split [require_env ICC_PROBE_REF_LIBS]]

puts "ICC probe starting"
puts "  probe_lib = $probe_lib"
puts "  tech_file = $tech_file"
puts "  ref_libs  = $ref_libs"

file delete -force $probe_lib
set create_rc [catch {create_mw_lib $probe_lib -technology $tech_file -mw_reference_library $ref_libs} create_result]
if {$create_rc != 0} {
    fail "ICC probe failed during create_mw_lib: $create_result"
}

set open_rc [catch {open_mw_lib $probe_lib} open_result]
if {$open_rc != 0} {
    fail "ICC probe failed during open_mw_lib: $open_result"
}

set close_rc [catch {close_mw_lib} close_result]
if {$close_rc != 0} {
    fail "ICC probe failed during close_mw_lib: $close_result"
}

puts "ICC probe completed successfully"
quit
