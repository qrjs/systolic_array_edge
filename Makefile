SHELL := /bin/bash

PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ARCH ?= ws
SIM ?= iverilog
VIEWER ?= surfer
VECTOR_DIR ?= $(PROJECT_ROOT)/test_vectors/txt
VECTOR_DIR_ABS := $(abspath $(VECTOR_DIR))
COMM_SYN_ARCHES ?= $(ARCHES)
COMM_SYN_CONSTRAINT_MODE ?= uniform
COMM_SYN_RUN_TAG ?=
COMM_SYN_CLK_PERIOD ?=
COMM_SYN_BASE_CLK_PERIOD ?= 5.0
COMM_SYN_ULTRA_CLK_PERIOD ?= 1.0
COMM_SYN_DRY_RUN ?= 0
THESIS_VECTOR_DIR ?= $(PROJECT_ROOT)/test_vectors/txt
THESIS_VECTOR_ROOT ?= $(PROJECT_ROOT)/test_vectors/thesis
THESIS_REPORT_DIR ?= $(PROJECT_ROOT)/reports/thesis
THESIS_WORK_DIR ?= $(PROJECT_ROOT)/work/thesis_materials/latest
THESIS_RANDOM_SEEDS ?= 2026042601,2026042602,2026042603,2026042604,2026042605
THESIS_RANDOM_COUNT ?= 128
THESIS_RANDOM_SPARSE ?= 0.30
THESIS_SPARSE_LEVELS ?= 0,25,50,75,90
THESIS_SPARSE_COUNT ?= 64
THESIS_VALUE_MIN ?= -64
THESIS_VALUE_MAX ?= 64
THESIS_VALIDATE_ARCHES ?= ws,os,is,dip
THESIS_FRONT_GROUPS ?= baseline_268,directed,random,sparse
THESIS_GATE_GROUPS ?= baseline_268,directed,sparse
THESIS_GATE_STAGE ?= innovus
THESIS_SMOKE_FRONT_GROUPS ?= directed,sparse_90
THESIS_SMOKE_GATE_GROUPS ?= directed
THESIS_COVERAGE_ARCHES ?= dip
THESIS_COVERAGE_GROUPS ?= directed,sparse_90
THESIS_DIP_SWEEP_GROUPS ?= sparse
THESIS_RANDOM_SAMPLE_GROUPS ?= random_seed_2026042601
THESIS_LVS_ARCHES ?= ws,os,is,dip
THESIS_LVS_PROFILES ?= ports_only_nostdlib
THESIS_LVS_STOP_ON_FAIL ?= 0

ARCHES := ws is os dip

RANDOM_VECTOR_SEED ?= 20260316
RANDOM_VECTOR_COUNT ?= 8
RANDOM_VECTOR_MIN ?= -16
RANDOM_VECTOR_MAX ?= 16
RANDOM_VECTOR_SPARSE ?= 0.20
RANDOM_VECTOR_PREFIX ?= rand
RANDOM_VECTOR_ROOT := $(PROJECT_ROOT)/test_vectors/generated
RANDOM_VECTOR_DIR ?= $(RANDOM_VECTOR_ROOT)/seed_$(RANDOM_VECTOR_SEED)

# `batch` 保留为随机回归的大样本兼容别名，不再单独维护一套目录结构。
ifeq ($(origin BATCH_VECTOR_SEED), undefined)
BATCH_VECTOR_SEED := $(shell date +%Y%m%d%H%M%S)
endif
BATCH_VECTOR_COUNT ?= 128
BATCH_VECTOR_MIN ?= -64
BATCH_VECTOR_MAX ?= 64
BATCH_VECTOR_SPARSE ?= 0.30
BATCH_VECTOR_PREFIX ?= batch
BATCH_VECTOR_DIR ?= $(RANDOM_VECTOR_ROOT)/seed_$(BATCH_VECTOR_SEED)

ARCH_SHORTCUT_TARGETS := $(foreach arch,$(ARCHES), \
	$(arch) $(arch)-iverilog $(arch)-vcs $(arch)-wave $(arch)-wave-vcs \
	$(arch)-surfer $(arch)-surfer-vcs $(arch)-verdi $(arch)-verdi-vcs \
	$(arch)-txt $(arch)-txt-vcs $(arch)-cov $(arch)-synth $(arch)-vivado $(arch)-clean)

