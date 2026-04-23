# 商业 ASIC 流程上机说明

这份文档整理了 `asic_commercial/` 目录在另一台服务器上跑通
当前 `SMIC40 thesis` 主线所需要的环境、后仿必需输入，以及工艺库检查方法。

说明：

- 本文档主推短命令入口：
  `make thesis-check`
  `make thesis-synth`
  `make thesis-dip`
  `make thesis-icc2-gui`
- 仓库里的前端正式功能验证口径已经统一为 `.txt` 输入 / `.txt` 标准答案比对
- 前端验证说明见 [前端验证口径统一说明_CN.md](/home/jrq/systolic_array_edge/docs/前端验证口径统一说明_CN.md)

适用对象：

- `asic_commercial/ws`
- `asic_commercial/is`
- `asic_commercial/os`
- `asic_commercial/dip`

## 0. 当前实测状态

截至 `2026-04-23`，针对当前仓库自带的 `SMIC40` 工艺包，已经实测得到：

- `make thesis-check` 已通过
- `make thesis-synth` 已通过
- `SMIC40` 当前可稳定支撑论文主表的综合口径
- `ICC2 probe` 与 `ICC probe` 都已尝试，但当前交付里只看到了 `OA/CDS` 风格的 `techfile.tf`
- 现有目录下没有发现可直接供 `ICC/ICC2` 自动数字后端使用的有效 Synopsys tech/RC 配套

因此本仓库当前对 `SMIC40 thesis` 主线的正式定义是：

- 默认正式流程截止到 `DC`，必要时可继续做基于 `dc` 产物的门级后仿
- `ICC2 / ICC` 自动布局布线不再作为“默认一定能跑通”的步骤
- 如果后续补到有效 backend 包，再恢复 `ICC2 / ICC` 物理实现主线

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

先设：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
```

能不能跑，不取决于机器上有没有哪个旧节点目录，而取决于你是否已经把
`SMIC40_PDK_ROOT` 指到一套完整且解压好的 `SMIC40` 工艺库根目录。

额外注意：

- `SMIC40_PDK_ROOT` 不能包含空格
- 当前这套脚本的库路径变量按空白分隔，带空格目录会让 `TARGET_LIBRARY` /
  `SIM_LIBRARY_VERILOG` / `ICC2_REFERENCE_LIBS` 被错误拆开

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

- 当前这条 `SMIC40` 流默认走 `tech.tf + Milkyway ref lib`
- 如果你的机器上同时装有 `ICC`，脚本会优先复用 `icc_shell` 协助 `ICC2` 接受 Milkyway ref lib
- 如果 `icc_shell` 不在 `PATH` 里，请显式设置：
  `ICC_SHELL_EXEC=/absolute/path/to/icc_shell`
- 如果 `probe` 失败，本轮流程正式停在 `DC / postsim`，不强行继续 `ICC2`

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

## 4. 如何判断 `SMIC40_PDK_ROOT` 指向的工艺库够不够

真正要确认的是，`$SMIC40_PDK_ROOT` 下是否至少能找到这些文件：

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

先设：

```bash
export SMIC40_PDK_ROOT=/absolute/path/to/pdk
```

然后直接执行：

```bash
./scripts/check_handoff.sh
./scripts/check_backend_inputs.sh dc
./scripts/check_backend_inputs.sh fm
./scripts/check_backend_inputs.sh postsim
./scripts/check_backend_inputs.sh icc2
```

说明：

- 如果 `DC` 还没跑，`postsim/ICC2/Calibre` 对综合网表、SDF、GDS 的缺失提示是正常的
- 真正必须优先补齐的是库、tech、runset 这些静态输入

## 6. 推荐执行顺序

如果你想用最短命令，当前推荐路径直接改成：

```bash
make thesis-check
make thesis-synth
```

等价关系：

- `thesis-check`
  检查 EDA 工具环境、`SMIC40_PDK_ROOT`、`DiP` 静态输入
- `thesis-synth`
  跑 `ws/is/os legacy FIFO` 和 `dip std + gated_default`
- `thesis-dip`
  仍然保留为完整脚本入口，但当前 `SMIC40` 默认不把它作为正式主线，因为后端库格式还未打通
- `thesis-icc2-gui`
  仅在你已经补齐有效 Synopsys backend 包后再使用

如果 `run_icc2_probe.sh` 失败：

- 把本轮正式流程定义为截止到 `POSTSIM_SDF_MODE=dc ./scripts/run_postsim.sh`
- `ICC2 GUI` 标记为“待库格式适配”

如果 `make thesis-icc-probe` 失败：

- 这通常说明当前 `SMIC40` 目录里仍缺有效 `ICC` tech file，而不是 `Milkyway` 目录本身完全不存在
- 本轮结论仍然定义为“综合已通，自动数字后端待补 Synopsys backend deliverables”

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
