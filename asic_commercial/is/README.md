# IS Commercial Flow

`asic_commercial/is/` uses the shared TSMC28 commercial flow with the IS
standard-API wrapper and IS-specific file-vector bench.

```bash
cd /home/host_1/systolic_array_edge
export TSMC28_ROOT=/opt/eda_tools/TSMC28

make thesis-is
```

The flow runs RTL VCS suite, DC, FM, gate suites `none/dc`, Innovus, post-route
FM, and gate suite `innovus`. Calibre DRC/LVS and Virtuoso import are explicit
debug/signoff steps using `RUN_CALIBRE_DRC=1 RUN_CALIBRE_LVS=1` or
`RUN_VIRTUOSO=1 VIRTUOSO_TECH_LIB=<oa_tech_lib_name>`. Gate suites require at
least 268 cases by default.
