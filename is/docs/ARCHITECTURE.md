# IS Dataflow Systolic Array

## 数据流类型

**输入驻留 (Input Stationary)**

输入矩阵 A 预加载到 PE 中，权重矩阵 B 从左侧流入，结果从底部流出。

最适合 RNN/LSTM 场景。

## 目录结构

```
is/
├── src/                    # 源代码
├── tb/                     # 测试文件
├── constraints/            # 时序约束
├── script/                 # 综合/验证脚本
├── reports/                # 综合/验证报告
├── doc/                    # 文档
└── verification/           # Golden Model 验证
```

## 快速开始

### 仿真验证

```bash
cd is
iverilog -g2012 -o sim src/*.v tb/*.tb.v
vvp sim
```

### Vivado 综合

```bash
cd is/script
vivado -mode batch -source synthesize.tcl
```

## 文档

- [详细说明](../doc/DATAFLOW_COMPARISON.md)
