#!/bin/bash
# ==============================================================================
# Run Synthesis for All Three Architectures using ICC2
# Note: Using ICC2 for synthesis since DC license has issues
# ==============================================================================

PROJECT_ROOT="/home/jrq/systolic_array_edge"
SCRIPT_DIR="${PROJECT_ROOT}/syn/scripts"

# Array of architectures
ARCHS=("is" "os" "ws")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo "Synthesis for Systolic Array"
echo "Using IC Compiler II (DC Utilities)"
echo "SMIC40 40nm PDK"
echo -e "========================================${NC}"

for arch in "${ARCHS[@]}"; do
    echo -e "${YELLOW}Starting synthesis for: $arch${NC}"
    echo "========================================"

    cd ${SCRIPT_DIR}

    MODE=$arch icc2_shell -f run_icc2_syn.tcl | tee syn_${arch}.log

    # Check if synthesis was successful
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✓ Synthesis completed for: $arch${NC}"
    else
        echo -e "${RED}✗ Synthesis failed for: $arch${NC}"
        echo "Check log file: ${SCRIPT_DIR}/syn_${arch}.log"
    fi

    echo ""
done

echo -e "${BLUE}========================================"
echo "All synthesis runs completed!"
echo "========================================"
echo "Check results in: ${PROJECT_ROOT}/syn/outputs/"
echo "Check reports in: ${PROJECT_ROOT}/syn/reports/"
echo -e "========================================${NC}"
