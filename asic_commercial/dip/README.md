# DiP Commercial Flow

`asic_commercial/dip/` 现在承载 `DIP std + gated_default` 的正式商业主线。

当前主线固定为：

- `DC` 综合继续沿用现有脚本
- `Innovus` 负责布局布线与 post-route 导出
- `Virtuoso` 负责把 `Innovus` 导出的 `GDS` 导入 `OA` 并打开 `layout`
- `gate postsim` 固定跑三阶段：`none -> dc -> innovus`

说明：

- `ws/is/os` 仍然可以继续复用这里的公共脚本层
- 这次不改 RTL、filelist、SDC 语义
- 当前仓库本机没有暴露 `dc_shell / innovus / virtuoso`，所以端到端验证要在 Cadence 服务器上做

## 目录作用

- `config/design.std.env`
  `DIP` 主线设计入口，固定为 `dip_core_std_top_4x4`
- `config/libs.smic40.env`
  `SMIC40` PDK 双探测模板：
  `Innovus` 查 `techLEF/LEF/Liberty/QRC`，`Virtuoso` 查 `OA/stream map`
- `scripts/prepare_env.sh`
  统一解析设计与工艺配置，导出 `DC / postsim / Innovus / Virtuoso` 路径
- `scripts/run_dc.sh`
  跑 `DIP std + gated_default` 商业综合
- `scripts/run_postsim.sh`
  单 case gate postsim 调试入口
- `scripts/run_postsim_suite.sh`
  正式 gate suite 入口，按 stage 批量跑完整 `txt` 向量
- `scripts/run_innovus.sh`
  Cadence `Innovus` 主入口，支持 `init/place/cts/route/export/all`
- `scripts/run_innovus_gui.sh`
  打开 `Innovus` GUI
- `scripts/run_virtuoso_layout.sh`
  将 `Innovus GDS` 导入 `OA` 并打开 `layout`
- `postsim/tb/dip_core_std_postsim_file_tb.sv`
  `dip_core_std_top_4x4` 对应的 gate-level file-vector TB

## 最短用法

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
make thesis-check
make thesis-synth
make thesis-dip
```

其中：

- `thesis-check`
  检查 `DC / VCS / Innovus` 主线输入，并单独提示 `Virtuoso` 资源是否缺失
- `thesis-synth`
  跑论文主表综合：
  `ws/is/os legacy FIFO` + `dip std + gated_default`
- `thesis-dip`
  跑 `DIP` Cadence 主链：
  `DC -> gate suite(none) -> gate suite(dc) -> Innovus -> gate suite(innovus) -> Virtuoso`

## 推荐执行顺序

### 1. 环境检查

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh dc
./scripts/check_backend_inputs.sh innovus
./scripts/check_backend_inputs.sh virtuoso
```

### 2. RTL 前仿

```bash
./scripts/run_frontsim.sh
```

### 3. DC 综合

```bash
./scripts/run_dc.sh
```

默认产物：

- `results/dip_core_std_top_4x4_dc.v`
- `results/dip_core_std_top_4x4_dc.sdf`
- `reports/dip_core_std_top_4x4_dc_*.rpt`

### 4. Gate-level 后仿

正式入口：

```bash
./scripts/run_postsim_suite.sh
```

默认按 `POSTSIM_STAGES="none dc innovus"` 依次运行，输出到：

- `postsim/suites/none/`
- `postsim/suites/dc/`
- `postsim/suites/innovus/`

每个 stage 都会生成：

- `gate_case_metrics.csv`
- `summary.md`
- `logs/<case>.run.log`
- `vcd/<case>.vcd`（仅在 `POSTSIM_DUMP_VCD=1` 时）

如果只想跑某一阶段：

```bash
./scripts/run_postsim_suite.sh none
./scripts/run_postsim_suite.sh dc
./scripts/run_postsim_suite.sh innovus
```

如果只想调单个 case，仍然用旧入口：

```bash
POSTSIM_INPUT=/abs/path/to/input.txt \
POSTSIM_EXPECTED=/abs/path/to/expected.txt \
POSTSIM_SDF_MODE=dc \
./scripts/run_postsim.sh
```

### 5. Innovus 布局布线

```bash
./scripts/run_innovus.sh all
```

也支持阶段入口：

```bash
./scripts/run_innovus.sh init
./scripts/run_innovus.sh place
./scripts/run_innovus.sh cts
./scripts/run_innovus.sh route
./scripts/run_innovus.sh export
```

默认导出：

- `results/innovus/dip_core_std_top_4x4_innovus.v`
- `results/innovus/dip_core_std_top_4x4_innovus.sdf`
- `results/innovus/dip_core_std_top_4x4.def`
- `results/innovus/dip_core_std_top_4x4.gds`

### 6. 打开 Innovus GUI

```bash
./scripts/run_innovus_gui.sh
```

或：

```bash
make thesis-innovus-gui
```

### 7. 导入 Virtuoso 版图

```bash
VIRTUOSO_TECH_LIB=smic40ll ./scripts/run_virtuoso_layout.sh
```

默认行为：

- 取 `results/innovus/*.gds`
- `strmin` stream-in 到 `OA`
- 打开 `layout` 视图

常用变量：

- `VIRTUOSO_LAYOUT_GDS`
- `VIRTUOSO_LAYOUT_LIB`
- `VIRTUOSO_TECH_LIB`
- `VIRTUOSO_WAIT=1`
  设为 `1` 时以前台方式打开 Virtuoso；默认后台拉起 GUI 以免阻塞主链

## 关键变量

- `INNOVUS_TECH_LEF`
- `INNOVUS_LEF_FILES`
- `INNOVUS_LIB_MAX`
- `INNOVUS_LIB_MIN`
- `INNOVUS_QRC_TECH_FILE`
- `INNOVUS_GDS_MAP`
- `POSTSIM_VECTOR_DIR`
- `POSTSIM_STAGES`
- `VIRTUOSO_TECH_LIB`

## 当前结论

- 仓库已经提供 `DIP` 的 Cadence 主线脚本与入口
- 旧的 Synopsys 数字后端链不再属于 `DIP` 正式主线
- 由于当前工作区没有真实 Cadence 工具环境，这些脚本只做了静态落地与语法检查，端到端结果要以目标服务器实测为准
