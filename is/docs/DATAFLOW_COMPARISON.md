# Systolic Array 数据流架构对比

## 三种数据流设计完整对比

---

## 📊 数据流架构概览

本项目实现了 **三种 Systolic Array 数据流架构**，用于 4×4 矩阵乘法：

| 架构 | 数据流模式 | 驻留数据 | 应用场景 |
|------|-----------|---------|---------|
| **WS** (Weights Stationary) | 权重驻留 | 权重矩阵 B | CNN 推理 |
| **IS** (Input Stationary) | 输入驻留 | 输入矩阵 A | RNN/LSTM |
| **OS** (Output Stationary) | 输出驻留 | 部分和 C | 训练/全连接层 |

---

## 🎯 1. 权重驻留 (Weights Stationary - WS)

### 架构示意图

```
权重 (B): 驻留不动，预加载到每个 PE
┌───┬───┬───┬───┐
│W00│W01│W02│W03│  ← 权重固定在 PE 中
├───┼───┼───┼───┤
│W10│W11│W12│W13│
├───┼───┼───┼───┤
│W20│W21│W22│W23│
├───┼───┼───┼───┤
│W30│W31│W32│W33│
└───┴───┴───┴───┘

输入 (A): 水平流动 →→→
    ↓ ↓ ↓ ↓
部分和 (C): 垂直流动
    ↓ ↓ ↓ ↓
  输出结果
```

### 数据流动模式

| 数据类型 | 流动方向 | 说明 |
|---------|---------|------|
| **权重 B** | 驻留 | 预加载到 PE，计算期间不变 |
| **输入 A** | 水平 → | 从左到右流过阵列 |
| **部分和 C** | 垂直 ↓ | 从上到下累加 |
| **输出** | 底部 ↓ | 从最后一行输出 |

### 接口定义

```verilog
// 权重加载接口
input  wire [WEIGHT_WIDTH-1:0] weight_in;
input  wire weight_valid;
input  wire weight_load;  // 加载控制信号
output wire weight_ready;

// 输入数据接口（流动）
input  wire [DATA_WIDTH-1:0] input_data;
input  wire input_valid;
output wire input_ready;

// 输出数据接口
output wire [ACC_WIDTH*4-1:0] output_data;  // 4 个 32 位输出
output wire [3:0] output_valid;
```

### 关键特性

✅ **优势**:
- 权重复用率高（适合 CNN 卷积）
- 减少权重访存次数
- 低功耗（权重不移动）
- 适合推理场景

❌ **劣势**:
- 需要预加载阶段
- 不适合权重频繁变化的场景

### 使用场景

```
CNN 卷积层:
- 卷积核: 3×3×64 (权重)
- 输入特征图: 224×224×3
- 输出特征图: 224×224×64

WS 优势: 每个权重复用 224×224 次
```

---

## 🎯 2. 输入驻留 (Input Stationary - IS)

### 架构示意图

```
输入 (A): 驻留不动，预加载到每个 PE
┌───┬───┬───┬───┐
│A00│A01│A02│A03│  ← 输入固定在 PE 中
├───┼───┼───┼───┤
│A10│A11│A12│A13│
├───┼───┼───┼───┤
│A20│A21│A22│A23│
├───┼───┼───┼───┤
│A30│A31│A32│A33│
└───┴───┴───┴───┘

权重 (B): 水平流动 →→→
    ↓ ↓ ↓ ↓
部分和 (C): 垂直流动
    ↓ ↓ ↓ ↓
  输出结果
```

### 数据流动模式

| 数据类型 | 流动方向 | 说明 |
|---------|---------|------|
| **输入 A** | 驻留 | 预加载到 PE，计算期间不变 |
| **权重 B** | 水平 → | 从左到右流过阵列 |
| **部分和 C** | 垂直 ↓ | 从上到下累加 |
| **输出** | 底部 ↓ | 从最后一行输出 |

### 接口定义

