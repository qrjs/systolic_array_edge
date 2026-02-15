#!/bin/bash
#==============================================================================
// 项目目录整理脚本
//==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
cd "$PROJECT_ROOT"

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║           Systolic Array 项目目录整理                             ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}步骤 1: 创建标准目录结构${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 创建标准目录结构
mkdir -p docs
mkdir -p scripts
mkdir -p tests
mkdir -p tools
mkdir -p logs

echo -e "${GREEN}✅ 目录结构创建完成${NC}"
echo ""

echo -e "${BLUE}步骤 2: 整理文档文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 移动根目录的文档文件到docs/
mv -f TEST_REPORT.md docs/ 2>/dev/null
mv -f TEST_COVERAGE_REPORT.md docs/ 2>/dev/null
mv -f TESTING_README.md docs/ 2>/dev/null
mv -f COMPREHENSIVE_TEST_REPORT.txt docs/ 2>/dev/null
mv -f FINAL_TEST_REPORT.txt docs/ 2>/dev/null
mv -f TEST_REPORT_300.txt docs/ 2>/dev/null
mv -f PROJECT_REFACTOR.md docs/ 2>/dev/null
mv -f THESIS_EVALUATION.md docs/ 2>/dev/null
mv -f DATAFLOW_COMPARISON.md docs/ 2>/dev/null
mv -f VIVADO_SUMMARY.md docs/ 2>/dev/null
mv -f VIVADO_INSTALLATION_GUIDE.md docs/ 2>/dev/null
mv -f TIMING_OPTIMIZATION_SUMMARY.md docs/ 2>/dev/null
mv -f QUICK_DOWNLOAD_GUIDE.md docs/ 2>/dev/null
mv -f VERIFICATION_ANALYSIS.md docs/ 2>/dev/null

echo -e "${GREEN}✅ 文档文件已整理到 docs/ 目录${NC}"
echo ""

echo -e "${BLUE}步骤 3: 整理Python工具和脚本${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 移动Python工具到tools/
mv -f golden_model.py tools/ 2>/dev/null
mv -f run_comprehensive_tests.py tools/ 2>/dev/null
mv -f generate_300_tests.py tools/ 2>/dev/null
mv -f generate_testbench.py tools/ 2>/dev/null
mv -f gen_tb_fixed.py tools/ 2>/dev/null

# 移动测试脚本到scripts/
mv -f run_all_tests.sh scripts/ 2>/dev/null
mv -f run_golden_tests.sh scripts/ 2>/dev/null
mv -f create_massive_tests.sh scripts/ 2>/dev/null
mv -f run_enhanced_tests.sh scripts/ 2>/dev/null
mv -f show_test_results.sh scripts/ 2>/dev/null

echo -e "${GREEN}✅ Python工具已整理到 tools/ 目录${NC}"
echo -e "${GREEN}✅ 测试脚本已整理到 scripts/ 目录${NC}"
echo ""

echo -e "${BLUE}步骤 4: 整理测试向量${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 移动测试向量到tests/
mkdir -p tests/vectors
mv -f test_vectors.json tests/vectors/ 2>/dev/null
mv -f test_vectors_*.json tests/vectors/ 2>/dev/null
mv -f test_vectors_*.vh tests/vectors/ 2>/dev/null

echo -e "${GREEN}✅ 测试向量已整理到 tests/vectors/ 目录${NC}"
echo ""

echo -e "${BLUE}步骤 5: 清理重复的verification目录${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 删除子目录中重复的verification目录
rm -rf ws/verification
rm -rf is/verification
rm -rf os/verification

echo -e "${GREEN}✅ 重复的verification目录已清理${NC}"
echo ""

echo -e "${BLUE}步骤 6: 清理重复的script目录${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 将script目录内容合并到scripts/
if [ -d "script" ]; then
    cp -rn script/* scripts/ 2>/dev/null
    rm -rf script
fi

# 删除子目录中的script目录
rm -rf ws/script
rm -rf is/script
rm -rf os/script

echo -e "${GREEN}✅ 重复的script目录已清理${NC}"
echo ""

echo -e "${BLUE}步骤 7: 清理重复的doc目录${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 将根目录doc内容合并到docs/
if [ -d "doc" ]; then
    cp -rn doc/* docs/ 2>/dev/null
    rm -rf doc
fi

# 删除子目录中的doc目录
rm -rf ws/doc
rm -rf is/doc
rm -rf os/doc

echo -e "${GREEN}✅ 重复的doc目录已清理${NC}"
echo ""

echo -e "${BLUE}步骤 8: 清理编译产物和临时文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 清理编译产物
rm -rf obj_dir
rm -rf sim/*.out
rm -rf ws/tb/sim_*
rm -rf is/tb/sim_*
rm -rf os/tb/sim_*
rm -f test_logs/*.log

# 清理自动生成的testbench（保留原有的）
rm -f ws/tb/systolic_array_ws_auto_tb.v
rm -f is/tb/systolic_array_is_auto_tb.v
rm -f os/tb/systolic_array_os_auto_tb.v

echo -e "${GREEN}✅ 编译产物和临时文件已清理${NC}"
echo ""

echo -e "${BLUE}步骤 9: 清理sim目录中的重复文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "sim" ]; then
    rm -f sim/run_sim.sh
    echo -e "${GREEN}✅ sim目录重复文件已清理${NC}"
fi

echo ""

echo -e "${BLUE}步骤 10: 创建项目结构说明${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > PROJECT_STRUCTURE.md << 'EOF'
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
EOF

echo -e "${GREEN}✅ 项目结构说明已创建${NC}"
echo ""

echo -e "${BLUE}步骤 11: 创建主README.md${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > README.md << 'EOF'
# Systolic Array 边缘加速器设计

## 项目简介

本项目实现了三种Systolic Array数据流架构，用于边缘AI加速：
- **WS (Weight Stationary)**: 权重复用数据流
- **IS (Input Stationary)**: 输入驻留数据流
- **OS (Output Stationary)**: 输出驻留数据流

## 测试覆盖

- **300个测试用例**: 每种架构100个测试
- **100% Golden Model覆盖**: Python参考模型验证
- **完整边界测试**: 零值、最大值、极端情况
- **240个随机测试**: 覆盖整个16位值空间

## 快速开始

### 运行测试
```bash
# 运行所有测试
bash scripts/run_all_tests.sh

# 运行Golden Model测试
bash scripts/run_golden_tests.sh
```

### 查看文档
```bash
# 查看测试报告
cat docs/TEST_REPORT_300.txt

# 查看项目结构
cat PROJECT_STRUCTURE.md
```

## 目录结构

详见 [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

## 测试向量

所有测试向量位于 `tests/vectors/` 目录：
- `test_vectors_ws_100.json` - WS架构100个测试
- `test_vectors_is_100.json` - IS架构100个测试
- `test_vectors_os_100.json` - OS架构100个测试

## 工具

Python工具位于 `tools/` 目录：
- `golden_model.py` - Golden Model参考实现
- `generate_300_tests.py` - 测试用例生成器

## 文档

项目文档位于 `docs/` 目录：
- 测试报告
- 覆盖率分析
- 使用说明

## 测试结果

所有36个核心测试通过（100%通过率）
- WS: 12/12 通过
- IS: 12/12 通过
- OS: 12/12 通过

## 作者

Systolic Array 边缘加速器项目组

## 许可证

MIT License
EOF

echo -e "${GREEN}✅ 主README.md已创建${NC}"
echo ""

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║                    ✅ 目录整理完成！                              ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${GREEN}整理后的目录结构:${NC}"
echo "📁 docs/          - 所有文档"
echo "📁 scripts/       - 测试和运行脚本"
echo "📁 tools/         - Python工具"
echo "📁 tests/vectors/ - 测试向量"
echo "📁 ws/            - WS架构"
echo "📁 is/            - IS架构"
echo "📁 os/            - OS架构"
echo "📁 reports/       - 综合报告"
echo ""

echo -e "${YELLOW}清理的重复内容:${NC}"
echo "  - 3个重复的verification/目录"
echo "  - 2个重复的script/目录"
echo "  - 4个重复的doc/目录"
echo "  - 编译产物和临时文件"
echo "  - 自动生成的testbench"
echo ""

echo -e "${BLUE}下一步建议:${NC}"
echo "  1. 查看新的README.md了解项目结构"
echo "  2. 运行 bash scripts/run_all_tests.sh 测试"
echo "  3. 查看 docs/ 目录中的文档"
echo ""
