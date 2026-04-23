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
- `scripts/run_icc_probe.sh`
  - 用 ICC 探测 SMIC40 Milkyway 建库兼容性
- `scripts/run_iccw.sh`
  - 打开 ICC2 GUI
- `scripts/run_virtuoso_layout.sh`
  - 把 GDS stream in 到 OA 后用 Virtuoso 打开 layout
- `postsim/tb/dip_core_std_postsim_file_tb.sv`
  - `dip_core_std_top_4x4` 对应的 gate-level file-vector testbench

## 最短用法

如果你是在另一台 EDA 服务器上跑，最短命令就是：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
make thesis-check
make thesis-dip
make thesis-icc-probe
make thesis-icc2-gui
```

说明：

- `SMIC40_PDK_ROOT`
  指向你用 U 盘拷过去、已经解压好的 PDK 根目录
- `SMIC40_PDK_ROOT` 不能包含空格
  因为当前 DC / VCS / ICC2 库变量按空白分隔，带空格路径会被错误拆开
- 脚本会优先尝试已有的环境脚本，并自动补常见安装目录到 `PATH`
  例如 `/opt/synopsys`、`/home/synopsys`、`/home/mentor`、`/home/cadence`
- 如果 `icc_shell` 不在 `PATH` 里，可以额外加：
  `export ICC_SHELL_EXEC=/absolute/path/to/icc_shell`

## 另一台机器上的最小步骤

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
cd asic_commercial/dip
```

当前这套 `SMIC40` 流的默认假设是：

- `TARGET_LIBRARY=$SMIC40_PDK_ROOT/sc9mc_base_rvt_c40/r1p1/db/sc9mc_logic0040ll_base_rvt_c40_tt_typical_max_1p10v_25c.db`
- `SIM_LIBRARY_VERILOG=$SMIC40_PDK_ROOT/sc9mc_base_rvt_c40/r1p1/verilog/sc9mc_logic0040ll_base_rvt_c40.v`
- `ICC2_TECH_FILE=$SMIC40_PDK_ROOT/smic40ll/techfile.tf`
- `ICC2_REFERENCE_LIBS=$SMIC40_PDK_ROOT/sc9mc_base_rvt_c40/r1p1/milkyway/1P9M_1TM/sc9mc_logic0040ll_base_rvt_c40`
- `GDS_STREAM_OUT_MAP=$SMIC40_PDK_ROOT/.../Smic_Virtuoso_0040_LogicLL_TF.map`
- `VIRTUOSO_TECH_LIB=smic40ll`

注意：

- `ICC2` 先走 `probe` 探测
- 如果 `probe` 失败，说明 `Milkyway -> ICC2` 转换链仍有问题，本轮流程就应停在 `DC / postsim`

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

- `results/dip_core_std_top_4x4_dc.v`
- `results/dip_core_std_top_4x4_dc.sdf`
- `results/dip_core_std_top_4x4_dc.ddc`
- `reports/dip_core_std_top_4x4_dc_*.rpt`

### 3. Gate-level 后仿

当前 thesis 主链默认不只跑一个 case，而是直接把 `test_vectors/txt`
整套文本向量都跑一遍。

如果你只是想手工单独跑一个 case，仍然可以用：

```bash
POSTSIM_INPUT=/abs/path/to/input.txt \
POSTSIM_EXPECTED=/abs/path/to/expected.txt \
./scripts/run_postsim.sh
```

### 4. ICC2 布局布线

先做一次最小探测：

```bash
./scripts/run_icc2_probe.sh
```

如果机器上有 `icc_shell`，对当前 `SMIC40` 库更值得先做一次：

```bash
./scripts/run_icc_probe.sh
```

只有 `probe` 成功后，再进入正式布局布线。

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

- `results/icc2/dip_core_std_top_4x4_icc2.v`
- `results/icc2/dip_core_std_top_4x4_icc2.sdf`
- `results/icc2/dip_core_std_top_4x4.def`
- `results/icc2/dip_core_std_top_4x4.gds`

推荐的最小后端路径是：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
make thesis-check
make thesis-dip
make thesis-icc2-gui
```

其中 `make thesis-dip` 会默认：

- 跑 `DiP std + gated_default + 5ns`
- 跑完整 `test_vectors/txt` 门级后仿，不只是一条 `signed_mix`
- 先跑 `dc sdf`，再跑 `icc2 sdf`
- 不调用 `FM / Calibre / Virtuoso / 独立 STA`

### 5. 打开 ICC2 GUI

```bash
./scripts/run_iccw.sh
```

### 6. 用 Virtuoso 看版图（可选）

如果你有 `virtuoso` 和 `strmin`，并且知道 tech lib 名字：

```bash
VIRTUOSO_TECH_LIB=<oa_tech_lib_name> ./scripts/run_virtuoso_layout.sh
```

对当前这条 `SMIC40` 流，如果后面换到有 Cadence 的机器，再试：

```bash
VIRTUOSO_TECH_LIB=smic40ll ./scripts/run_virtuoso_layout.sh
```

如果 `strmin` 拒绝 `smic40ll` 这个 tech lib 名字，就保留 `results/icc2/*.gds` 作为正式交付，再改为手工 attach 工艺库的方式打开版图。

默认会：

- 取 `results/icc2/dip_core_std_top_4x4.gds`
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