LEGACY_TARGETS := \
	test test-ws test-is test-os test-dip \
	txt-ws txt-is txt-os txt-dip \
	txt-random txt-random-iverilog txt-random-vcs

.PHONY: dc dc-base dc-ultra dc-compare thesis-check thesis-synth thesis-dip thesis-is thesis-os thesis-dio thesis-dip-gated-opt thesis-dip-gated-debug thesis-innovus-gui thesis-virtuoso thesis-vectors thesis-validate thesis-report thesis-signoff thesis-foundry-signoff thesis-workspace thesis-smoke thesis-random-sample thesis-sparse-sweep thesis-dip-sparse-sweep thesis-sparse-gate thesis-coverage thesis-calibre-lvs-sweep thesis-evidence-plus thesis-full tidy-workspace
.PHONY: \
	help help-all run open regress front-verify frontend-verify backend report verify \
	impl impl-all impl-summary \
	check sim wave view surfer surfer-vcs txt-one txt txt-all txt-all-iverilog txt-all-vcs \
	cov cov-all \
	synth synth-all synth-summary verify-func verify-backend verify-full clean clean-arch distclean distclean-arch \
	vector-gen batch-gen random random-iverilog random-vcs batch batch-iverilog batch-vcs \
	$(ARCH_SHORTCUT_TARGETS) $(LEGACY_TARGETS)


define RUN_MULTI_ARCH_TXT
	@python3 "$(PROJECT_ROOT)/utils/run_multi_arch_txt_regression.py" \
		--label "$(1)" \
		--simulator "$(2)" \
		--vector-dir "$(abspath $(3))"
endef


define RUN_REGRESS_BY_SIM
	@case "$(SIM)" in \
		iverilog|vcs) ;; \
		*) echo "Unsupported SIM=$(SIM). Use SIM=iverilog or SIM=vcs."; exit 1 ;; \
	esac
	$(call RUN_MULTI_ARCH_TXT,txt-all,$(SIM),$(VECTOR_DIR_ABS))
endef


define GENERATE_TXT_VECTORS
	@python3 "$(PROJECT_ROOT)/utils/generate_txt_vectors.py" \
		--output-dir "$(1)" \
		--count "$(2)" \
		--seed "$(3)" \
		--prefix "$(4)" \
		--value-min "$(5)" \
		--value-max "$(6)" \
		--sparse-prob "$(7)" \
		--clean \
		--quiet
endef


define RUN_COMMERCIAL_SYN
	@env \
		ARCH_LIST="$(COMM_SYN_ARCHES)" \
		CONSTRAINT_MODE="$(COMM_SYN_CONSTRAINT_MODE)" \
		BASE_CLK_PERIOD="$(COMM_SYN_BASE_CLK_PERIOD)" \
		ULTRA_CLK_PERIOD="$(COMM_SYN_ULTRA_CLK_PERIOD)" \
		DRY_RUN="$(COMM_SYN_DRY_RUN)" \
		$(if $(strip $(COMM_SYN_CLK_PERIOD)),CLK_PERIOD="$(COMM_SYN_CLK_PERIOD)") \
		$(if $(strip $(COMM_SYN_RUN_TAG)),RUN_TAG="$(COMM_SYN_RUN_TAG)") \
		"$(PROJECT_ROOT)/asic_commercial/syn/scripts/run_dc.sh" $(1)
endef


define ARCH_SHORTCUT_TEMPLATE
$(1):
	@$(MAKE) run ARCH=$(1) SIM=iverilog

$(1)-iverilog:
	@$(MAKE) run ARCH=$(1) SIM=iverilog

$(1)-vcs:
	@$(MAKE) run ARCH=$(1) SIM=vcs

$(1)-wave:
	@$(MAKE) wave ARCH=$(1) SIM=iverilog

$(1)-wave-vcs:
	@$(MAKE) wave ARCH=$(1) SIM=vcs

$(1)-surfer:
	@$(MAKE) open ARCH=$(1) SIM=iverilog VIEWER=surfer

