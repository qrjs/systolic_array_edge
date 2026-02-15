#!/bin/bash
#==============================================================================
# 显示最新测试结果的快速脚本
#==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
LOG_DIR="$PROJECT_ROOT/test_logs"

# 找到最新的日志文件
LATEST_WS=$(ls -t "$LOG_DIR"/ws_test_*.log 2>/dev/null | head -1)
LATEST_IS=$(ls -t "$LOG_DIR"/is_test_*.log 2>/dev/null | head -1)
LATEST_OS=$(ls -t "$LOG_DIR"/os_test_*.log 2>/dev/null | head -1)

echo -e "\033[0;34m========================================\033[0m"
echo -e "\033[0;34m      最新测试结果摘要\033[0m"
echo -e "\033[0;34m========================================\033[0m"
echo ""

# WS结果
if [ -n "$LATEST_WS" ]; then
    echo -e "\033[1;33mWS (Weight Stationary):\033[0m"
    grep "Total Tests\|Passed\|Failed\|ALL TESTS" "$LATEST_WS" | tail -4
    echo ""
fi

# IS结果
if [ -n "$LATEST_IS" ]; then
    echo -e "\033[1;33mIS (Input Stationary):\033[0m"
    grep "Total Tests\|Passed\|Failed\|ALL TESTS" "$LATEST_IS" | tail -4
    echo ""
fi

# OS结果
if [ -n "$LATEST_OS" ]; then
    echo -e "\033[1;33mOS (Output Stationary):\033[0m"
    grep "Total Tests\|Passed\|Failed\|ALL TESTS" "$LATEST_OS" | tail -4
    echo ""
fi

echo -e "\033[0;34m========================================\033[0m"
echo "详细日志: $LOG_DIR"
echo "完整报告: $PROJECT_ROOT/TEST_REPORT.md"
echo -e "\033[0;34m========================================\033[0m"
