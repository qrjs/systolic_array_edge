# DiP Test Notes

当前 DiP 验证建议分两层理解：

- `dip/tb/standard_dip_file_tb.sv`：前端正式功能验证入口，读取 `.txt` 输入并与 `.txt` 标准答案比对
- `dip/tb/standard_dip_smoke_tb.sv`：轻量 smoke testbench，仅用于调试
- `make dip-txt` / `make dip-txt-vcs`：正式文件型回归
- `make dip` / `make dip-vcs`：调试型主功能仿真
