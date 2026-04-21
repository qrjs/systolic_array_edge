# 商业 ASIC 流程上机说明

这份文档整理了 `asic_commercial/` 目录在另一台服务器上跑通
`VCS -> DC -> FM -> ICC2 -> Calibre`
所需要的环境、后仿必需输入，以及工艺库检查方法。

说明：

- 本文档面向商业 ASIC 后端与 gate-level 后仿流程
- 仓库里的前端正式功能验证口径已经统一为 `.txt` 输入 / `.txt` 标准答案比对
- 前端验证说明见 [前端验证口径统一说明_CN.md](/home/jrq/systolic_array_edge/docs/前端验证口径统一说明_CN.md)

适用对象：

- `asic_commercial/ws`
- `asic_commercial/is`
- `asic_commercial/os`
- `asic_commercial/dip`

## 1. 流程概览

当前仓库里的商业流程按下面的顺序组织：

1. `DC`：综合，输出 gate netlist / SDF / SVF
2. `FM`：形式等价检查
3. `VCS`：gate-level 后仿真
4. `ICC2`：布局布线
5. `Calibre`：DRC / LVS

其中：

- `ws/is/os` 使用自测型 post-sim testbench
- `dip` 使用文件向量型 post-sim testbench
- 不再使用 `Innovus`

## 2. 另一台服务器最少要有什么

能不能跑，不取决于你机器上有没有名为 `TSMC_013`、`TSMC_65NM_OA`、
`TSMC.90` 的目录，而取决于你是否为某一个确定工艺节点准备齐了下面这些视图。

不能把 `0.13um / 90nm / 65nm` 的文件混在一条 flow 里使用。

### 2.1 DC 需要

- 标准单元 `.db`
- 如果设计里有 `IO / SRAM / macro`，还需要这些宏的 `.db`

对应变量：

- `TARGET_LIBRARY`
- `LINK_LIBRARY`

### 2.2 VCS gate-level 后仿需要

- 门级网表
- 标准单元仿真模型 `*.v`
- 如果设计里用了 `IO / SRAM / macro`，还要这些宏的仿真模型 `*.v`
- 如果做时序后仿，还需要 `SDF`

对应变量：

- `SIM_LIBRARY_VERILOG`
- `ADDITIONAL_SIM_VERILOGS`
- `POSTSIM_NETLIST_MODE`
- `CUSTOM_NETLIST`
- `POSTSIM_SDF_MODE`
- `CUSTOM_SDF`

### 2.3 ICC2 需要

- `tech.tf`
- 参考库
- `TLU+ max`
- `TLU+ min`
- `TLU+ map`

对应变量：

- `ICC2_TECH_FILE`
- `ICC2_REFERENCE_LIBS`
- `TLUPLUS_MAX`
- `TLUPLUS_MIN`
- `TLUPLUS_MAP`

注意：

- 当前仓库原始脚本默认更偏向 `*.ndm`
- 但你这台 `TSMC.90/sc-x` 服务器没有 `NDM`，只有 `astro/FRAM + tech.tf`
- 因此当前接入方式改成：先用 `run_icc2_probe.sh` 探测 `ICC2` 能不能直接接受 `astro/tsmc090g_fram`
- 如果 `probe` 失败，本轮流程正式停在 `DC / FM / postsim`，不强行继续 `ICC2`

### 2.4 Calibre 需要

- 当前工艺节点对应的 `DRC runset`
- 当前工艺节点对应的 `LVS runset`
- ICC2 导出的 `GDS`
- 供 LVS 使用的 source netlist

对应变量：

- `CALIBRE_DRC_RUNSET`
- `CALIBRE_LVS_RUNSET`

## 3. 后仿真到底最少需要什么

后仿真分成两种。

### 3.1 只跑功能门仿

需要：

- 门级网表
- 标准单元仿真库
- testbench

这种情况下可以不回标时序：

```bash
POSTSIM_SDF_MODE=none ./scripts/run_postsim.sh
```

### 3.2 跑真正的时序后仿

需要：

- 门级网表
- 标准单元仿真库
- `SDF`
- testbench

常见用法：

```bash
POSTSIM_SDF_MODE=dc ./scripts/run_postsim.sh
POSTSIM_SDF_MODE=icc2 ./scripts/run_postsim.sh
```

其中：

- `dc` 表示使用综合后 `SDF`
- `icc2` 表示使用布局布线后 `SDF`

## 4. 如何判断另一台机器上的 TSMC 工艺包够不够

如果你只知道服务器上有：

- `TSMC_013`
- `TSMC_65NM_OA`
- `TSMC.90`

这还不足以判断是否可用。

真正要确认的是，某一个节点下是否至少能找到这些文件：

- `*.db`
- `*.v`
- `tech.tf`
- `*.tluplus` 或 `*.TLUPlus`
- `*.map`
- `*.ndm`
- `DRC/LVS runset`

如果缺的是：

- `.db`：`DC` 跑不起来
- `sim.v`：门级后仿跑不起来
- `tech.tf / TLU+ / map / NDM`：`ICC2` 跑不起来
- `DRC/LVS runset`：`Calibre` 跑不起来

如果你只有 `OA`，没有 `NDM`，那对当前脚本来说通常还不够。

## 5. 上机前推荐检查

进入某一套 flow，例如：

```bash
cd asic_commercial/dip
cp config/libs.example.env config/libs.env
```

先填 `config/libs.env`，再执行：

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh dc
./scripts/check_backend_inputs.sh fm
./scripts/check_backend_inputs.sh postsim
./scripts/check_backend_inputs.sh icc2
```

说明：

- 如果 `DC` 还没跑，`FM/postsim/ICC2/Calibre` 对综合网表、SDF、GDS 的缺失提示是正常的
- 真正必须优先补齐的是库、tech、runset 这些静态输入

## 6. 推荐执行顺序

下面是单套 flow 的推荐顺序。

如果你这轮不做 `Calibre DRC/LVS`，也不做独立 `STA`，推荐路径改成：

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh dc
./scripts/run_dc.sh
./scripts/run_fm.sh
POSTSIM_SDF_MODE=dc ./scripts/run_postsim.sh
./scripts/run_icc2_probe.sh
./scripts/run_icc2.sh all
POSTSIM_NETLIST_MODE=icc2 POSTSIM_SDF_MODE=icc2 ./scripts/run_postsim.sh
FM_IMPLEMENTATION_MODE=icc2 ./scripts/run_fm.sh
VIRTUOSO_TECH_LIB=tsmc090 ./scripts/run_virtuoso_layout.sh
```

如果 `run_icc2_probe.sh` 失败：

- 把本轮正式流程定义为截止到 `POSTSIM_SDF_MODE=dc ./scripts/run_postsim.sh`
- `ICC2 / Virtuoso` 标记为“待库格式适配”

如果只是先验证后仿环境有没有齐：

```bash
./scripts/check_backend_inputs.sh postsim
POSTSIM_SDF_MODE=none ./scripts/run_postsim.sh
```

## 7. 对当前仓库的建议

- 直接整体拷贝 `asic_commercial/` 到目标服务器
- 不要改 `asic/` 下已验证过的 RTL / filelist / SDC
- 每个数据流只需要修改自己的 `config/libs.env`
- 如果服务器上的工艺包只有 `OA` 没有 `NDM`，需要再确认 ICC2 库格式

## 8. 关键配置入口

主配置模板在：

- `asic_commercial/<flow>/config/libs.example.env`
- `asic_commercial/<flow>/config/design.env`

建议优先参考：

- `asic_commercial/README.md`
- `asic_commercial/dip/README.md`
