#!/bin/bash
#==============================================================================
# 增强版测试脚本：运行所有三种架构的增强验证（8个测试用例）
//==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
LOG_DIR="$PROJECT_ROOT/test_logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# 创建日志目录
mkdir -p "$LOG_DIR"

echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}      ${BLUE}Systolic Array 增强版测试套件${NC}      ${MAGENTA}║${NC}"
echo -e "${MAGENTA}║${NC}         8 Test Cases per Architecture          ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 测试结果统计
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

#==============================================================================
# 测试 WS (Weight Stationary)
#==============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}测试 WS (Weight Stationary) - 增强版...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
cd "$PROJECT_ROOT/ws/tb"

iverilog -g2012 -o sim_ws_enhanced ../../ws/src/*.v systolic_array_ws_enhanced_tb.v 2>&1 | tee "$LOG_DIR/ws_enhanced_compile_$TIMESTAMP.log"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    vvp sim_ws_enhanced 2>&1 | tee "$LOG_DIR/ws_enhanced_test_$TIMESTAMP.log"
    echo ""

    # 检查是否有失败
    if grep -q "Failed:      0" "$LOG_DIR/ws_enhanced_test_$TIMESTAMP.log" || grep -q "ALL TESTS PASSED" "$LOG_DIR/ws_enhanced_test_$TIMESTAMP.log"; then
        WS_PASSED=$(grep "Passed:" "$LOG_DIR/ws_enhanced_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo -e "${GREEN}✅ WS 测试通过 ($WS_PASSED/8)${NC}"
        ((PASSED_TESTS++))
    else
        WS_FAILED=$(grep "Failed:" "$LOG_DIR/ws_enhanced_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo -e "${RED}❌ WS 测试失败 ($WS_FAILED/8)${NC}"
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
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}测试 IS (Input Stationary) - 增强版...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
cd "$PROJECT_ROOT/is/tb"

iverilog -g2012 -o sim_is_enhanced ../../is/src/*.v systolic_array_is_enhanced_tb.v 2>&1 | tee "$LOG_DIR/is_enhanced_compile_$TIMESTAMP.log"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    vvp sim_is_enhanced 2>&1 | tee "$LOG_DIR/is_enhanced_test_$TIMESTAMP.log"
    echo ""

    if grep -q "Failed:      0" "$LOG_DIR/is_enhanced_test_$TIMESTAMP.log" || grep -q "ALL TESTS PASSED" "$LOG_DIR/is_enhanced_test_$TIMESTAMP.log"; then
        IS_PASSED=$(grep "Passed:" "$LOG_DIR/is_enhanced_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo -e "${GREEN}✅ IS 测试通过 ($IS_PASSED/8)${NC}"
        ((PASSED_TESTS++))
    else
        IS_FAILED=$(grep "Failed:" "$LOG_DIR/is_enhanced_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo -e "${RED}❌ IS 测试失败 ($IS_FAILED/8)${NC}"
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
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}测试 OS (Output Stationary) - 增强版...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
cd "$PROJECT_ROOT/os/tb"

iverilog -g2012 -o sim_os_enhanced ../../os/src/*.v systolic_array_os_enhanced_tb.v 2>&1 | tee "$LOG_DIR/os_enhanced_compile_$TIMESTAMP.log"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    vvp sim_os_enhanced 2>&1 | tee "$LOG_DIR/os_enhanced_test_$TIMESTAMP.log"
    echo ""

    if grep -q "Failed:      0" "$LOG_DIR/os_enhanced_test_$TIMESTAMP.log" || grep -q "ALL TESTS PASSED" "$LOG_DIR/os_enhanced_test_$TIMESTAMP.log"; then
        OS_PASSED=$(grep "Passed:" "$LOG_DIR/os_enhanced_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo -e "${GREEN}✅ OS 测试通过 ($OS_PASSED/8)${NC}"
        ((PASSED_TESTS++))
    else
        OS_FAILED=$(grep "Failed:" "$LOG_DIR/os_enhanced_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo -e "${RED}❌ OS 测试失败 ($OS_FAILED/8)${NC}"
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
echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}           ${BLUE}增强版测试总结报告${NC}            ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
echo -e "时间戳: $TIMESTAMP"
echo -e "日志目录: $LOG_DIR"
echo ""
echo -e "总测试套件: $TOTAL_TESTS"
echo -e "${GREEN}通过: $PASSED_TESTS${NC}"
echo -e "${RED}失败: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}         ${WHITE}✅✅✅ 24/24 测试全部通过！ ✅✅✅${NC}         ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}测试覆盖率：${NC}"
    echo -e "  ✅ 单位矩阵测试"
    echo -e "  ✅ 常量矩阵测试"
    echo -e "  ✅ 零值边界测试"
    echo -e "  ✅ 对角矩阵测试"
    echo -e "  ✅ 随机矩阵测试"
    echo -e "  ✅ 累加功能测试"
    echo -e "  ✅ 最大值边界测试"
    echo -e "  ✅ 交替模式测试"
    exit 0
else
    echo -e "${RED}⚠️  部分测试失败${NC}"
    echo ""
    echo -e "请查看详细日志："
    echo -e "  WS: $LOG_DIR/ws_enhanced_test_$TIMESTAMP.log"
    echo -e "  IS: $LOG_DIR/is_enhanced_test_$TIMESTAMP.log"
    echo -e "  OS: $LOG_DIR/os_enhanced_test_$TIMESTAMP.log"
    exit 1
fi
