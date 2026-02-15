#!/bin/bash
#==============================================================================
// 将所有文件按三种架构分类整理
//==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
cd "$PROJECT_ROOT"

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║           将报告、脚本、Vivado工程按架构分类整理                   ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}步骤 1: 为各架构创建reports子目录${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for arch in ws is os; do
    mkdir -p $arch/reports
    mkdir -p $arch/vivado
    echo -e "${GREEN}✅ $arch/reports/ 和 $arch/vivado/ 创建完成${NC}"
done

echo ""

echo -e "${BLUE}步骤 2: 整理Vivado工程${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查各个vivado工程目录
vivado_dirs=$(find . -maxdepth 1 -type d -name "vivado_*" | sort)

for vivado_dir in $vivado_dirs; do
    dirname=$(basename $vivado_dir)

    # 根据工程名称判断归属
    if [[ "$dirname" == *"impl"* ]]; then
        # 这个可能是某个架构的实现工程
        echo "  📁 $dirname -> 需要确定归属"
    elif [[ "$dirname" == *"timing"* ]]; then
        echo "  📁 $dirname -> 通用，复制到各架构"
        # 复制到各架构的vivado目录
        for arch in ws is os; do
            cp -rn $vivado_dir/* $arch/vivado/ 2>/dev/null
        done
    elif [[ "$dirname" == "vivado_project"$ ]]; then
        echo "  📁 $dirname -> 主工程，复制到各架构"
        for arch in ws is os; do
            cp -rn $vivado_dir/* $arch/vivado/ 2>/dev/null
        done
    else
        echo "  📁 $dirname -> 复制到各架构"
        for arch in ws is os; do
            cp -rn $vivado_dir/* $arch/vivado/ 2>/dev/null
        done
    fi
done

echo -e "${GREEN}✅ Vivado工程整理完成${NC}"
echo ""

echo -e "${BLUE}步骤 3: 整理报告文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 复制综合报告到各架构
for arch in ws is os; do
    # 复制主要报告
    cp -n reports/FINAL_TIMING_REPORT.md $arch/reports/ 2>/dev/null
    cp -n reports/VIVADO_PERFORMANCE_EVALUATION_REPORT.md $arch/reports/ 2>/dev/null
    cp -n reports/PERFORMANCE_EVALUATION_SUMMARY.md $arch/reports/ 2>/dev/null
    cp -n reports/EVALUATION_HONEST_REPORT.md $arch/reports/ 2>/dev/null

    # 复制timing报告
    cp -n reports/timing_report.txt $arch/reports/ 2>/dev/null
    cp -n reports/utilization_report.txt $arch/reports/ 2>/dev/null
    cp -n reports/power_report.txt $arch/reports/ 2>/dev/null

    echo -e "${GREEN}✅ $arch/reports/ 报告复制完成${NC}"
done

echo ""

echo -e "${BLUE}步骤 4: 整理Vivado日志文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 将vivado日志复制到各架构
for arch in ws is os; do
    cp -n reports/*.log $arch/reports/ 2>/dev/null
done

echo -e "${GREEN}✅ Vivado日志复制完成${NC}"
echo ""

echo -e "${BLUE}步骤 5: 整理综合脚本${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 复制综合和vivado相关脚本到各架构
common_scripts="check_timing.tcl compare_dataflows.tcl optimize_synthesis.tcl synthesize.tcl run_vivado.sh install_vivado.sh Makefile"

for script in $common_scripts; do
    if [ -f "scripts/$script" ]; then
        for arch in ws is os; do
            cp -n scripts/$script $arch/scripts/ 2>/dev/null
        done
    fi
done

echo -e "${GREEN}✅ 综合脚本复制完成${NC}"
echo ""

echo -e "${BLUE}步骤 6: 整理性能分析脚本${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 复制性能分析脚本到各架构
if [ -f "scripts/performance_analysis.py" ]; then
    for arch in ws is os; do
        cp -n scripts/performance_analysis.py $arch/scripts/ 2>/dev/null
    done
fi

if [ -f "scripts/performance_comparison.py" ]; then
    for arch in ws is os; do
        cp -n scripts/performance_comparison.py $arch/scripts/ 2>/dev/null
    done
fi

echo -e "${GREEN}✅ 性能分析脚本复制完成${NC}"
echo ""

echo -e "${BLUE}步骤 7: 创建各架构的综合报告索引${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for arch in ws is os; do
    arch_name=""
    if [ "$arch" == "ws" ]; then
        arch_name="Weight Stationary"
    elif [ "$arch" == "is" ]; then
        arch_name="Input Stationary"
    elif [ "$arch" == "os" ]; then
        arch_name="Output Stationary"
    fi

    cat > $arch/reports/INDEX.md << EOF
# $arch_name ($arch) 综合报告索引

## 架构说明
本目录包含 $arch_name 架构的所有综合报告和Vivado工程文件。

## 目录结构
- 📄 Vivado工程文件位于 \`../vivado/\`
- 📄 综合报告文件位于当前目录

## 综合报告

### 时序报告
- \`timing_report.txt\` - 时序分析报告
- \`timing_final_check.txt\` - 最终时序检查
- \`timing_opt1.txt\` - 优化方案1时序
- \`timing_opt2.txt\` - 优化方案2时序

### 资源利用
- \`utilization_report.txt\` - 资源利用率报告
- \`utilization_final_check.txt\` - 最终资源检查

### 功耗分析
- \`power_report.txt\` - 功耗分析报告
- \`power_final_check.txt\` - 最终功耗检查

### 性能评估
- \`VIVADO_PERFORMANCE_EVALUATION_REPORT.md\` - 性能评估报告
- \`PERFORMANCE_EVALUATION_SUMMARY.md\` - 性能评估总结
- \`EVALUATION_HONEST_REPORT.md\` - 诚实评估报告

### 综合分析
- \`FINAL_TIMING_REPORT.md\` - 最终时序报告
- \`OPTIMIZATION_COMPARISON_REPORT.md\` - 优化对比报告
- \`METHODOLOGY.md\` - 方法论文档

## Vivado工程

\`\`\`
$arch/vivado/
├── systolic_array.xpr         # 主工程文件
├── systolic_array_syn.v       # 综合网表
└── ...
\`\`

## 日志文件
- \`vivado.log\` - Vivado运行日志
- \`vivado_impl.log\` - 实现运行日志
- \`vivado_opt.log\` - 优化运行日志

## 快速访问
\`\`\bash
# 查看时序报告
cat $arch/reports/timing_report.txt

# 查看资源利用率
cat $arch/reports/utilization_report.txt

# 查看性能评估
cat $arch/reports/VIVADO_PERFORMANCE_EVALUATION_REPORT.md

# 打开Vivado工程
cd $arch/vivado
vivado systolic_array.xpr &
\`\`

---
生成时间: $(date)
架构: $arch_name
EOF

    echo -e "${GREEN}✅ $arch/reports/INDEX.md 创建完成${NC}"
done

echo ""

echo -e "${BLUE}步骤 8: 创建各架构的脚本说明${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for arch in ws is os; do
    cat > $arch/scripts/README.md << 'EOF'
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
EOF

    echo -e "${GREEN}✅ $arch/scripts/README.md 创建完成${NC}"
done

echo ""

echo -e "${BLUE}步骤 9: 移动根目录的独立文档到docs/${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 移动项目说明文档
mv -f OPTIMIZATION_SUMMARY.md docs/ 2>/dev/null
mv -f PROJECT_SUMMARY.md docs/ 2>/dev/null
mv -f VIVADO_INSTALLATION_STEP_BY_STEP.md docs/ 2>/dev/null

echo -e "${GREEN}✅ 独立文档移动完成${NC}"
echo ""

echo -e "${BLUE}步骤 10: 清理根目录的临时文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 清理备份文件
rm -f vivado_*.backup.*
rm -f *.jou
rm -f *.log

echo -e "${GREEN}✅ 临时文件清理完成${NC}"
echo ""

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║              ✅ 报告、脚本、Vivado工程分类完成！                ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${GREEN}整理后的目录结构:${NC}"
echo ""

for arch in ws is os; do
    echo "📁 $arch/ (架构目录)"
    echo "   ├── src/         - 设计代码"
    echo "   ├── tb/          - 测试代码"
    echo "   ├── scripts/     - 脚本 ($(ls $arch/scripts/*.sh 2>/dev/null | wc -l)个)"
    echo "   ├── tools/       - Python工具 ($(ls $arch/tools/*.py 2>/dev/null | wc -l)个)"
    echo "   ├── docs/        - 架构文档 ($(ls $arch/docs/*.md 2>/dev/null | wc -l)个)"
    echo "   ├── tests/       - 测试向量"
    echo "   ├── reports/     - 综合报告 ($(ls $arch/reports/* 2>/dev/null | wc -l)个文件)"
    echo "   └── vivado/      - Vivado工程 ($(ls $arch/vivado/* 2>/dev/null | wc -l)个文件)"
    echo ""
done

echo "📁 根目录（共享内容）"
echo "   ├── docs/        - 共享文档"
echo "   ├── scripts/     - 共享脚本"
echo "   ├── tools/       - 共享工具"
echo "   ├── tests/       - 共享测试"
echo "   └── reports/     - 共享报告"
echo ""

echo -e "${YELLOW}文件分配统计:${NC}"
echo ""
for arch in ws is os; do
    echo "📊 $arch/:"
    echo "   报告文件: $(ls $arch/reports/*.txt $arch/reports/*.md 2>/dev/null | wc -l) 个"
    echo "   Vivado文件: $(ls $arch/vivado/* 2>/dev/null | wc -l) 个"
    echo "   脚本文件: $(ls $arch/scripts/*.* 2>/dev/null | wc -l) 个"
    echo ""
done

echo -e "${BLUE}快速使用指南:${NC}"
echo ""
echo "1️⃣  查看WS架构所有内容"
echo "   cd ws && ls -la"
echo ""
echo "2️⃣  查看WS综合报告"
echo "   cat ws/reports/INDEX.md"
echo ""
echo "3️⃣  查看WS Vivado工程"
echo "   cd ws/vivado && ls"
echo ""
echo "4️⃣  运行WS性能分析"
echo "   cd ws/scripts && python performance_analysis.py"
echo ""
