# 项目目录地图

这份文档只解决一个问题：目录太多时，先看哪里，不用看哪里。

## 1. 你平时真正需要碰的入口

- 根目录 `Makefile`
  日常总入口。优先使用 `make help`、`make txt`、`make run ARCH=ws`、
  `make thesis-check`、`make thesis-dip` 这些顶层命令。
- 根目录 `README.md`
  总览、上手顺序、常用命令。
- `docs/`
  中文导读、论文口径、验证状态说明。
- `docs/论文材料索引与版图状态_CN.md`
  论文写作时的证据索引，包含版图完整性、IO pad ring、VDD/VSS 和流片缺口说明。

结论很简单：

- 想跑东西，先用根目录 `make`
- 想理解仓库，先读 `README.md` 和 `docs/`
- 不要一上来钻进 `asic_commercial/*/scripts/`

## 2. 源码区

- `ws/` `is/` `os/` `dip/`
  四种数据流的前端主目录。
- `src/`
  RTL 源码。
- `tb/`
  对应架构测试平台。
- `constraints/`
  FPGA/Vivado 或综合约束。
- `scripts/`
  架构级轻量脚本，多用于被顶层 `Makefile` 调用。

推荐阅读顺序：

1. `ws/src/standard_ws_array_4x4.v`
2. `is/src/standard_is_array_4x4.v`
3. `os/src/standard_os_array_4x4.v`
4. `dip/src/standard_dip_array_4x4.v`

## 3. 验证与公共资源

- `tb/common/`
  公共 TB 辅助模块。
- `test_vectors/`
  固定向量、随机向量和批量回归向量。
- `utils/`
  Python 辅助脚本，负责向量生成、回归、指标抽取和汇总。
- `common/`
  跨模块复用的 RTL。

## 4. 后端与论文流

- `asic/`
  开源 ASIC handoff、OpenROAD 相关内容。
- `asic_commercial/`
  商业 EDA runset，总体上分为三层：

  - `asic_commercial/scripts/`
    商业环境公共入口，例如 thesis 检查和综合。
  - `asic_commercial/syn/`
    多架构商业综合对比。
  - `asic_commercial/ws|is|os|dip/`
    分架构商业流程目录，内部会有 `config/`、`scripts/`、`results/` 等子目录。

对大多数使用场景，不需要直接记内部脚本名，只记这些顶层入口：

- `make thesis-check`
- `make thesis-synth`
- `make thesis-dip-gated-opt`
- `make thesis-dip`
- `make thesis-is`
- `make thesis-os`
- `make thesis-dio`
- `make thesis-innovus-gui`
- `make thesis-virtuoso`

## 5. 文档与展示材料

- `docs/`
  正式说明文档。
- `slides/`
  汇报材料和渲染图。
- `ARCHITECTURE_VALIDATION_AND_PERFORMANCE.md`
  架构验证和性能说明。
- `DATAFLOW_VALIDATION_STATUS_CN.md`
  当前验证状态汇总。

## 6. 本地环境与非源码目录

- `TSMC28/`
  本地工艺库投放区。它是环境资产，不是仓库核心源码。
- `results/`
  开源流程或实验结果输出。
- `reports/`
  自动生成的实验报告。论文优先看 `reports/thesis/README.md` 和 `reports/thesis/summary.md`。
- `work/`
  本地工作区，专门存放整理后的生成物。
  其中 `work/thesis_materials/latest/` 可由 `make thesis-workspace` 生成，集中放论文常用报告、文档和版图链接。

## 7. 现在为什么会觉得乱

主要有三种“脚本很多”的来源：

- 顶层 `Makefile` 已经提供统一入口，但低层脚本仍然全部保留，所以视觉上很多。
- `asic_commercial/ws|is|os|dip/` 每套流程都有一组相似脚本。
- 一些工具产物会直接掉到仓库根目录，让源码区和工作区混在一起。

## 8. 整理后的使用习惯

建议以后只按这套习惯工作：

1. 日常命令只从根目录 `make` 进入。
2. 查源码只在 `ws/is/os/dip + tb + utils + docs` 这几块活动。
3. 商业流只看 `asic_commercial/README.md` 和对应 flow 的 `README.md`。
4. 根目录一旦出现 `*.mr`、`*-verilog.syn`、`innovus.log`、`icc2_output.txt` 之类文件，执行：

```bash
make tidy-workspace
```

这个命令会把根目录误落下来的生成物收拢到：

```text
work/root_artifacts/<timestamp>/
```
