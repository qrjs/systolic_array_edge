# Systolic Array 边缘加速器 - 三种数据流架构

## 项目简介

本项目实现了三种Systolic Array数据流架构，用于边缘AI加速：

### 三种架构
- **WS (Weight Stationary)** - 权重复用数据流
- **IS (Input Stationary)** - 输入驻留数据流
- **OS (Output Stationary)** - 输出驻留数据流

## 目录结构

```
systolic_array_edge/
├── ws/                    # Weight Stationary 架构
│   ├── src/             # 设计代码
│   ├── tb/              # 测试代码
│   ├── scripts/         # 测试脚本
│   ├── tools/           # Python工具
│   ├── docs/            # 架构文档
│   └── tests/           # 测试向量
│
├── is/                    # Input Stationary 架构
│   ├── src/
│   ├── tb/
│   ├── scripts/
│   ├── tools/
│   ├── docs/
│   └── tests/
│
├── os/                    # Output Stationary 架构
│   ├── src/
│   ├── tb/
│   ├── scripts/
│   ├── tools/
│   ├── docs/
│   └── tests/
│
├── docs/                  # 共享文档
├── scripts/               # 共享脚本
├── tools/                 # 共享工具
├── tests/                 # 共享测试
└── reports/               # 综合报告
```

## 快速开始

### 测试单个架构
```bash
cd ws && bash scripts/run_ws_test.sh
cd is && bash scripts/run_is_test.sh
cd os && bash scripts/run_os_test.sh
```

### 运行所有测试
```bash
bash scripts/run_all_tests.sh
```

### 生成测试用例
```bash
# 为所有架构生成300个测试用例
python tools/generate_300_tests.py
```

## 测试覆盖

每种架构都有：
- **100个测试用例** - 20个固定模式 + 80个随机测试
- **Python Golden Model** - 精确的期望值计算
- **完整文档** - 架构说明、测试报告、覆盖率分析

## 测试结果

- **WS**: 12/12 核心测试通过 ✅
- **IS**: 12/12 核心测试通过 ✅
- **OS**: 12/12 核心测试通过 ✅
- **总计**: 36/36 通过 (100%)

## 文档

- `docs/TEST_REPORT_300.txt` - 300个测试用例完整报告
- `docs/TEST_COVERAGE_REPORT.md` - 测试覆盖率分析
- `ws/docs/` - WS架构详细文档
- `is/docs/` - IS架构详细文档
- `os/docs/` - OS架构详细文档

## 工具

- `tools/golden_model.py` - Golden Model参考实现
- `tools/generate_300_tests.py` - 测试用例生成器
- `tools/run_comprehensive_tests.py` - 综合测试工具

## 作者

Systolic Array 边缘加速器项目组

## 许可证

MIT License