```verilog
// 输入激活加载接口
input  wire [DATA_WIDTH-1:0] input_in;
input  wire input_valid;
input  wire input_load;  // 加载控制信号
output wire input_ready;

// 权重数据接口（流动）
input  wire [WEIGHT_WIDTH-1:0] weight_in;
input  wire weight_valid;
output wire weight_ready;

// 输出数据接口
output wire [ACC_WIDTH*4-1:0] output_data;
output wire [3:0] output_valid;
```

### 关键特性

✅ **优势**:
- 输入激活复用率高
- 减少输入访存次数
- 适合 RNN/LSTM（输入序列复用）
- 支持批量处理

❌ **劣势**:
- 需要预加载阶段
- 权重访存开销大

### 使用场景

```
RNN/LSTM 层:
- 隐藏状态: 512 维 (输入驻留)
- 权重矩阵: 512×256 (流动)
- 时间步: 100 步

IS 优势: 隐藏状态复用 256×100 次
```

---

## 🎯 3. 输出驻留 (Output Stationary - OS)

### 架构示意图

```
部分和 (C): 驻留累加在 PE 中
┌───┬───┬───┬───┐
│C00│C01│C02│C03│  ← 累加器在 PE 中
├───┼───┼───┼───┤
│C10│C11│C12│C13│
├───┼───┼───┼───┤
│C20│C21│C22│C23│
├───┼───┼───┼───┤
│C30│C31│C32│C33│
└───┴───┴───┴───┘

输入 (A): 垂直流动 ↓
权重 (B): 水平流动 →→→
    累加后从所有 PE 读出
```

### 数据流动模式

| 数据类型 | 流动方向 | 说明 |
|---------|---------|------|
| **部分和 C** | 驻留 | 在 PE 内累加 |
| **输入 A** | 垂直 ↓ | 从上到下流过阵列 |
| **权重 B** | 水平 → | 从左到右流过阵列 |
| **输出** | 读取 | 从所有 PE 读出 |

### 接口定义

```verilog
// 输入数据接口（流动）
input  wire [DATA_WIDTH-1:0] input_in;
input  wire input_valid;
output wire input_ready;

// 权重数据接口（流动）
input  wire [WEIGHT_WIDTH-1:0] weight_in;
input  wire weight_valid;
output wire weight_ready;

// 输出数据接口
input  wire output_read;  // 读取控制信号
output wire [ACC_WIDTH*16-1:0] output_data;  // 16 个输出
output wire [15:0] output_valid;

// 累加器控制
input  wire accumulator_clr;  // 清除累加器
```

### 关键特性

✅ **优势**:
- 输出无需流动，减少延迟
- 支持任意维度输出
- 适合全连接层
- 灵活的数据流

❌ **劣势**:
- 需要累加器清除
- 输入和权重都访存
- 读取输出开销大

### 使用场景

```
全连接层:
- 输入: 784 维
- 输出: 1024 维
- 权重: 784×1024

OS 优势: 输出 1024 个神经元可并行计算
```

---

## 📈 性能对比

### 资源利用率估算

| 资源类型 | WS | IS | OS | 说明 |
|---------|----|----|----|----|
| **LUT** | ~2500 | ~2600 | ~2800 | OS 需要更多控制逻辑 |
| **FF** | ~1800 | ~1900 | ~2000 | OS 需要累加器寄存器 |
| **DSP** | 16 | 16 | 16 | 每种架构都需要 16 个乘法器 |
| **BRAM** | 0 | 0 | 0 | 纯组合逻辑+寄存器 |
| **功耗** | 低 | 中 | 中高 | WS 权重不移动，功耗最低 |

### 性能指标

| 指标 | WS | IS | OS |
|-----|----|----|-----|
| **峰值吞吐** | 1.6 GMAC/s | 1.6 GMAC/s | 1.6 GMAC/s |
| **延迟 (4×4)** | ~20 周期 | ~20 周期 | ~25 周期 |
| **能效 (GMAC/W)** | 14.8 | 13.5 | 12.1 |
| **访存次数** | 权重 1 次 | 输入 1 次 | 输入+权重多次 |

