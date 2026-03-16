SHELL := /bin/bash

PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ARCH ?= ws
SIM ?= iverilog
VIEWER ?= surfer
VECTOR_DIR ?= $(PROJECT_ROOT)/test_vectors/txt
VECTOR_DIR_ABS := $(abspath $(VECTOR_DIR))

ARCHES := ws is os dip

RANDOM_VECTOR_SEED ?= 20260316
RANDOM_VECTOR_COUNT ?= 8
RANDOM_VECTOR_MIN ?= -16
RANDOM_VECTOR_MAX ?= 16
RANDOM_VECTOR_SPARSE ?= 0.20
RANDOM_VECTOR_PREFIX ?= rand
RANDOM_VECTOR_DIR ?= $(PROJECT_ROOT)/test_vectors/generated/seed_$(RANDOM_VECTOR_SEED)

BATCH_VECTOR_SEED ?= 20260317
BATCH_VECTOR_COUNT ?= 128
BATCH_VECTOR_MIN ?= -64
BATCH_VECTOR_MAX ?= 64
BATCH_VECTOR_SPARSE ?= 0.30
BATCH_VECTOR_PREFIX ?= batch
BATCH_VECTOR_DIR ?= $(PROJECT_ROOT)/test_vectors/batch/seed_$(BATCH_VECTOR_SEED)

ARCH_SHORTCUT_TARGETS := $(foreach arch,$(ARCHES), \
	$(arch) $(arch)-iverilog $(arch)-vcs $(arch)-wave $(arch)-wave-vcs \
	$(arch)-surfer $(arch)-surfer-vcs $(arch)-verdi $(arch)-verdi-vcs \
	$(arch)-txt $(arch)-txt-vcs $(arch)-synth $(arch)-vivado $(arch)-clean)

LEGACY_TARGETS := \
	test test-ws test-is test-os test-dip \
	txt-ws txt-is txt-os txt-dip \
	txt-random txt-random-iverilog txt-random-vcs

.PHONY: \
	help check sim wave view txt-one txt txt-all txt-all-iverilog txt-all-vcs \
	synth clean clean-arch distclean distclean-arch \
	vector-gen batch-gen random random-iverilog random-vcs batch batch-iverilog batch-vcs \
	$(ARCH_SHORTCUT_TARGETS) $(LEGACY_TARGETS)


define RUN_MULTI_ARCH_TXT
	@python3 "$(PROJECT_ROOT)/utils/run_multi_arch_txt_regression.py" \
		--label "$(1)" \
		--simulator "$(2)" \
		--vector-dir "$(abspath $(3))"
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


define ARCH_SHORTCUT_TEMPLATE
$(1):
	@$(MAKE) sim ARCH=$(1) SIM=iverilog

$(1)-iverilog:
	@$(MAKE) sim ARCH=$(1) SIM=iverilog

$(1)-vcs:
	@$(MAKE) sim ARCH=$(1) SIM=vcs

$(1)-wave:
	@$(MAKE) wave ARCH=$(1) SIM=iverilog

$(1)-wave-vcs:
	@$(MAKE) wave ARCH=$(1) SIM=vcs

$(1)-surfer:
	@$(MAKE) view ARCH=$(1) SIM=iverilog VIEWER=surfer

$(1)-surfer-vcs:
	@$(MAKE) view ARCH=$(1) SIM=vcs VIEWER=surfer

$(1)-verdi:
	@$(MAKE) view ARCH=$(1) SIM=iverilog VIEWER=verdi

$(1)-verdi-vcs:
	@$(MAKE) view ARCH=$(1) SIM=vcs VIEWER=verdi

$(1)-txt:
	@$(MAKE) txt-one ARCH=$(1) SIM=iverilog VECTOR_DIR="$(VECTOR_DIR_ABS)"

