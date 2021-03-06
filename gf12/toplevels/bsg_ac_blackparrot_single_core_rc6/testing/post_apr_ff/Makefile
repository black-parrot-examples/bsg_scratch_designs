.DEFAULT_GOAL=run_all
.SECONDARY:

# Note: most variables that are file/dir paths are ?= because they can be
# overriden by the chip repo if this makefile is called from the chip
# infrastructure.

export BSG_DESIGNS_DIR        ?= $(abspath ../../../../)
export BSG_DESIGNS_TARGET_DIR ?= $(abspath ../../)

BSG_WORK_DIR := $(abspath ./)
BSG_OUT_DIR  := $(BSG_WORK_DIR)/out
BSG_OUT_SIM  := $(BSG_OUT_DIR)/simv

include $(BSG_DESIGNS_TARGET_DIR)/bsg_cadenv/cadenv.mk

# Repository setup
export BASEJUMP_STL_DIR       ?= $(BSG_DESIGNS_TARGET_DIR)/basejump_stl
export BSG_PACKAGING_DIR      ?= $(BSG_DESIGNS_TARGET_DIR)/bsg_packaging
export BLACKPARROT_DIR        ?= $(BSG_DESIGNS_TARGET_DIR)/black-parrot
export BOARD_DIR              ?= $(BSG_DESIGNS_TARGET_DIR)/board

export BSG_PACKAGE           ?=uw_bga
export BSG_PINOUT            ?=bsg_asic_cloud
export BSG_PACKAGING_FOUNDRY ?=gf_14_invecas_1p8v
export BSG_PADMAPPING        ?=default

export BLACKPARROT_COMMON_DIR ?= $(BLACKPARROT_DIR)/bp_common
export BLACKPARROT_TOP_DIR    ?= $(BLACKPARROT_DIR)/bp_top
export BLACKPARROT_FE_DIR     ?= $(BLACKPARROT_DIR)/bp_fe
export BLACKPARROT_BE_DIR     ?= $(BLACKPARROT_DIR)/bp_be
export BLACKPARROT_ME_DIR     ?= $(BLACKPARROT_DIR)/bp_me

# Additional setup for RTL-Hard
export BSG_CHIP_DIR             ?= $(BSG_DESIGNS_TARGET_DIR)/bsg_14
export PREP_MEMGEN_RUN_DIR      ?= $(BSG_CHIP_DIR)/.pdk_prep/memgen
export BSG_TOPLEVEL_DESIGN_TYPE ?=chip_3x3
export BSG_TARGET_PROCESS       ?=gf_14

include $(BSG_DESIGNS_TARGET_DIR)/mk/bsg_14.config.mk
include $(BSG_CHIP_DIR)/cad/setup/Makefile.include

########################################
## VCS OPTIONS
########################################

# Common VCS Options (will be used most of the time by all corners)
VCS_OPTIONS := -full64
VCS_OPTIONS += -notice
VCS_OPTIONS += -debug_pp
VCS_OPTIONS += -V
VCS_OPTIONS += +v2k
VCS_OPTIONS += -sverilog -assert svaext
VCS_OPTIONS += +noportcoerce
VCS_OPTIONS += +vc
VCS_OPTIONS += +vcs+loopreport
VCS_OPTIONS += -timescale=1ps/1ps
VCS_OPTIONS += -diag timescale 
VCS_OPTIONS += -o $(BSG_OUT_SIM)
VCS_OPTIONS += -Mdir=$(BSG_OUT_DIR)
VCS_OPTIONS += -top bsg_config bsg_config.v
VCS_OPTIONS += +warn=all,noOPD,noTMR,noTFIPC,noIWNF
VCS_OPTIONS += +define+den2048Mb+sg5+x16+FULL_MEM
VCS_OPTIONS += +vcs+lic+wait

# Additional options for Post-Synth
VCS_OPTIONS += +notimingcheck
VCS_OPTIONS += +nospecify

########################################
## Chip and Testing Filelists and Liblists
########################################