$(1)-surfer-vcs:
	@$(MAKE) open ARCH=$(1) SIM=vcs VIEWER=surfer

$(1)-verdi:
	@$(MAKE) open ARCH=$(1) SIM=iverilog VIEWER=verdi

$(1)-verdi-vcs:
	@$(MAKE) open ARCH=$(1) SIM=vcs VIEWER=verdi

$(1)-txt:
	@$(MAKE) txt-one ARCH=$(1) SIM=iverilog VECTOR_DIR="$(VECTOR_DIR_ABS)"

$(1)-txt-vcs:
	@$(MAKE) txt-one ARCH=$(1) SIM=vcs VECTOR_DIR="$(VECTOR_DIR_ABS)"

$(1)-cov:
	@$(MAKE) cov ARCH=$(1) VECTOR_DIR="$(VECTOR_DIR_ABS)"

$(1)-synth:
	@$(MAKE) synth ARCH=$(1)

$(1)-vivado:
	@$(MAKE) synth ARCH=$(1)

$(1)-clean:
	@$(MAKE) clean-arch ARCH=$(1)
endef

help:
	@echo "统一 Makefile 入口"
	@echo ""
	@echo "推荐先记这 5 类："
	@echo "  make txt               # 固定基准回归（四架构，默认 SIM=iverilog）"
	@echo "  make random            # 随机回归（先删旧向量，再生成新 suite_* 文件）"
	@echo "  make batch             # random 的大样本兼容别名"
	@echo "  make run ARCH=ws       # 单架构调试仿真"
	@echo "  make wave ARCH=dip     # 单架构生成波形"
	@echo "  make open ARCH=ws      # 打开波形（默认 VIEWER=surfer）"
	@echo "  make cov ARCH=dip      # 单架构 VCS 功能覆盖率"
	@echo "  make dc-compare        # 商业综合：四架构 base+ultra 对比"
	@echo "  make thesis-check      # TSMC28 thesis 主线环境检查"
	@echo "  make thesis-synth      # 主表综合：ws/is/os legacy + dip gated"
	@echo "  make thesis-dip        # DiP gated 主链：gated DC/FM/gate -> Innovus/FM/gate"
	@echo "  make thesis-is         # IS full backend 主链"
	@echo "  make thesis-os         # OS full backend 主链"
	@echo "  make thesis-dio        # 顺序运行 DIP/IS/OS full backend 主链"
	@echo "  make thesis-dip-gated-opt # DiP gated profile sweep + FM + 全量 gate suite"
	@echo "  make thesis-dip-gated-debug # DiP gated 调试：gated DC -> FM -> 定向 gate case"
	@echo "  make thesis-vectors   # 生成论文 directed/random/sparse sweep 向量"
	@echo "  make thesis-validate  # 跑论文验证包：前仿 + Innovus 门仿"
	@echo "  make thesis-report    # 汇总论文验证/PPA/后端/GDS 报告"
	@echo "  make thesis-signoff   # 检查前仿/门仿/FM/Innovus/GDS 证据是否全 PASS"
	@echo "  make thesis-foundry-signoff # 严格 Calibre DRC/LVS foundry 签核检查"
	@echo "  make thesis-workspace # 生成论文写作材料工作区 work/thesis_materials/latest"
	@echo "  make thesis-smoke     # 轻量论文回归：directed + sparse_90 前仿，directed 门仿"
	@echo "  make thesis-random-sample # 四数据流随机样本前仿"
	@echo "  make thesis-sparse-sweep # 四数据流稀疏度 sweep 前仿"
	@echo "  make thesis-dip-sparse-sweep # DiP 稀疏度 sweep 前仿"
	@echo "  make thesis-sparse-gate # 四数据流 sparse_90 Innovus SDF 门仿"
	@echo "  make thesis-coverage  # DiP directed+sparse_90 VCS/URG 覆盖率"
	@echo "  make thesis-calibre-lvs-sweep # Calibre LVS 多 profile 调试 sweep"
	@echo "  make thesis-evidence-plus # 论文增强证据链：随机、稀疏、覆盖率、签核"
	@echo "  make thesis-full      # thesis-vectors + thesis-validate + thesis-report"
	@echo "  make thesis-innovus-gui # 打开 Innovus GUI 看版图"
	@echo "  make thesis-virtuoso   # 导入 Innovus GDS 并打开 Virtuoso layout"
	@echo "  make tidy-workspace    # 收拢根目录生成物到 work/root_artifacts/"
	@echo ""
	@echo "说明："
	@echo "  txt / random / cov 属于正式验证"
	@echo "  run / wave / open 属于调试验证"
	@echo "  regress / front-verify 是 txt 的历史别名"
	@echo "  batch / batch-vcs 是 random 的大样本兼容别名"
	@echo ""
	@echo "查看完整命令："
	@echo "  make help-all"
	@echo ""
	@echo "常用参数："
	@echo "  ARCH=$(ARCHES)"
	@echo "  SIM=iverilog|vcs"
	@echo "  VIEWER=surfer|verdi"

