#!/bin/bash
# ==============================================================================
# Run ICC2 for All Three Architectures
# ==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
SCRIPT_DIR="${PROJECT_ROOT}/pnr/scripts"

# Array of architectures
ARCHS=("is" "os" "ws")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo "IC Compiler II for Systolic Array"
echo "SMIC40 40nm PDK"
echo -e "========================================${NC}"

for arch in "${ARCHS[@]}"; do
    echo -e "${YELLOW}Starting ICC2 for: $arch${NC}"
    echo "========================================"

    cd ${SCRIPT_DIR}

    MODE=$arch icc2_shell -f run_icc2.tcl | tee icc2_${arch}.log

    # Check if ICC2 was successful
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✓ ICC2 completed for: $arch${NC}"
    else
        echo -e "${RED}✗ ICC2 failed for: $arch${NC}"
        echo "Check log file: ${SCRIPT_DIR}/icc2_${arch}.log"
    fi

    echo ""
done

echo -e "${BLUE}========================================"
echo "All ICC2 runs completed!"
echo "========================================"
echo "Check results in: ${PROJECT_ROOT}/pnr/outputs/"
echo "Check reports in: ${PROJECT_ROOT}/pnr/reports/"
echo "Check NDM libs in: ${PROJECT_ROOT}/pnr/ndm/"
echo -e "========================================${NC}"
