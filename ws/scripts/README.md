# 测试和运行脚本

## 测试脚本

### 单架构测试
```bash
# 运行本架构测试
bash run_${arch}_test.sh
```

### 综合测试
```bash
# 运行所有架构测试
bash run_all_tests.sh

# 运行Golden Model测试
bash run_golden_tests.sh
```

## 性能分析脚本

### 性能对比
```bash
# 性能对比分析
python performance_comparison.py
```

### 性能分析
```bash
# 详细性能分析
python performance_analysis.py
```

## Vivado相关脚本

### 时序检查
```bash
tclsh check_timing.tcl
```

### 综合脚本
```bash
# 综合设计
bash Makefile

# 运行Vivado综合
bash run_vivado.sh
```

## 使用说明
所有脚本都配置为在 \`../src/\` 和 \`../tb/\` 目录中运行。