help-all:
	@echo "完整命令入口"
	@echo ""
	@echo "验证主入口："
	@echo "  make txt"
	@echo "  make random"
	@echo "  make batch"
	@echo "  make run ARCH=ws SIM=iverilog"
	@echo "  make wave ARCH=dip SIM=vcs"
	@echo "  make open ARCH=os SIM=iverilog VIEWER=surfer"
	@echo "  make cov ARCH=dip"
	@echo ""
	@echo "底层入口："
	@echo "  make sim ARCH=ws SIM=iverilog"
	@echo "  make view ARCH=os SIM=iverilog VIEWER=surfer"
	@echo "  make txt-one ARCH=is SIM=iverilog VECTOR_DIR=$(PROJECT_ROOT)/test_vectors/txt"
	@echo "  make cov ARCH=dip VECTOR_DIR=$(PROJECT_ROOT)/test_vectors/txt"
	@echo ""
	@echo "后端入口："
	@echo "  make backend"
	@echo "  make report"
	@echo "  make synth ARCH=ws"
	@echo "  make impl ARCH=is"
	@echo "  make synth-summary"
	@echo "  make impl-summary"
	@echo "  make verify"
	@echo "  make verify-full"
	@echo "  make dc-base"
	@echo "  make dc-ultra"
	@echo "  make dc-compare"
	@echo "  make thesis-check"
	@echo "  make thesis-synth"
	@echo "  make thesis-dip"
	@echo "  make thesis-is"
	@echo "  make thesis-os"
	@echo "  make thesis-dio"
	@echo "  make thesis-dip-gated-opt"
	@echo "  make thesis-dip-gated-debug"
	@echo "  make thesis-vectors"
	@echo "  make thesis-validate"
	@echo "  make thesis-report"
	@echo "  make thesis-signoff"
	@echo "  make thesis-foundry-signoff"
	@echo "  make thesis-workspace"
	@echo "  make thesis-smoke"
	@echo "  make thesis-random-sample"
	@echo "  make thesis-sparse-sweep"
	@echo "  make thesis-dip-sparse-sweep"
	@echo "  make thesis-sparse-gate"
	@echo "  make thesis-coverage"
	@echo "  make thesis-calibre-lvs-sweep"
	@echo "  make thesis-evidence-plus"
	@echo "  make thesis-full"
	@echo "  make thesis-innovus-gui"
	@echo "  make thesis-virtuoso"
	@echo "  make tidy-workspace"
	@echo ""
	@echo "兼容别名："
	@echo "  make regress"
	@echo "  make front-verify"
	@echo "  make txt-all-vcs"
	@echo "  make random-iverilog"
	@echo "  make batch-vcs"
	@echo ""
	@echo "随机参数："
	@echo "  RANDOM_VECTOR_COUNT=$(RANDOM_VECTOR_COUNT)"
	@echo "  RANDOM_VECTOR_SEED=$(RANDOM_VECTOR_SEED)"
	@echo "  RANDOM_VECTOR_DIR=$(RANDOM_VECTOR_DIR)"
	@echo ""
	@echo "batch 兼容参数："
	@echo "  BATCH_VECTOR_COUNT=$(BATCH_VECTOR_COUNT)"
	@echo "  BATCH_VECTOR_SEED=$(BATCH_VECTOR_SEED)"
	@echo "  BATCH_VECTOR_DIR=$(BATCH_VECTOR_DIR)"

