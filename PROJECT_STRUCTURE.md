# Systolic Array 项目结构

## 目录结构

```
systolic_array_edge/
├── docs/                          # 项目文档
│   ├── TEST_REPORT.md             # 测试报告
│   ├── TEST_COVERAGE_REPORT.md    # 测试覆盖率报告
│   ├── TESTING_README.md          # 测试使用说明
│   └── ...
│
├── scripts/                       # 测试和运行脚本
│   ├── run_all_tests.sh           # 运行所有测试
│   ├── run_golden_tests.sh        # 运行Golden Model测试
│   └── ...
│
├── tools/                         # Python工具
│   ├── golden_model.py            # Golden Model参考实现
│   ├── generate_300_tests.py     # 生成300个测试用例
│   └── ...
│
├── tests/                         # 测试相关
│   └── vectors/                   # 测试向量
│       ├── test_vectors_ws_100.json
│       ├── test_vectors_is_100.json
│       └── test_vectors_os_100.json
│
├── ws/                            # Weight Stationary 架构
│   ├── src/                       # 源代码
│   ├── tb/                        # Testbench
│   └── README.md                  # 架构说明
│
├── is/                            # Input Stationary 架构
│   ├── src/                       # 源代码
│   ├── tb/                        # Testbench
│   └── README.md                  # 架构说明
│
├── os/                            # Output Stationary 架构
│   ├── src/                       # 源代码
│   ├── tb/                        # Testbench
│   └── README.md                  # 架构说明
│
├── reports/                       # Vivado综合报告
│   └── ...
│
└── README.md                      # 项目主README

```

## 快速开始

### 运行测试
```bash
# 运行所有测试
bash scripts/run_all_tests.sh

# 运行单个架构测试
cd ws && bash run_ws_test.sh
cd is && bash run_is_test.sh
cd os && bash run_os_test.sh
```

### 生成测试用例
```bash
# 生成300个测试用例
python tools/generate_300_tests.py
```

## 文档说明

- **TEST_REPORT_300.txt**: 300个测试用例的完整报告
- **TEST_COVERAGE_REPORT.md**: 测试覆盖率详细分析
- **DATAFLOW_COMPARISON.md**: 三种数据流架构对比

## 工具说明

- **golden_model.py**: Python实现的参考模型，用于生成期望输出
- **generate_300_tests.py**: 自动生成300个测试用例
- **run_comprehensive_tests.py**: 综合测试生成器