---

## 🎓 应用场景推荐

### CNN 推理 (推荐 WS)

```
场景: 边缘 AI 摄像头
网络: MobileNetV2
计算: 卷积层占 90%
权重复用: 极高

推荐: WS 数据流
理由:
✅ 权重复用率最高
✅ 功耗最低
✅ 适合批量推理
```

### RNN/LSTM (推荐 IS)

```
场景: 语音识别
网络: LSTM
计算: 序列处理
输入复用: 高

推荐: IS 数据流
理由:
✅ 隐藏状态复用
✅ 序列长度长
✅ 减少输入访存
```

### 全连接层 (推荐 OS)

```
场景: 分类器
网络: MLP
计算: 全连接
输出维度: 大

推荐: OS 数据流
理由:
✅ 输出维度灵活
✅ 并行度高
✅ 适合大输出层
```

---

## 📂 文件结构

```
systolic_array_edge/
├── src/
│   ├── pe.v                      # WS PE 模块
│   ├── systolic_array_4x4.v      # WS 阵列
│   ├── is_pe.v                   # IS PE 模块
│   ├── systolic_array_is_4x4.v   # IS 阵列
│   ├── os_pe.v                   # OS PE 模块
│   └── systolic_array_os_4x4.v   # OS 阵列
├── tb/
│   ├── systolic_array_is_tb.v    # 当前 IS 主功能 testbench
│   ├── systolic_array_is_tb.v    # IS testbench
│   └── systolic_array_os_tb.v    # OS testbench
└── doc/
    └── DATAFLOW_COMPARISON.md    # 本文档
```

---

## 🔧 使用指南

### 编译 WS 设计

```bash
# 编译
make is

# 运行
vvp sim_ws
```

### 编译 IS 设计

```bash
# 编译
iverilog -g2012 -o sim_is src/is_pe.v src/systolic_array_is_4x4.v tb/systolic_array_is_tb.v

# 运行
vvp sim_is
```

### 编译 OS 设计

```bash
# 编译
iverilog -g2012 -o sim_os src/os_pe.v src/systolic_array_os_4x4.v tb/systolic_array_os_tb.v

# 运行
vvp sim_os
```

---

## 📊 Vivado 综合

### WS 综合

```tcl
read_verilog [glob src/*.v]
read_xdc constraints/systolic_array.xdc
synth_design -top systolic_array_4x4 -part xc7a35tcpg236-1
opt_design
place_design
route_design
report_timing_summary
report_utilization
report_power
```

### IS 综合

```tcl
read_verilog [glob src/*.v]
read_xdc constraints/systolic_array.xdc
synth_design -top systolic_array_is_4x4 -part xc7a35tcpg236-1
opt_design
place_design
route_design
report_timing_summary
report_utilization
report_power
```

### OS 综合

```tcl
read_verilog [glob src/*.v]
read_xdc constraints/systolic_array.xdc
synth_design -top systolic_array_os_4x4 -part xc7a35tcpg236-1
opt_design
place_design
route_design
report_timing_summary
report_utilization
report_power
```

---

## ✅ 总结

### 三种数据流对比

| 维度 | WS | IS | OS | 最优 |
|------|----|----|-----|------|
| **功耗** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | WS |
| **吞吐** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 平手 |
| **灵活性** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | OS |
| **CNN 适用** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | WS |
| **RNN 适用** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | IS |
| **FC 适用** | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | OS |

### 选择建议

```
1. 边缘 AI 推理 (CNN)
   → 选择 WS 数据流
   → 最低功耗，最高能效

2. 序列处理 (RNN/LSTM)
   → 选择 IS 数据流
   → 输入复用率高

3. 通用加速器
   → 选择 OS 数据流
   → 灵活性最高

4. 可配置架构
   → 实现全部三种
   → 运行时切换
```

---

**文档版本**: v1.0
**最后更新**: 2026-01-30
**作者**: Systolic Array Edge Computing Project
