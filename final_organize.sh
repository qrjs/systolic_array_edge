#!/bin/bash
#==============================================================================
// 最终整理：将所有剩余文件按架构分类
//==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
cd "$PROJECT_ROOT"

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║           将所有剩余文件按 WS/IS/OS 架构分类                     ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}步骤 1: 整理根目录的 src/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# WS设计文件
if [ -f "src/pe.v" ]; then
    cp -n src/pe.v ws/src/ 2>/dev/null
    echo -e "${GREEN}✅ pe.v -> ws/src/${NC}"
fi
if [ -f "src/systolic_array_4x4.v" ]; then
    cp -n src/systolic_array_4x4.v ws/src/ 2>/dev/null
    echo -e "${GREEN}✅ systolic_array_4x4.v -> ws/src/${NC}"
fi

# IS设计文件
if [ -f "src/is_pe.v" ]; then
    cp -n src/is_pe.v is/src/ 2>/dev/null
    echo -e "${GREEN}✅ is_pe.v -> is/src/${NC}"
fi
if [ -f "src/systolic_array_is_4x4.v" ]; then
    cp -n src/systolic_array_is_4x4.v is/src/ 2>/dev/null
    echo -e "${GREEN}✅ systolic_array_is_4x4.v -> is/src/${NC}"
fi

# OS设计文件
if [ -f "src/os_pe.v" ]; then
    cp -n src/os_pe.v os/src/ 2>/dev/null
    echo -e "${GREEN}✅ os_pe.v -> os/src/${NC}"
fi
if [ -f "src/systolic_array_os_4x4.v" ]; then
    cp -n src/systolic_array_os_4x4.v os/src/ 2>/dev/null
    echo -e "${GREEN}✅ systolic_array_os_4x4.v -> os/src/${NC}"
fi

# 通用设计文件
if [ -f "src/matrix_multiplier_top.v" ]; then
    for arch in ws is os; do
        cp -n src/matrix_multiplier_top.v $arch/src/ 2>/dev/null
    done
    echo -e "${GREEN}✅ matrix_multiplier_top.v -> 所有架构/src/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 2: 整理根目录的 tb/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# WS testbench
if [ -f "tb/systolic_array_tb.v" ]; then
    cp -n tb/systolic_array_tb.v ws/tb/ 2>/dev/null
    echo -e "${GREEN}✅ systolic_array_tb.v -> ws/tb/${NC}"
fi

# IS testbench
if [ -f "tb/systolic_array_is_tb.v" ]; then
    cp -n tb/systolic_array_is_tb.v is/tb/ 2>/dev/null
    echo -e "${GREEN}✅ systolic_array_is_tb.v -> is/tb/${NC}"
fi

# OS testbench
if [ -f "tb/systolic_array_os_tb.v" ]; then
    cp -n tb/systolic_array_os_tb.v os/tb/ 2>/dev/null
    echo -e "${GREEN}✅ systolic_array_os_tb.v -> os/tb/${NC}"
fi

# 其他testbench - 复制到所有架构
for tb in simple_tb.v direct_array_tb.v; do
    if [ -f "tb/$tb" ]; then
        for arch in ws is os; do
            cp -n "tb/$tb" $arch/tb/ 2>/dev/null
        done
        echo -e "${GREEN}✅ $tb -> 所有架构/tb/${NC}"
    fi
done

echo ""