BSG_TOP_SIM_MODULE = bsg_gateway_chip
BSG_CHIP_INSTANCE_PATH = bsg_gateway_chip.DUT

VCS_OPTIONS += +define+BSG_TOP_SIM_MODULE=$(BSG_TOP_SIM_MODULE)
VCS_OPTIONS += +define+BSG_CHIP_INSTANCE_PATH=$(BSG_CHIP_INSTANCE_PATH)

export BSG_DESIGNS_TESTING_LIBRARY_NAME = bsg_design_testing
export BSG_DESIGNS_TESTING_FILELIST = $(BSG_OUT_DIR)/$(BSG_DESIGNS_TESTING_LIBRARY_NAME).filelist
export BSG_DESIGNS_TESTING_LIBRARY = $(BSG_OUT_DIR)/$(BSG_DESIGNS_TESTING_LIBRARY_NAME).library

VCS_OPTIONS += +define+BSG_DESIGNS_TESTING_LIBRARY_NAME=$(BSG_DESIGNS_TESTING_LIBRARY_NAME)
VCS_OPTIONS += -f $(BSG_DESIGNS_TESTING_FILELIST)
VCS_OPTIONS += -libmap $(BSG_DESIGNS_TESTING_LIBRARY)

export NETLIST_LIBRARY_NAME = netlist
export NETLIST_FILELIST = $(BSG_OUT_DIR)/$(NETLIST_LIBRARY_NAME).filelist
export NETLIST_LIBRARY = $(BSG_OUT_DIR)/$(NETLIST_LIBRARY_NAME).library

VCS_OPTIONS += +define+NETLIST_LIBRARY_NAME=$(NETLIST_LIBRARY_NAME)
VCS_OPTIONS += -f $(NETLIST_FILELIST)
VCS_OPTIONS += -libmap $(NETLIST_LIBRARY)

$(BSG_DESIGNS_TESTING_FILELIST): $(BSG_DESIGNS_TESTING_LIBRARY)
$(BSG_DESIGNS_TESTING_LIBRARY): $(BSG_OUT_DIR)
	/usr/bin/tclsh bsg_config.tcl

########################################
## BlackParrot test junk
########################################

PROG_LIST :=hello_world cache_hammer aha-compress ns qsort towers

%/prog.nbf:
	mkdir -p $(@D)
	python $(BLACKPARROT_DIR)/bp_common/software/py/nbf.py --ncpus 1 --config > $@

%/prog.mem:
	mkdir -p $(@D)
	@sed "s/@8/@0/g" $(BLACKPARROT_DIR)/bp_common/test/mem/$(lastword $(subst /, ,$(@D))).mem > $@

########################################
## Run Targets
########################################

BSG_RUN_DIRS := $(addsuffix /run, $(addprefix $(BSG_OUT_DIR)/, $(PROG_LIST)))
run_all: $(BSG_OUT_SIM)
	$(MAKE) $(BSG_RUN_DIRS)

%/run: $(BSG_OUT_SIM) %/prog.mem %/prog.nbf
	cd $(@D); ../simv | tee -i run.log

%/run-no-tee: $(BSG_OUT_SIM) %/prog.mem %/prog.nbf
	cd $(@D); ../simv

%/rerun: $(BSG_OUT_SIM)
	cd $(@D); ../simv | tee -i run.log

%/rerun-no-tee: $(BSG_OUT_SIM)
	cd $(@D); ../simv

%/view:
	cd $(@D); $(VCS_BIN)/dve -full64 -vpd vcdplus.vpd

build: $(BSG_OUT_SIM)
$(BSG_OUT_SIM): $(BSG_CHIP_FILELIST) $(BSG_CHIP_LIBRARY) $(BSG_DESIGNS_TESTING_FILELIST) $(BSG_DESIGNS_TESTING_LIBRARY)
	$(VCS) $(VCS_OPTIONS) | tee -i $(BSG_OUT_DIR)/build.log

$(BSG_OUT_DIR):
	mkdir -p $@

clean:
	rm -rf $(BSG_OUT_DIR)

