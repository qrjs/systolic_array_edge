# I2C DC Helper Flow

This directory packages a simple Synopsys Design Compiler flow for the
teacher-provided `i2c_master` synthesis script.

It is intentionally DC-only. It does not add FM, ICC2, or Calibre wrappers
because the referenced I2C RTL is external to this repository.

## Expected inputs

- RTL directory: `ftp/`
- Filelist: [config/i2c_master.f](/home/jrq/systolic_array_edge/asic_commercial/i2c/config/i2c_master.f:1)
- DC library setup: [config/dc_setup.tcl](/home/jrq/systolic_array_edge/asic_commercial/i2c/config/dc_setup.tcl:1)
- Constraints file: [constraints/mydesign.sdc](/home/jrq/systolic_array_edge/asic_commercial/i2c/constraints/mydesign.sdc:1)

By default, the filelist expects these RTL files under `<repo>/ftp/`:

- `i2c_master_chip.v`
- `i2c_master_top.v`
- `i2c_master_byte_ctrl.v`
- `i2c_master_bit_ctrl.v`

## How to use

1. Edit [config/dc_setup.tcl](/home/jrq/systolic_array_edge/asic_commercial/i2c/config/dc_setup.tcl:1) and replace the placeholder `.db` paths.
2. Replace [constraints/mydesign.sdc](/home/jrq/systolic_array_edge/asic_commercial/i2c/constraints/mydesign.sdc:1) with your real timing constraints.
3. Ensure the RTL files exist under `<repo>/ftp/`, or override the filelist path with `I2C_DC_FILELIST`.
4. Run:

```bash
cd asic_commercial/i2c
./scripts/run_dc.sh
```

## Optional overrides

- `DC_SHELL_BIN`: override the DC executable, for example `dc_shell-xg-t`
- `I2C_DC_TOP`: override the top module name, default is `i2c_master_top`
- `I2C_DC_FILELIST`: override the filelist path
- `I2C_DC_SDC`: override the SDC path

## Output files

- `reports/al_vios.rpt`
- `results/mydesign.mapped.ddc`
- `results/mydesign.mapped.v`

## Compatibility note

If you already have a local `dc/.synopsys_dc.setup` from your lab environment,
the Tcl runset will source it after `config/dc_setup.tcl`. That lets you keep
the original teacher workflow without checking the hidden file into git.
