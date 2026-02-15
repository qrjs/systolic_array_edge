#!/bin/bash

# Usage: ./run_syn.sh [is|os|ws]

if [ -z "$1" ]; then
    echo "Usage: ./run_syn.sh [is|os|ws]"
    exit 1
fi

MODE=$1
if [[ "$MODE" != "is" && "$MODE" != "os" && "$MODE" != "ws" ]]; then
    echo "Error: Invalid mode. Choose from 'is', 'os', or 'ws'."
    exit 1
fi

echo "Running Synthesis for $MODE..."

# Ensure dc_shell is in PATH
if ! command -v dc_shell &> /dev/null; then
    echo "Error: dc_shell not found. Please setup Synopsys environment."
    exit 1
fi

# Run Design Compiler
dc_shell -x "set MODE $MODE; source scripts/run_syn.tcl" | tee run_syn_${MODE}.log
