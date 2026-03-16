# DiP Test Notes

当前 DiP 功能验证以统一 Makefile 和两个 testbench 为主：

- `dip/tb/standard_dip_smoke_tb.sv`：轻量主功能回归
- `dip/tb/standard_dip_file_tb.sv`：`.txt` 输入 / 期望输出比对回归
- `make dip` / `make dip-vcs`：主功能仿真
- `make dip-txt` / `make dip-txt-vcs`：文件型回归