dc: dc-base

dc-base:
	$(call RUN_COMMERCIAL_SYN,base)

dc-ultra:
	$(call RUN_COMMERCIAL_SYN,ultra)

dc-compare:
	$(call RUN_COMMERCIAL_SYN,compare)

thesis-check:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	"$(PROJECT_ROOT)/asic_commercial/scripts/check_thesis_env.sh"

thesis-synth:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	"$(PROJECT_ROOT)/asic_commercial/scripts/run_thesis_synth.sh"

thesis-dip:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)" \
	"$(PROJECT_ROOT)/asic_commercial/dip/scripts/run_full_flow.sh"

thesis-is:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)" \
	"$(PROJECT_ROOT)/asic_commercial/is/scripts/run_full_flow.sh"

thesis-os:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)" \
	"$(PROJECT_ROOT)/asic_commercial/os/scripts/run_full_flow.sh"

thesis-dio:
	@$(MAKE) thesis-dip TSMC28_ROOT="$(TSMC28_ROOT)" THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)"
	@$(MAKE) thesis-is TSMC28_ROOT="$(TSMC28_ROOT)" THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)"
	@$(MAKE) thesis-os TSMC28_ROOT="$(TSMC28_ROOT)" THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)"

thesis-dip-gated-opt:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)" \
	"$(PROJECT_ROOT)/asic_commercial/dip/scripts/run_dip_gated_opt.sh"

thesis-dip-gated-debug:
	@TSMC28_ROOT="$(TSMC28_ROOT)" \
	THESIS_VECTOR_DIR="$(THESIS_VECTOR_DIR)" \
	"$(PROJECT_ROOT)/asic_commercial/dip/scripts/run_thesis_gated_debug.sh"

thesis-vectors:
	@python3 "$(PROJECT_ROOT)/utils/generate_thesis_vectors.py" \
		--output-root "$(THESIS_VECTOR_ROOT)" \
		--random-seeds "$(THESIS_RANDOM_SEEDS)" \
		--random-count "$(THESIS_RANDOM_COUNT)" \
		--random-sparse-prob "$(THESIS_RANDOM_SPARSE)" \
		--sparse-levels "$(THESIS_SPARSE_LEVELS)" \
		--sparse-count "$(THESIS_SPARSE_COUNT)" \
		--value-min "$(THESIS_VALUE_MIN)" \
		--value-max "$(THESIS_VALUE_MAX)" \
		--clean

thesis-validate:
	@python3 "$(PROJECT_ROOT)/utils/run_thesis_validation.py" \
		--repo-root "$(PROJECT_ROOT)" \
		--vector-root "$(THESIS_VECTOR_ROOT)" \
		--output-root "$(THESIS_REPORT_DIR)/runs" \
		--arches "$(THESIS_VALIDATE_ARCHES)" \
		--front-groups "$(THESIS_FRONT_GROUPS)" \
		--gate-groups "$(THESIS_GATE_GROUPS)" \
		--gate-stage "$(THESIS_GATE_STAGE)"

thesis-report:
	@python3 "$(PROJECT_ROOT)/utils/collect_thesis_reports.py" \
		--repo-root "$(PROJECT_ROOT)" \
		--output-dir "$(THESIS_REPORT_DIR)"

thesis-signoff: thesis-report
	@python3 "$(PROJECT_ROOT)/utils/check_thesis_signoff.py" \
		--report-dir "$(THESIS_REPORT_DIR)"

thesis-foundry-signoff: thesis-report
	@python3 "$(PROJECT_ROOT)/utils/check_foundry_signoff.py" \
		--report-dir "$(THESIS_REPORT_DIR)"

thesis-workspace: thesis-signoff
	@python3 "$(PROJECT_ROOT)/utils/check_foundry_signoff.py" \
		--report-dir "$(THESIS_REPORT_DIR)" || true
	@python3 "$(PROJECT_ROOT)/utils/package_thesis_workspace.py" \
		--repo-root "$(PROJECT_ROOT)" \
		--report-dir "$(THESIS_REPORT_DIR)" \
		--output-dir "$(THESIS_WORK_DIR)"

