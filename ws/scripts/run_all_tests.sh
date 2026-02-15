#!/bin/bash
#==============================================================================
# 统一测试脚本：运行所有三种架构的验证
# WS - Weight Stationary, IS - Input Stationary, OS - Output Stationary
#==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
LOG_DIR="$PROJECT_ROOT/test_logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 创建日志目录
mkdir -p "$LOG_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Systolic Array 测试套件${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 测试结果统计
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

#==============================================================================
# 测试 WS (Weight Stationary)
#==============================================================================
echo -e "${YELLOW}测试 WS (Weight Stationary)...${NC}"
cd "$PROJECT_ROOT/ws/tb"

iverilog -g2012 -o sim_ws ../src/*.v systolic_array_ws_tb.v 2>&1 | tee "$LOG_DIR/ws_compile_$TIMESTAMP.log"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    vvp sim_ws 2>&1 | tee "$LOG_DIR/ws_test_$TIMESTAMP.log" | grep -E "(Test Case|✅|❌|Total Tests|Passed|Failed)"

    # 检查是否有失败
    if grep -q "Failed:      0" "$LOG_DIR/ws_test_$TIMESTAMP.log" || grep -q "ALL TESTS PASSED" "$LOG_DIR/ws_test_$TIMESTAMP.log"; then
        echo -e "${GREEN}✅ WS 测试通过${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}❌ WS 测试失败${NC}"
        ((FAILED_TESTS++))
    fi
else
    echo -e "${RED}❌ WS 编译失败${NC}"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))
echo ""

#==============================================================================
# 测试 IS (Input Stationary)
#==============================================================================
echo -e "${YELLOW}测试 IS (Input Stationary)...${NC}"
cd "$PROJECT_ROOT/is"

iverilog -g2012 -o sim_is src/*.v tb/*.v 2>&1 | tee "$LOG_DIR/is_compile_$TIMESTAMP.log"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    vvp sim_is 2>&1 | tee "$LOG_DIR/is_test_$TIMESTAMP.log" | grep -E "(Test Case|✅|❌|Total Tests|Passed|Failed)"

    # 检查是否有失败
    if grep -q "Failed:      0" "$LOG_DIR/is_test_$TIMESTAMP.log" || grep -q "ALL TESTS PASSED" "$LOG_DIR/is_test_$TIMESTAMP.log"; then
        echo -e "${GREEN}✅ IS 测试通过${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}❌ IS 测试失败${NC}"
        ((FAILED_TESTS++))
    fi
else
    echo -e "${RED}❌ IS 编译失败${NC}"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))
echo ""

#==============================================================================
# 测试 OS (Output Stationary)
#==============================================================================
echo -e "${YELLOW}测试 OS (Output Stationary)...${NC}"
cd "$PROJECT_ROOT/os"

iverilog -g2012 -o sim_os src/*.v tb/*.v 2>&1 | tee "$LOG_DIR/os_compile_$TIMESTAMP.log"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    vvp sim_os 2>&1 | tee "$LOG_DIR/os_test_$TIMESTAMP.log" | grep -E "(Test Case|✅|❌|Total Tests|Passed|Failed)"

    # 检查是否有失败
    if grep -q "Failed:      0" "$LOG_DIR/os_test_$TIMESTAMP.log" || grep -q "ALL TESTS PASSED" "$LOG_DIR/os_test_$TIMESTAMP.log"; then
        echo -e "${GREEN}✅ OS 测试通过${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}❌ OS 测试失败${NC}"
        ((FAILED_TESTS++))
    fi
else
    echo -e "${RED}❌ OS 编译失败${NC}"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))
echo ""

#==============================================================================
# 生成测试报告
#==============================================================================
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}         测试总结报告${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "时间戳: $TIMESTAMP"
echo -e "日志目录: $LOG_DIR"
echo ""
echo -e "总测试套件: $TOTAL_TESTS"
echo -e "${GREEN}通过: $PASSED_TESTS${NC}"
echo -e "${RED}失败: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✅✅✅ 所有测试通过！ ✅✅✅${NC}"
    exit 0
else
    echo -e "${RED}⚠️  部分测试失败${NC}"
    exit 1
fi
