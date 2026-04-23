# 商业 ASIC 流程上机说明

这份文档对应当前仓库的 Cadence 双轨 bring-up，重点是：

- functional backend track：
  `plain DC -> gate postsim -> Innovus -> Virtuoso`
- gated debug track：
  `gated_default DC -> FM -> 定向 gate debug`
- `SMIC40` PDK 的数字后端交付与 `OA` 资源分开检查

## 1. 当前主线

当前推荐记住这几条命令：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
make thesis-check
make thesis-synth
make thesis-dip
make thesis-dip-gated-debug
make thesis-innovus-gui
make thesis-virtuoso
```

含义：

- `thesis-check`
  检查 `DC / VCS / Innovus` 主线输入，并明确提示 `Virtuoso` 资源是否缺失
- `thesis-synth`
  跑论文主表综合
- `thesis-dip`
  跑 `DIP` functional backend track
- `thesis-dip-gated-debug`
  跑 `DIP` gated 功能偏差定位入口
- `thesis-innovus-gui`
  打开 `Innovus` GUI
- `thesis-virtuoso`
  导入 `Innovus GDS` 并打开 `Virtuoso layout`

## 2. 最少要准备什么

先设：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
```

注意：

- `SMIC40_PDK_ROOT` 不能包含空格
- 当前脚本的库路径变量按空白分隔，带空格目录会被拆坏

### 2.1 DC 需要

- 标准单元 `.db`
- 可能的宏 `.db`

关键变量：

- `TARGET_LIBRARY`
- `LINK_LIBRARY`

### 2.2 Gate postsim 需要

- 门级网表
- 标准单元仿真模型 `*.v`
- 时序后仿需要 `SDF`

关键变量：

- `SIM_LIBRARY_VERILOG`
- `ADDITIONAL_SIM_VERILOGS`
- `POSTSIM_NETLIST_MODE`
- `POSTSIM_SDF_MODE`
- `CUSTOM_NETLIST`
- `CUSTOM_SDF`

### 2.3 Innovus 需要

- `techLEF`
- 标准单元和宏 `LEF`
- setup/hold `Liberty` 或 `db` 对应时序库
- `QRC/Quantus` 技术文件
- 可选 `GDS map`

关键变量：

- `INNOVUS_TECH_LEF`
- `INNOVUS_LEF_FILES`
- `INNOVUS_LIB_MAX`
- `INNOVUS_LIB_MIN`
- `INNOVUS_QRC_TECH_FILE`
- `INNOVUS_GDS_MAP`

### 2.4 Virtuoso 需要

- `OA` 工艺库或可 attach 的 tech lib
- `strmin`
- `Innovus` 导出的 `GDS`

关键变量：

- `VIRTUOSO_TECH_LIB`
- `VIRTUOSO_LAYOUT_GDS`

## 3. 上机前先做什么检查

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh dc
./scripts/check_backend_inputs.sh innovus
./scripts/check_backend_inputs.sh virtuoso
```

建议再跑：

```bash
make thesis-check
```

它会把两类问题分开报：

- `Innovus` 数字后端交付缺失
- `Virtuoso/OA` 浏览资源缺失

## 4. Gate postsim 怎么跑

单 case 调试：

```bash
POSTSIM_SDF_MODE=dc \
POSTSIM_INPUT=/abs/path/to/input.txt \
POSTSIM_EXPECTED=/abs/path/to/expected.txt \
./scripts/run_postsim.sh
```

functional 主线正式全量回归：

```bash
./scripts/run_postsim_suite.sh
```

默认会按三阶段顺序跑：

1. `none`
2. `dc`
3. `innovus`

如果上一阶段失败，脚本会立刻停住，不继续后面的阶段。

gated debug 默认不跑全量 gate suite，而是只跑：

- `batch_000`
- `signed_mix`

## 5. Innovus 怎么跑

完整流程：

```bash
./scripts/run_innovus.sh all
```

阶段入口：

```bash
./scripts/run_innovus.sh init
./scripts/run_innovus.sh place
./scripts/run_innovus.sh cts
./scripts/run_innovus.sh route
./scripts/run_innovus.sh export
```

默认导出：

- `results/innovus/*.v`
- `results/innovus/*.sdf`
- `results/innovus/*.def`
- `results/innovus/*.gds`

## 6. Virtuoso 怎么看版图

```bash
VIRTUOSO_TECH_LIB=smic40ll ./scripts/run_virtuoso_layout.sh
```

默认会：

- 从 `results/innovus/*.gds` 取输入
- `strmin` 导入到 `OA`
- 打开 `layout`

如果你希望命令前台等待 Virtuoso 退出，再加：

```bash
VIRTUOSO_WAIT=1 ./scripts/run_virtuoso_layout.sh
```

## 7. 当前状态说明

截至当前代码状态：

- `DIP` 的 Cadence 双轨脚本已经切换完成
- `plain` 网表是后端主线输入
- `gated_default` 网表单独用于 FM 与功能偏差定位
- 旧的 Synopsys 数字后端链不再是 `DIP` 正式主线
- 当前本机没有真实 Cadence 工具和 PDK 环境，所以这里只能做静态检查，不能替代目标服务器实跑
