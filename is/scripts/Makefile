#==============================================================================
# Makefile for Systolic Array Project
# 使用VCS进行仿真
#==============================================================================

# 目录设置
PROJECT_ROOT = ~/systolic_array_edge
SRC_DIR      = $(PROJECT_ROOT)/src
TB_DIR       = $(PROJECT_ROOT)/tb
SIM_DIR      = $(PROJECT_ROOT)/sim/work
SCRIPT_DIR   = $(PROJECT_ROOT)/script

# 源文件
SOURCES = $(SRC_DIR)/pe.v \
          $(SRC_DIR)/systolic_array_4x4.v \
          $(SRC_DIR)/matrix_multiplier_top.v

TESTBENCH = $(TB_DIR)/systolic_array_tb.v

# VCS选项
VCS = vcs
VCS_OPTS = -full64 \
           -sverilog \
           +vc+list \
           -debug_acc+all \
           -kdb \
           -lca \
           -timescale=1ns/1ps \
           -o systolic_sim

# 仿真选项
SIM_OPTS = -ucli \
           -l sim.log \
           +vcs+lic+wait

# 仿真可执行文件
SIM_EXE = $(SIM_DIR)/systolic_sim

#==============================================================================
# 编译规则
#==============================================================================
compile: $(SIM_DIR)
	@echo "=========================================="
	@echo "Compiling design with VCS..."
	@echo "=========================================="
	cd $(SIM_DIR) && $(VCS) $(VCS_OPTS) \
		-top systolic_array_tb \
		$(SOURCES) \
		$(TESTBENCH)
	@echo "Compilation complete"

#==============================================================================
# 仿真规则
#==============================================================================
simulate: compile
	@echo "=========================================="
	@echo "Running simulation..."
	@echo "=========================================="
	cd $(SIM_DIR) && $(SIM_EXE) $(SIM_OPTS)
	@echo "Simulation complete"
	@echo "Check $(SIM_DIR)/sim.log for results"

#==============================================================================
# 快速仿真（仅运行，不重新编译）
#==============================================================================
sim_only:
	@echo "Running simulation without recompilation..."
	cd $(SIM_DIR) && $(SIM_EXE) $(SIM_OPTS)

#==============================================================================
# 查看波形 - 使用Surfer
#==============================================================================
wave:
	@echo "Opening Surfer waveform viewer..."
	surfer $(SIM_DIR)/*.vcd &

#==============================================================================
# 创建工作目录
#==============================================================================
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

#==============================================================================
# 清理
#==============================================================================
clean:
	@echo "Cleaning generated files..."
	rm -rf $(SIM_DIR)/*
	@echo "Clean complete"

#==============================================================================
# 帮助
#==============================================================================
help:
	@echo "Available targets:"
	@echo "  compile   - Compile the design"
	@echo "  simulate  - Compile and run simulation"
	@echo "  sim_only  - Run simulation without compilation"
	@echo "  wave      - Open waveform viewer"
	@echo "  clean     - Clean generated files"
	@echo "  help      - Show this help message"

.PHONY: compile simulate sim_only wave clean help