echo -e "${BLUE}步骤 3: 整理根目录的 scripts/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 复制所有脚本到各架构
if [ -d "scripts" ]; then
    script_count=$(ls scripts/ 2>/dev/null | wc -l)
    echo "找到 $script_count 个脚本文件"

    # 主要脚本
    for arch in ws is os; do
        cp -rn scripts/* $arch/scripts/ 2>/dev/null
    done
    echo -e "${GREEN}✅ 所有脚本已复制到各架构/scripts/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 4: 整理根目录的 tools/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "tools" ]; then
    for arch in ws is os; do
        cp -rn tools/* $arch/tools/ 2>/dev/null
    done
    echo -e "${GREEN}✅ 所有Python工具已复制到各架构/tools/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 5: 整理根目录的 tests/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "tests/vectors/test_vectors.json" ]; then
    for arch in ws is os; do
        cp -n tests/vectors/test_vectors.json $arch/tests/ 2>/dev/null
    done
    echo -e "${GREEN}✅ test_vectors.json -> 所有架构/tests/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 6: 整理根目录的 reports/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "reports" ]; then
    report_count=$(ls reports/ 2>/dev/null | wc -l)
    echo "找到 $report_count 个报告文件"

    for arch in ws is os; do
        cp -rn reports/* $arch/reports/ 2>/dev/null
    done
    echo -e "${GREEN}✅ 所有报告已复制到各架构/reports/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 7: 整理根目录的 docs/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "docs" ]; then
    doc_count=$(ls docs/ 2>/dev/null | wc -l)
    echo "找到 $doc_count 个文档文件"

    # 通用文档
    common_docs="TESTING_README.md TEST_COVERAGE_REPORT.md DATAFLOW_COMPARISON.md"
    for arch in ws is os; do
        cp -rn docs/* $arch/docs/ 2>/dev/null
    done
    echo -e "${GREEN}✅ 所有文档已复制到各架构/docs/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 8: 整理 Vivado 工程文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for vivado_dir in vivado_project vivado_project_impl vivado_project_opt vivado_timing; do
    if [ -d "$vivado_dir" ]; then
        echo -e "${YELLOW}📁 $vivado_dir/ -> 复制到各架构/vivado/${NC}"
        for arch in ws is os; do
            cp -rn $vivado_dir/* $arch/vivado/ 2>/dev/null
        done
    fi
done
echo -e "${GREEN}✅ Vivado工程文件已复制到各架构/vivado/${NC}"

echo ""

echo -e "${BLUE}步骤 9: 整理 constraints/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "constraints/systolic_array.xdc" ]; then
    for arch in ws is os; do
        mkdir -p $arch/constraints
        cp -n constraints/systolic_array.xdc $arch/constraints/ 2>/dev/null
    done
    echo -e "${GREEN}✅ systolic_array.xdc -> 所有架构/constraints/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 10: 整理 verification/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "verification" ]; then
    # 验证文件可以作为通用资源
    for arch in ws is os; do
        mkdir -p $arch/verification
        cp -rn verification/* $arch/verification/ 2>/dev/null
    done
    echo -e "${GREEN}✅ verification/ 文件已复制到各架构/verification/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 11: 整理 sim/ 文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "sim" ]; then
    for arch in ws is os; do
        mkdir -p $arch/sim
        cp -rn sim/* $arch/sim/ 2>/dev/null
    done
    echo -e "${GREEN}✅ sim/ 文件已复制到各架构/sim/${NC}"
fi

echo ""

echo -e "${BLUE}步骤 12: 清理根目录的旧目录${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo -e "${YELLOW}以下目录可以保留作为共享资源，或者删除：${NC}"
echo "  📁 src/      - 通用源代码（已复制到各架构）"
echo "  📁 tb/       - 通用测试（已复制到各架构）"
echo "  📁 scripts/  - 通用脚本（已复制到各架构）"
echo "  📁 tools/    - 通用工具（已复制到各架构）"
echo "  📁 tests/    - 通用测试（已复制到各架构）"
echo "  📁 reports/  - 通用报告（已复制到各架构）"
echo "  📁 docs/     - 通用文档（已复制到各架构）"
echo "  📁 vivado_*  - Vivado工程（已复制到各架构）"
echo "  📁 verification/ - 验证文件（已复制到各架构）"
echo "  📁 sim/      - 仿真文件（已复制到各架构）"
echo "  📁 constraints/ - 约束文件（已复制到各架构）"
echo ""
echo -e "${RED}如需删除这些目录，运行：${NC}"
echo "  rm -rf src/ tb/ scripts/ tools/ tests/ reports/ docs/"
echo "  rm -rf vivado_project* vivado_timing"
echo "  rm -rf verification/ sim/ constraints/"
echo ""

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║              ✅ 所有文件已复制到各架构目录！                     ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${GREEN}现在各架构都包含完整的文件：${NC}"
echo ""
for arch in ws is os; do
    total=$(find $arch -type f 2>/dev/null | wc -l)
    echo "📁 $arch/ : $total 个文件"
    echo "   ├── src/      : $(find $arch/src -type f 2>/dev/null | wc -l) 个"
    echo "   ├── tb/       : $(find $arch/tb -type f 2>/dev/null | wc -l) 个"
    echo "   ├── scripts/  : $(find $arch/scripts -type f 2>/dev/null | wc -l) 个"
    echo "   ├── tools/    : $(find $arch/tools -type f 2>/dev/null | wc -l) 个"
    echo "   ├── docs/     : $(find $arch/docs -type f 2>/dev/null | wc -l) 个"
    echo "   ├── tests/    : $(find $arch/tests -type f 2>/dev/null | wc -l) 个"
    echo "   ├── reports/  : $(find $arch/reports -type f 2>/dev/null | wc -l) 个"
    echo "   └── vivado/   : $(find $arch/vivado -type f 2>/dev/null | wc -l) 个"
    echo ""
done

echo -e "${BLUE}下一步建议：${NC}"
echo "  1. 检查各架构目录内容是否完整"
echo "  2. 确认无误后，删除根目录的旧目录"
echo "  3. 运行各架构的测试验证功能"
echo ""