$(1)-txt-vcs:
	@$(MAKE) txt-one ARCH=$(1) SIM=vcs VECTOR_DIR="$(VECTOR_DIR_ABS)"

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
	@echo "最常用："
	@echo "  make ws                # WS + iverilog 功能仿真"
	@echo "  make ws-vcs            # WS + VCS 功能仿真"
	@echo "  make dip-wave          # DiP + iverilog 生成波形"
	@echo "  make dip-verdi-vcs     # DiP + VCS 波形并用 Verdi 打开"
	@echo "  make txt               # 四架构固定 .txt 回归，最后统一打印统计"
	@echo "  make batch-iverilog    # 生成批量向量并跑四架构，最后统一打印统计"
	@echo "  make clean             # 清理全部架构中间文件"
	@echo ""
	@echo "通用入口："
	@echo "  make sim ARCH=ws SIM=iverilog"
	@echo "  make wave ARCH=dip SIM=vcs"
	@echo "  make view ARCH=os SIM=iverilog VIEWER=surfer"
	@echo "  make txt-one ARCH=is SIM=iverilog VECTOR_DIR=$(PROJECT_ROOT)/test_vectors/txt"
	@echo "  make synth ARCH=ws"
	@echo ""
	@echo "批量回归："
	@echo "  make txt-all-vcs       # 四架构固定 .txt + VCS"
	@echo "  make random-iverilog   # 生成随机向量并回归"
	@echo "  make batch-vcs         # 生成大批量向量并回归"
	@echo ""
	@echo "批量参数："
	@echo "  BATCH_VECTOR_COUNT=$(BATCH_VECTOR_COUNT)"
	@echo "  BATCH_VECTOR_SEED=$(BATCH_VECTOR_SEED)"
	@echo "  BATCH_VECTOR_DIR=$(BATCH_VECTOR_DIR)"

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

sim: validate-arch validate-sim
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" sim SIM="$(SIM)"

wave: validate-arch validate-sim
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" wave SIM="$(SIM)"

view: validate-arch validate-sim validate-viewer
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" view SIM="$(SIM)" VIEWER="$(VIEWER)"

txt-one: validate-arch validate-sim
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" txt SIM="$(SIM)" VECTOR_DIR="$(VECTOR_DIR_ABS)"

txt: txt-all-iverilog

txt-all: txt

txt-all-iverilog:
	$(call RUN_MULTI_ARCH_TXT,txt-all,iverilog,$(VECTOR_DIR_ABS))

txt-all-vcs:
	$(call RUN_MULTI_ARCH_TXT,txt-all,vcs,$(VECTOR_DIR_ABS))

synth: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" synth

clean-arch: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" clean

clean:
	@for arch in $(ARCHES); do \
		$(MAKE) clean-arch ARCH=$$arch || exit $$?; \
	done
	@rm -rf "$(PROJECT_ROOT)/csrc" "$(PROJECT_ROOT)/verdiLog"
	@rm -f "$(PROJECT_ROOT)"/ucli.key "$(PROJECT_ROOT)"/vc_hdrs.h

distclean-arch: validate-arch
	@$(MAKE) -C "$(PROJECT_ROOT)/$(ARCH)/scripts" distclean

distclean: clean
	@for arch in $(ARCHES); do \
		$(MAKE) distclean-arch ARCH=$$arch || exit $$?; \
	done
	@rm -rf "$(PROJECT_ROOT)/test_logs"

vector-gen:
	$(call GENERATE_TXT_VECTORS,$(RANDOM_VECTOR_DIR),$(RANDOM_VECTOR_COUNT),$(RANDOM_VECTOR_SEED),$(RANDOM_VECTOR_PREFIX),$(RANDOM_VECTOR_MIN),$(RANDOM_VECTOR_MAX),$(RANDOM_VECTOR_SPARSE))

batch-gen:
	$(call GENERATE_TXT_VECTORS,$(BATCH_VECTOR_DIR),$(BATCH_VECTOR_COUNT),$(BATCH_VECTOR_SEED),$(BATCH_VECTOR_PREFIX),$(BATCH_VECTOR_MIN),$(BATCH_VECTOR_MAX),$(BATCH_VECTOR_SPARSE))

random: random-iverilog

random-iverilog: vector-gen
	$(call RUN_MULTI_ARCH_TXT,random,iverilog,$(RANDOM_VECTOR_DIR))

random-vcs: vector-gen
	$(call RUN_MULTI_ARCH_TXT,random,vcs,$(RANDOM_VECTOR_DIR))

batch: batch-iverilog

batch-iverilog: batch-gen
	$(call RUN_MULTI_ARCH_TXT,batch,iverilog,$(BATCH_VECTOR_DIR))

batch-vcs: batch-gen
	$(call RUN_MULTI_ARCH_TXT,batch,vcs,$(BATCH_VECTOR_DIR))

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