thesis-smoke:
	@$(MAKE) thesis-vectors THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)"
	@$(MAKE) thesis-validate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="$(THESIS_VALIDATE_ARCHES)" \
		THESIS_FRONT_GROUPS="$(THESIS_SMOKE_FRONT_GROUPS)" \
		THESIS_GATE_GROUPS="$(THESIS_SMOKE_GATE_GROUPS)" \
		THESIS_GATE_STAGE="$(THESIS_GATE_STAGE)"
	@$(MAKE) thesis-signoff \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-random-sample:
	@$(MAKE) thesis-vectors THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)"
	@$(MAKE) thesis-validate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="$(THESIS_VALIDATE_ARCHES)" \
		THESIS_FRONT_GROUPS="$(THESIS_RANDOM_SAMPLE_GROUPS)" \
		THESIS_GATE_GROUPS="" \
		THESIS_GATE_STAGE="$(THESIS_GATE_STAGE)"
	@$(MAKE) thesis-report THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-sparse-sweep:
	@$(MAKE) thesis-vectors THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)"
	@$(MAKE) thesis-validate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="$(THESIS_VALIDATE_ARCHES)" \
		THESIS_FRONT_GROUPS="sparse" \
		THESIS_GATE_GROUPS="" \
		THESIS_GATE_STAGE="$(THESIS_GATE_STAGE)"
	@$(MAKE) thesis-report THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-dip-sparse-sweep:
	@$(MAKE) thesis-vectors THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)"
	@$(MAKE) thesis-validate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="dip" \
		THESIS_FRONT_GROUPS="$(THESIS_DIP_SWEEP_GROUPS)" \
		THESIS_GATE_GROUPS="" \
		THESIS_GATE_STAGE="$(THESIS_GATE_STAGE)"
	@$(MAKE) thesis-report THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-sparse-gate:
	@$(MAKE) thesis-validate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="$(THESIS_VALIDATE_ARCHES)" \
		THESIS_FRONT_GROUPS="" \
		THESIS_GATE_GROUPS="sparse_90" \
		THESIS_GATE_STAGE="$(THESIS_GATE_STAGE)"
	@$(MAKE) thesis-report THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-coverage:
	@python3 "$(PROJECT_ROOT)/utils/run_thesis_validation.py" \
		--repo-root "$(PROJECT_ROOT)" \
		--vector-root "$(THESIS_VECTOR_ROOT)" \
		--output-root "$(THESIS_REPORT_DIR)/runs" \
		--arches "$(THESIS_COVERAGE_ARCHES)" \
		--front-groups "$(THESIS_COVERAGE_GROUPS)" \
		--gate-groups "" \
		--frontsim-coverage \
		--frontsim-coverage-strict
	@$(MAKE) thesis-report THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-calibre-lvs-sweep:
	@if [[ "$(THESIS_LVS_STOP_ON_FAIL)" == "1" ]]; then stop_arg="--stop-on-fail"; else stop_arg=""; fi; \
	TSMC28_ROOT="$(TSMC28_ROOT)" python3 "$(PROJECT_ROOT)/utils/run_calibre_lvs_sweep.py" \
		--repo-root "$(PROJECT_ROOT)" \
		--arches "$(THESIS_LVS_ARCHES)" \
		--profiles "$(THESIS_LVS_PROFILES)" \
		$$stop_arg
	@$(MAKE) thesis-report THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-evidence-plus:
	@$(MAKE) thesis-random-sample \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_RANDOM_SAMPLE_GROUPS="$(THESIS_RANDOM_SAMPLE_GROUPS)"
	@$(MAKE) thesis-sparse-sweep \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="$(THESIS_VALIDATE_ARCHES)"
	@$(MAKE) thesis-sparse-gate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"
	@$(MAKE) thesis-coverage \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_COVERAGE_ARCHES="$(THESIS_COVERAGE_ARCHES)" \
		THESIS_COVERAGE_GROUPS="$(THESIS_COVERAGE_GROUPS)"
	@$(MAKE) thesis-signoff \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-full:
	@$(MAKE) thesis-vectors THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)"
	@$(MAKE) thesis-validate \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)" \
		THESIS_VALIDATE_ARCHES="$(THESIS_VALIDATE_ARCHES)" \
		THESIS_FRONT_GROUPS="$(THESIS_FRONT_GROUPS)" \
		THESIS_GATE_GROUPS="$(THESIS_GATE_GROUPS)" \
		THESIS_GATE_STAGE="$(THESIS_GATE_STAGE)"
	@$(MAKE) thesis-signoff \
		THESIS_VECTOR_ROOT="$(THESIS_VECTOR_ROOT)" \
		THESIS_REPORT_DIR="$(THESIS_REPORT_DIR)"

