# Weight Stationary (ws) 综合报告索引

## 架构说明
本目录包含 Weight Stationary 架构的所有综合报告和Vivado工程文件。

## 目录结构
- 📄 Vivado工程文件位于 `../vivado/`
- 📄 综合报告文件位于当前目录

## 综合报告

### 时序报告
- `timing_report.txt` - 时序分析报告
- `timing_final_check.txt` - 最终时序检查
- `timing_opt1.txt` - 优化方案1时序
- `timing_opt2.txt` - 优化方案2时序

### 资源利用
- `utilization_report.txt` - 资源利用率报告
- `utilization_final_check.txt` - 最终资源检查

### 功耗分析
- `power_report.txt` - 功耗分析报告
- `power_final_check.txt` - 最终功耗检查

### 性能评估
- `VIVADO_PERFORMANCE_EVALUATION_REPORT.md` - 性能评估报告
- `PERFORMANCE_EVALUATION_SUMMARY.md` - 性能评估总结
- `EVALUATION_HONEST_REPORT.md` - 诚实评估报告

### 综合分析
- `FINAL_TIMING_REPORT.md` - 最终时序报告
- `OPTIMIZATION_COMPARISON_REPORT.md` - 优化对比报告
- `METHODOLOGY.md` - 方法论文档

## Vivado工程

```
ws/vivado/
├── systolic_array.xpr         # 主工程文件
├── systolic_array_syn.v       # 综合网表
└── ...
``

## 日志文件
- `vivado.log` - Vivado运行日志
- `vivado_impl.log` - 实现运行日志
- `vivado_opt.log` - 优化运行日志

## 快速访问
``\bash
# 查看时序报告
cat ws/reports/timing_report.txt

# 查看资源利用率
cat ws/reports/utilization_report.txt

# 查看性能评估
cat ws/reports/VIVADO_PERFORMANCE_EVALUATION_REPORT.md

# 打开Vivado工程
cd ws/vivado
vivado systolic_array.xpr &
``

---
生成时间: 2026年 01月 30日 星期五 18:28:28 CST
架构: Weight Stationary
