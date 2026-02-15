#!/bin/bash
#==============================================================================
# Vivado综合脚本
# 功能：运行Vivado综合Systolic阵列设计
#==============================================================================

PROJECT_DIR=~/systolic_array_edge
SCRIPT_DIR=${PROJECT_DIR}/script
REPORTS_DIR=${PROJECT_DIR}/reports

# 创建报告目录
mkdir -p ${REPORTS_DIR}

echo "=========================================="
echo "Systolic Array - Vivado Synthesis"
echo "=========================================="
echo ""

# 检查Vivado是否可用
if ! command -v vivado &> /dev/null; then
    echo "Error: Vivado not found!"
    echo "Please source Vivado settings first:"
    echo "  source /tools/Xilinx/Vivado/version/settings64.sh"
    exit 1
fi

echo "Vivado found: $(vivado -version | head -1)"
echo ""

# 运行TCL脚本
echo "Running synthesis..."
vivado -mode batch -source ${SCRIPT_DIR}/synthesize.tcl -nojournal -log ${REPORTS_DIR}/vivado.log

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Synthesis SUCCESSFUL"
    echo "=========================================="
    echo ""
    echo "Reports generated in: ${REPORTS_DIR}"
    ls -lh ${REPORTS_DIR}
else
    echo ""
    echo "=========================================="
    echo "Synthesis FAILED"
    echo "=========================================="
    echo ""
    echo "Check log file: ${REPORTS_DIR}/vivado.log"
    exit 1
fi

exit 0
