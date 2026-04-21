# DiP Commercial Flow

`dip` 是 `asic_commercial/` 里真正承载商业后端脚本的基准 flow。  
`ws/is/os` 的多数后端脚本包装层都会复用这里的实现。

## 目录作用

- `config/design.env`
  - 设计名、wrapper、filelist、SDC、postsim TB 模式
- `config/libs.example.env`
  - 另一台机器上需要填写的库、ICC2、Calibre、postsim 相关路径模板
- `scripts/prepare_env.sh`
  - 统一解析 `design.env` / `libs.env`，导出所有运行路径
- `scripts/check_handoff.sh`
  - 检查静态 handoff 输入是否齐
- `scripts/check_backend_inputs.sh`
  - 按阶段检查 DC / postsim / ICC2 / Calibre 所需输入
- `scripts/run_frontsim.sh`
  - 跑 RTL file-vector 前仿（VCS）
- `scripts/run_dc.sh`
  - 跑单套 DiP 商业综合
- `scripts/run_postsim.sh`
  - 跑 gate-level file-vector 后仿
- `scripts/run_icc2.sh`
  - 跑 ICC2 布局布线
- `scripts/run_iccw.sh`
  - 打开 ICC2 GUI
- `scripts/run_virtuoso_layout.sh`
  - 把 GDS stream in 到 OA 后用 Virtuoso 打开 layout
- `postsim/tb/dip_core_postsim_file_tb.sv`
  - `dip_core_top_4x4` 对应的 file-vector testbench，frontsim/postsim 共用同一套核心行流输出检查口径

## 另一台机器上的最小步骤

```bash
cd asic_commercial/dip
cp config/libs.example.env config/libs.env
```

先把这些路径填好：

- `TARGET_LIBRARY`
- `LINK_LIBRARY`
- `SIM_LIBRARY_VERILOG`
- `ICC2_TECH_FILE`
- `ICC2_REFERENCE_LIBS`
- `CALIBRE_DRC_RUNSET`
- `CALIBRE_LVS_RUNSET`

然后按顺序检查：

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh frontsim
./scripts/check_backend_inputs.sh dc
./scripts/check_backend_inputs.sh postsim
./scripts/check_backend_inputs.sh icc2
```

## 推荐执行顺序

### 1. RTL 前仿

```bash
./scripts/run_frontsim.sh
```

默认也支持指定单个 txt case：

```bash
FRONTSIM_INPUT=/abs/path/to/suite_input.txt \
FRONTSIM_EXPECTED=/abs/path/to/suite_expected.txt \
FRONTSIM_CASE=case_003 \
./scripts/run_frontsim.sh
```

### 2. DC 综合

```bash
./scripts/run_dc.sh
```

产物默认在：

- `results/dip_core_top_4x4_dc.v`
- `results/dip_core_top_4x4_dc.sdf`
- `results/dip_core_top_4x4_dc.ddc`
- `reports/dip_core_top_4x4_dc_*.rpt`

### 3. Gate-level 后仿

默认会跑一个 file-vector case。  
可以直接指定输入文件：

```bash
POSTSIM_INPUT=/abs/path/to/input.txt \
POSTSIM_EXPECTED=/abs/path/to/expected.txt \
./scripts/run_postsim.sh
```

如果输入文件是 `suite_input.txt / suite_expected.txt` 这种 suite，也可以指定：

```bash
POSTSIM_INPUT=/abs/path/to/suite_input.txt \
POSTSIM_EXPECTED=/abs/path/to/suite_expected.txt \
POSTSIM_CASE=case_003 \
./scripts/run_postsim.sh
```

如果要回标 SDF：

```bash
POSTSIM_SDF_MODE=dc ./scripts/run_postsim.sh
POSTSIM_SDF_MODE=icc2 ./scripts/run_postsim.sh
```

### 4. ICC2 布局布线

完整流程：

```bash
./scripts/run_icc2.sh all
```

也可以分阶段：

```bash
./scripts/run_icc2.sh init
./scripts/run_icc2.sh place
./scripts/run_icc2.sh cts
./scripts/run_icc2.sh route
./scripts/run_icc2.sh export
```

默认导出：

- `results/icc2/dip_core_top_4x4_icc2.v`
- `results/icc2/dip_core_top_4x4_icc2.sdf`
- `results/icc2/dip_core_top_4x4.def`
- `results/icc2/dip_core_top_4x4.gds`

### 5. 打开 ICC2 GUI

```bash
./scripts/run_iccw.sh
```

### 6. 用 Virtuoso 看版图

如果你有 `virtuoso` 和 `strmin`，并且知道 tech lib 名字：

```bash
VIRTUOSO_TECH_LIB=<oa_tech_lib_name> ./scripts/run_virtuoso_layout.sh
```

默认会：

- 取 `results/icc2/dip_core_top_4x4.gds`
- stream in 到 OA library
- 打开 `layout` 视图

可覆盖变量：

- `VIRTUOSO_LAYOUT_GDS`
- `VIRTUOSO_LAYOUT_LIB`
- `VIRTUOSO_TECH_LIB`

## 稀疏 workload / 活动统计

仓库里已经补了两类对比辅助脚本：

### 1. 前端 workload 统计

用于在同一组 txt vectors 下比较：

- `active_mac`
- `zero_gated`
- `skip_ratio`
- `cycles`

命令示例：

```bash
python3 utils/run_workload_compare.py \
  --vector-dir test_vectors/generated/power_sparse \
  --output-dir /tmp/workload_compare_sparse \
  --simulator vcs \
  --arches ws is os dip
```

输出：

- `all_case_metrics.csv`
- `summary.md`

### 2. Gate-level workload 统计

用于对商业 gate netlist 跑同一组 file-vector workload，并生成：

- 每 case 日志
- 每 case VCD（可选）
- `active_mac`
- `skip_ratio`
- `launch_cycle / done_cycle / cycles`

命令示例：

```bash
python3 utils/run_gate_power_compare.py \
  --arch dip \
  --vector-dir test_vectors/generated/power_sparse \
  --output-dir /tmp/dip_gate_sparse \
  --sdf-mode dc \
  --dump-vcd
```

说明：

- 当前 gate-level workload compare 按 `ws/is/os/dip` 四种数据流统一支持
- 每个 flow 的 `design.env` 默认切到标准-API wrapper，以便 `VCS` 前仿/后仿复用同一组 file-vector workload

## 说明

- 这套脚本已经把路径和模式变量统一到了 `prepare_env.sh`
- 本地已经做过 shell 语法检查
- `dip_core_postsim_file_tb.sv` 已经做过语法编译检查
- 商业工具本身没有在当前机器上执行，因为当前环境没有 `dc_shell / icc2_shell / fm_shell / calibre / virtuoso`