thesis-innovus-gui:
	@cd "$(PROJECT_ROOT)/asic_commercial/dip" && \
	TSMC28_ROOT="$(TSMC28_ROOT)" \
	DESIGN_ENV=config/design.env \
	LIBS_ENV=config/libs.env \
	INNOVUS_INPUT_FLAVOR=gated \
	DC_OUTPUT_FLAVOR=gated \
	./scripts/run_innovus_gui.sh

thesis-virtuoso:
	@cd "$(PROJECT_ROOT)/asic_commercial/dip" && \
	TSMC28_ROOT="$(TSMC28_ROOT)" \
	DESIGN_ENV=config/design.env \
	LIBS_ENV=config/libs.env \
	INNOVUS_INPUT_FLAVOR=gated \
	DC_OUTPUT_FLAVOR=gated \
	./scripts/run_virtuoso_layout.sh

tidy-workspace:
	@"$(PROJECT_ROOT)/scripts/tidy_workspace.sh"

validate-arch:
	@case "$(ARCH)" in \
		ws|is|os|dip) ;; \
		*) echo "Unsupported ARCH=$(ARCH). Use ARCH=ws|is|os|dip."; exit 1 ;; \
	esac

validate-sim:
	@case "$(SIM)" in \
		iverilog|vcs) ;; \
		*) echo "Unsupported SIM=$(SIM). Use SIM=iverilog or SIM=vcs."; exit 1 ;; \
	esac

validate-viewer:
	@case "$(VIEWER)" in \
		surfer|verdi) ;; \
		*) echo "Unsupported VIEWER=$(VIEWER). Use VIEWER=surfer or VIEWER=verdi."; exit 1 ;; \
	esac

check: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" check-tools VECTOR_DIR="$(VECTOR_DIR_ABS)"

run: sim

sim: validate-arch validate-sim
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" sim SIM="$(SIM)"

wave: validate-arch validate-sim
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" wave SIM="$(SIM)"

open: view

view: validate-arch validate-sim validate-viewer
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" view SIM="$(SIM)" VIEWER="$(VIEWER)"

surfer: validate-arch validate-sim
	@$(MAKE) view ARCH="$(ARCH)" SIM="$(SIM)" VIEWER=surfer

surfer-vcs: validate-arch
	@$(MAKE) view ARCH="$(ARCH)" SIM=vcs VIEWER=surfer

txt-one: validate-arch validate-sim
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" txt SIM="$(SIM)" VECTOR_DIR="$(VECTOR_DIR_ABS)"

cov: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" cov VECTOR_DIR="$(VECTOR_DIR_ABS)"

regress:
	$(call RUN_REGRESS_BY_SIM)

front-verify: regress

frontend-verify: front-verify

txt: regress

txt-all: txt

txt-all-iverilog:
	$(call RUN_MULTI_ARCH_TXT,txt-all,iverilog,$(VECTOR_DIR_ABS))

txt-all-vcs:
	$(call RUN_MULTI_ARCH_TXT,txt-all,vcs,$(VECTOR_DIR_ABS))

cov-all:
	@for arch in $(ARCHES); do \
		$(MAKE) cov ARCH=$$arch VECTOR_DIR="$(VECTOR_DIR_ABS)" || exit $$?; \
	done

synth: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" synth

synth-all:
	@for arch in $(ARCHES); do \
		$(MAKE) synth ARCH=$$arch || exit $$?; \
	done

	report: synth-summary impl-summary

synth-summary:
	@python3 "$(PROJECT_ROOT)/utils/extract_synth_metrics.py" --repo-root "$(PROJECT_ROOT)" --arches $(ARCHES) --output-dir "$(PROJECT_ROOT)/test_logs/synth_summary"

