#!/bin/bash
#==============================================================================
// OS (Output Stationary) 架构独立测试脚本
//==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/test_logs"
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
echo -e "${MAGENTA}║${NC}      ${BLUE}OS (Output Stationary) 架构测试${NC}       ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

cd "$SCRIPT_DIR/tb"

# 编译
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}编译 OS 设计...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

iverilog -g2012 -o sim_os ../../os/src/*.v systolic_array_os_tb.v 2>&1 | tee "$LOG_DIR/os_compile_$TIMESTAMP.log"

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✅ 编译成功${NC}"
    echo ""

    # 运行测试
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}运行 OS 测试 (12个测试用例)...${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    vvp sim_os 2>&1 | tee "$LOG_DIR/os_test_$TIMESTAMP.log"

    # 检查结果
    if grep -q "ALL TESTS PASSED" "$LOG_DIR/os_test_$TIMESTAMP.log"; then
        PASSED=$(grep "Passed:" "$LOG_DIR/os_test_$TIMESTAMP.log" | tail -1 | awk '{print $2}')
        echo ""
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}      ${WHITE}✅✅✅ $PASSED/12 OS 测试全部通过！ ✅✅✅${NC}      ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${BLUE}测试覆盖:${NC}"
        echo -e "  ✅ 基础功能 (单位矩阵、常量矩阵)"
        echo -e "  ✅ 边界条件 (零值、最大值、最小值)"
        echo -e "  ✅ 极端情况 (255×255累加、混合值)"
        echo -e "  ✅ 功能特性 (Flush、累加器清除、连续运算)"
        echo ""
        echo -e "${BLUE}日志文件: $LOG_DIR/os_test_$TIMESTAMP.log${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}❌ 部分测试失败${NC}"
        echo -e "${RED}查看日志: $LOG_DIR/os_test_$TIMESTAMP.log${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ 编译失败${NC}"
    echo -e "${RED}查看日志: $LOG_DIR/os_compile_$TIMESTAMP.log${NC}"
    exit 1
fi
