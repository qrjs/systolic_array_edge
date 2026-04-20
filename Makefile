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

.PHONY: dc dc-base dc-ultra dc-compare
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