impl-summary:
	@python3 "$(PROJECT_ROOT)/utils/extract_impl_metrics.py" --repo-root "$(PROJECT_ROOT)" --arches $(ARCHES) --output-dir "$(PROJECT_ROOT)/test_logs/impl_summary"

impl: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" impl

impl-all:
	@for arch in $(ARCHES); do \
		$(MAKE) impl ARCH=$$arch || exit $$?; \
	done

# 快速功能完备性验证（统一固定向量回归）
verify-func: front-verify

# 后端完备性验证（四架构综合 + 统一指标表）
verify-backend: synth-all synth-summary

backend: verify-backend

# 端到端验证入口：功能 + 后端 + 汇总，便于论文复现实验。
verify-full: verify-func verify-backend

verify: verify-full

clean-arch: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" clean

clean:
	@for arch in $(ARCHES); do \
		$(MAKE) clean-arch ARCH=$$arch || exit $$?; \
	done
	@rm -rf "$(PROJECT_ROOT)/csrc" "$(PROJECT_ROOT)/verdiLog"
	@rm -f "$(PROJECT_ROOT)"/ucli.key "$(PROJECT_ROOT)"/vc_hdrs.h
	@rm -rf "$(PROJECT_ROOT)/test_vectors/generated" "$(PROJECT_ROOT)/test_vectors/batch"

distclean-arch: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" distclean

distclean: clean
	@for arch in $(ARCHES); do \
		$(MAKE) distclean-arch ARCH=$$arch || exit $$?; \
	done
	@rm -rf "$(PROJECT_ROOT)/test_logs"

vector-gen:
	@rm -rf "$(RANDOM_VECTOR_DIR)"
	$(call GENERATE_TXT_VECTORS,$(RANDOM_VECTOR_DIR),$(RANDOM_VECTOR_COUNT),$(RANDOM_VECTOR_SEED),$(RANDOM_VECTOR_PREFIX),$(RANDOM_VECTOR_MIN),$(RANDOM_VECTOR_MAX),$(RANDOM_VECTOR_SPARSE))

batch-gen:
	@$(MAKE) vector-gen \
		RANDOM_VECTOR_DIR="$(BATCH_VECTOR_DIR)" \
		RANDOM_VECTOR_COUNT="$(BATCH_VECTOR_COUNT)" \
		RANDOM_VECTOR_SEED="$(BATCH_VECTOR_SEED)" \
		RANDOM_VECTOR_PREFIX="$(BATCH_VECTOR_PREFIX)" \
		RANDOM_VECTOR_MIN="$(BATCH_VECTOR_MIN)" \
		RANDOM_VECTOR_MAX="$(BATCH_VECTOR_MAX)" \
		RANDOM_VECTOR_SPARSE="$(BATCH_VECTOR_SPARSE)"

random: random-iverilog

random-iverilog: vector-gen
	$(call RUN_MULTI_ARCH_TXT,random,iverilog,$(RANDOM_VECTOR_DIR))

random-vcs: vector-gen
	$(call RUN_MULTI_ARCH_TXT,random,vcs,$(RANDOM_VECTOR_DIR))

batch: batch-iverilog

batch-iverilog: batch-gen
	$(call RUN_MULTI_ARCH_TXT,random-batch,iverilog,$(BATCH_VECTOR_DIR))

batch-vcs: batch-gen
	$(call RUN_MULTI_ARCH_TXT,random-batch,vcs,$(BATCH_VECTOR_DIR))

$(foreach arch,$(ARCHES),$(eval $(call ARCH_SHORTCUT_TEMPLATE,$(arch))))

test: ws

test-ws:
	@$(MAKE) ws

test-is:
	@$(MAKE) is

test-os:
	@$(MAKE) os

test-dip:
	@$(MAKE) dip

txt-ws:
	@$(MAKE) ws-txt

txt-is:
	@$(MAKE) is-txt

txt-os:
	@$(MAKE) os-txt

txt-dip:
	@$(MAKE) dip-txt

txt-random: random

txt-random-iverilog: random-iverilog

txt-random-vcs: random-vcs
