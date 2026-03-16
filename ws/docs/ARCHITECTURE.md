# WS Dataflow Systolic Array

## 数据流类型

**权重驻留 (Weights Stationary)**

权重矩阵 B 预加载到 PE 中，输入矩阵 A 从左侧流入，结果从底部流出。

最适合 CNN 推理场景。

## 目录结构

```
ws/
├── src/                    # 源代码
├── tb/                     # 测试文件
├── constraints/            # 时序约束
├── scripts/                # 综合/验证脚本
├── reports/                # 综合/验证报告
├── docs/                   # 文档
└── tb/                     # 当前保留的主功能 / 波形 / 文件回归 testbench
```

## 快速开始

### 仿真验证

```bash
cd ws
iverilog -g2012 -o sim src/*.v tb/*.tb.v
vvp sim
```

### Vivado 综合

```bash
cd ws/script
vivado -mode batch -source synthesize.tcl
```

## 文档

- 详细对比见 `DATAFLOW_COMPARISON.md`
