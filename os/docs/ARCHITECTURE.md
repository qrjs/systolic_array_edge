# OS Dataflow Systolic Array

## 数据流类型

**输出驻留 (Output Stationary)**

部分和 C 在 PE 中累加，输入从上方流入，权重从左侧流入。

最适合全连接层场景。

## 目录结构

```
os/
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
cd os
iverilog -g2012 -o sim src/*.v tb/*.tb.v
vvp sim
```

### Vivado 综合

```bash
cd os/script
vivado -mode batch -source synthesize.tcl
```

## 文档

- 详细对比见 `DATAFLOW_COMPARISON.md`
