# ASIC 前端完成清单

本文档面向后续标准单元后端流程，目标是把当前项目整理成“后端可直接接手”的状态，同时不影响现有 FPGA/仿真阶段成果。

---

## 1. 使用原则

- 不修改现有 `ws/is/os/dip` 的验证顶层行为。
- ASIC 交付物单独放在 `asic/` 目录。
- FPGA/XDC 与 ASIC/SDC 分离维护。
- 先完成可交付骨架，再逐步补 lint、CDC、综合脚本和正式交接包。

---

## 2. 当前状态

- [x] 四种数据流 RTL 已完成并可运行
- [x] 统一功能回归流程已建立
- [x] 综合流程与基础时序分析已建立
- [x] `IS/DIP` 已取得 core-only post-route 时序结果
- [x] 已新增 ASIC handoff 目录骨架
- [x] 已新增 ORFS/OpenROAD 开源后端入口骨架
- [x] 已新增商业 EDA 独立准备目录
- [ ] ASIC 专用综合脚本
- [ ] lint 报告清零
- [ ] CDC/RDC 结论固化
- [ ] ASIC full-chip 顶层与正式约束冻结
- [ ] 标准单元综合 netlist 交付

---

## 3. P0 必做项

### 3.1 ASIC 专用顶层

- [x] 为每个数据流新增独立 wrapper 顶层
- [x] 顶层与现有验证入口解耦
- [ ] 进一步收缩为最终 full-chip 交付端口
- [ ] 明确是否需要 SRAM/AXI/寄存器接口桥接

交付位置：

- `asic/ws/rtl/ws_core_top_4x4.v`
- `asic/is/rtl/is_core_top_4x4.v`
- `asic/os/rtl/os_core_top_4x4.v`
- `asic/dip/rtl/dip_core_top_4x4.v`

### 3.2 ASIC 约束文件

- [x] 为每个 wrapper 新增独立 `SDC`
- [x] 基本时钟、I/O 延迟、异步复位伪路径已补齐
- [ ] 根据真实后端接口修正外设到达/采样时序
- [ ] 根据工艺库和目标频率补充时钟不确定度/驱动假设

### 3.3 时钟与复位策略

- [x] 当前设计默认为单时钟
- [x] 当前复位为低有效异步复位
- [ ] 在论文与交付文档中固定为正式设计约定
- [ ] 若后续转同步复位，需要统一所有架构

---

## 4. P1 重要项

### 4.1 Lint

- [ ] 跑一轮系统级 lint
- [ ] 记录并分类 warning：位宽、未使用信号、潜在锁存器、组合环
- [ ] 严重告警清零

建议输出：

- `asic/reports/lint/<arch>_lint.rpt`
- `asic/reports/lint/<arch>_lint_waiver.md`

### 4.2 CDC / RDC

- [ ] 明确当前是否为单时钟单复位域
- [ ] 若维持单时钟，固化“无 CDC 风险”的结论
- [ ] 若引入异步接口，再补同步器与 CDC 规则

### 4.3 ASIC 综合交付

- [ ] 为每个架构固定顶层名、源文件列表、SDC
- [x] `DIP` 已补 `Yosys + Nangate45` 开源综合入口
- [x] `DIP` 已补 `ORFS/OpenROAD + Nangate45` 开源后端入口
- [ ] 固定一个主配置用于论文与后端
- [ ] 产出标准单元综合网表、时序报告、面积报告

建议固定主配置：

- `ARRAY_SIZE=4`
- `DATA_WIDTH=16`
- `WEIGHT_WIDTH=16`
- `ACC_WIDTH=32`

---

## 5. P2 建议项

### 5.1 接口交接文档

- [ ] 输出端口表：方向、位宽、时钟域、时序关系、功能说明
- [ ] 标记哪些信号是数据、控制、状态、低功耗相关

### 5.2 功耗分析激励

- [ ] 准备 dense 激励
- [ ] 准备 sparse 激励
- [ ] 准备 typical 激励
- [ ] 为后端功耗估计导出 `VCD/SAIF`

### 5.3 开源后端 bring-up

- [x] 为 `DIP` 建立 `OpenROAD-flow-scripts` 设计配置
- [x] 补充本地 ORFS / Docker ORFS 的运行脚本
- [ ] 在 `Nangate45` 上完成一轮从综合到布线的开源 PPA 结果
- [ ] 视时间切换到更真实的开源 PDK（如 `sky130`）

### 5.4 论文对齐

- [ ] 统一论文中使用的顶层名称和口径
- [ ] 区分“FPGA OOC post-route”与“ASIC full-chip 后端”
- [ ] 固化创新点与局限性表述

---

## 6. 推荐推进顺序

1. 使用 `asic/<arch>/` 中的 wrapper + `SDC` 作为后端入口
2. 固定主配置与目标频率
3. 跑 lint，清理高优先级 warning
4. 跑 ASIC 综合，拿到标准单元网表与初始时序
5. 补接口文档和激励文件
6. 再进入 place & route / CTS / IR / 功耗分析

开源流可先用：

1. `Yosys + Nangate45` 做标准单元综合
2. `OpenROAD-flow-scripts + Nangate45` 做第一版 RTL-to-GDS bring-up
3. 跑通后再切 `sky130` 或商业工艺

---

## 7. 当前建议的后端入口

优先从已经较稳定的架构开始：

1. `IS`
2. `DIP`
3. `WS`
4. `OS`

原因：

- `IS/DIP` 已经完成了 core-only post-route 时序清理，更适合作为第一批后端练手对象。
- `WS/OS` 的 ASIC handoff 已建好，但还未做同等深度的后端时序收敛。

---

## 8. 相关目录

- ASIC handoff 根目录：`asic/`
- OpenROAD 开源后端入口：`asic/flows/openroad/`
- 商业 EDA 准备目录：`asic_commercial/`
- 论文大纲：`docs/论文大纲_面向边缘计算脉动阵列_CN.md`
- 统一 Makefile 文档：`docs/统一Makefile与仿真综合使用说明_CN.md`
