.DEFAULT_GOAL=run

# Note: most variables that are file/dir paths are ?= because they can be
# overriden by the chip repo if this makefile is called from the chip
# infrastructure.

export TOP_DIR                ?= $(shell git rev-parse --show-toplevel)
export BSG_DESIGNS_DIR        ?= $(abspath $(TOP_DIR))/free45
export BSG_DESIGNS_TARGET     ?= bsg_ac_black_parrot_single_core_rc3
export BSG_DESIGNS_TARGET_DIR ?= $(BSG_DESIGNS_DIR)/toplevels/$(BSG_DESIGNS_TARGET)
export BSG_DESIGNS_TARGET_TCL_HARD_DIR ?= $(BSG_DESIGNS_TARGET_DIR)/tcl/hard/free_45

BSG_WORK_DIR := $(abspath ./)
BSG_OUT_DIR  := $(BSG_WORK_DIR)/out
BSG_OUT_SIM  := $(BSG_OUT_DIR)/simv

include $(BSG_DESIGNS_TARGET_DIR)/bsg_cadenv/cadenv.mk

# Repository setup
export BASEJUMP_STL_DIR       ?= $(BSG_DESIGNS_TARGET_DIR)/basejump_stl
export BSG_PACKAGING_DIR      ?= $(BSG_DESIGNS_TARGET_DIR)/bsg_packaging
export BLACK_PARROT_DIR       ?= $(BSG_DESIGNS_TARGET_DIR)/black-parrot
export BOARD_DIR              ?= $(BSG_DESIGNS_TARGET_DIR)/board

export BSG_PACKAGE           ?=
export BSG_PINOUT            ?=
export BSG_PACKAGING_FOUNDRY ?=
export BSG_PADMAPPING        ?=

export BLACK_PARROT_COMMON_DIR ?= $(BLACK_PARROT_DIR)/bp_common
export BLACK_PARROT_TOP_DIR    ?= $(BLACK_PARROT_DIR)/bp_top
export BLACK_PARROT_FE_DIR     ?= $(BLACK_PARROT_DIR)/bp_fe
export BLACK_PARROT_BE_DIR     ?= $(BLACK_PARROT_DIR)/bp_be
export BLACK_PARROT_ME_DIR     ?= $(BLACK_PARROT_DIR)/bp_me


# Additional setup for RTL-Hard
export BSG_CHIP_DIR             ?= $(BSG_DESIGNS_TARGET_DIR)/bsg_45
export MEMGEN_RUN_DIR           ?= $(BSG_CHIP_DIR)/sources/memgen
export BSG_TOPLEVEL_DESIGN_TYPE ?= block
export BSG_TARGET_PROCESS       ?= free45

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
VCS_OPTIONS += +memcbk
VCS_OPTIONS += +vcs+vcdpluson
VCS_OPTIONS += -timescale=1ps/1ps
VCS_OPTIONS += -diag timescale 
VCS_OPTIONS += -o $(BSG_OUT_SIM)
VCS_OPTIONS += -Mdir=$(BSG_OUT_DIR)
VCS_OPTIONS += -top bsg_config bsg_config.v

VCS_OPTIONS += +vcs+finish+5000000000ps
VCS_OPTIONS += +vcs+loopdetect +vcs+loopreport

# DRAMSim2
VCS_OPTIONS += -CFLAGS "-I$(BLACK_PARROT_DIR)/external/include -std=c++11"
VCS_OPTIONS += -LDFLAGS "-L$(BLACK_PARROT_DIR)/external/lib -ldramsim -Wl,-rpath=$(BLACK_PARROT_DIR)/external/lib"

# Additional options for RTL-Hard
VCS_OPTIONS += +notimingcheck
VCS_OPTIONS += +nospecify

########################################
## Chip and Testing Filelists and Liblists
########################################

BSG_TOP_SIM_MODULE = bsg_gateway_chip
BSG_CHIP_INSTANCE_PATH = bsg_gateway_chip.DUT

VCS_OPTIONS += +define+BSG_TOP_SIM_MODULE=$(BSG_TOP_SIM_MODULE)
VCS_OPTIONS += +define+BSG_CHIP_INSTANCE_PATH=$(BSG_CHIP_INSTANCE_PATH)

export BSG_CHIP_LIBRARY_NAME = bsg_chip
export BSG_CHIP_FILELIST = $(BSG_OUT_DIR)/$(BSG_CHIP_LIBRARY_NAME).filelist
export BSG_CHIP_LIBRARY = $(BSG_OUT_DIR)/$(BSG_CHIP_LIBRARY_NAME).library

VCS_OPTIONS += +define+BSG_CHIP_LIBRARY_NAME=$(BSG_CHIP_LIBRARY_NAME)
VCS_OPTIONS += -f $(BSG_CHIP_FILELIST)
VCS_OPTIONS += -libmap $(BSG_CHIP_LIBRARY)

export BSG_DESIGNS_TESTING_LIBRARY_NAME = bsg_design_testing
export BSG_DESIGNS_TESTING_FILELIST = $(BSG_OUT_DIR)/$(BSG_DESIGNS_TESTING_LIBRARY_NAME).filelist
export BSG_DESIGNS_TESTING_LIBRARY = $(BSG_OUT_DIR)/$(BSG_DESIGNS_TESTING_LIBRARY_NAME).library

VCS_OPTIONS += +define+BSG_DESIGNS_TESTING_LIBRARY_NAME=$(BSG_DESIGNS_TESTING_LIBRARY_NAME)
VCS_OPTIONS += -f $(BSG_DESIGNS_TESTING_FILELIST)
VCS_OPTIONS += -libmap $(BSG_DESIGNS_TESTING_LIBRARY)
VCS_OPTIONS += +define+den2048Mb+sg5+x16+FULL_MEM

$(BSG_CHIP_FILELIST): $(BSG_DESIGNS_TESTING_LIBRARY)
$(BSG_CHIP_LIBRARY): $(BSG_DESIGNS_TESTING_LIBRARY)
$(BSG_DESIGNS_TESTING_FILELIST): $(BSG_DESIGNS_TESTING_LIBRARY)
$(BSG_DESIGNS_TESTING_LIBRARY): $(BSG_OUT_DIR)
	/usr/bin/tclsh bsg_config.tcl

########################################
## Trace Replay Roms
########################################

BSG_TRACE_FILES := $(notdir $(wildcard $(BSG_WORK_DIR)/../traces/*.tr))
BSG_TRACE_ROMS  := $(addprefix $(BSG_OUT_DIR)/,${BSG_TRACE_FILES:.tr=_rom.v})

$(BSG_OUT_DIR)/%_rom.v: $(BSG_WORK_DIR)/../traces/%.tr | $(BSG_OUT_DIR)
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_ascii_to_rom.py $< $*_rom > $@

VCS_OPTIONS += $(addprefix -v ,$(BSG_TRACE_ROMS))

########################################
## BlackParrot test junk
########################################

PROG     :=hello_world
DRAM_CH  :=DDR3_micron_32M_8B_x8_sg25E.ini
DRAM_SYS :=system.ini

prog.mem:
	@cp $(BLACK_PARROT_COMMON_DIR)/test/mem/$(PROG).mem $(BSG_OUT_DIR)/$@

prog.dump:
	@cp $(BLACK_PARROT_COMMON_DIR)/test/mem/$(PROG).dump $(BSG_OUT_DIR)/$@

dram_ch.ini:
	@cp $(BLACK_PARROT_COMMON_DIR)/test/cfg/$(DRAM_CH) $(BSG_OUT_DIR)/$@

dram_sys.ini:
	@cp $(BLACK_PARROT_COMMON_DIR)/test/cfg/$(DRAM_SYS) $(BSG_OUT_DIR)/$@

cce_ucode.mem:
	@cp $(BLACK_PARROT_ME_DIR)/src/asm/roms/mesi.mem $(BSG_OUT_DIR)/$@

prog.nbf: prog.mem cce_ucode.mem
	python $(BLACK_PARROT_COMMON_DIR)/software/py/nbf.py 1 $(BSG_OUT_DIR)/cce_ucode.mem --mem=$(BSG_OUT_DIR)/prog.mem > $(BSG_OUT_DIR)/$@

bootrom:
	cp $(BLACK_PARROT_COMMON_DIR)/test/mem/bootrom.riscv $(BSG_OUT_DIR)/bootrom.riscv
	cp $(BLACK_PARROT_COMMON_DIR)/test/mem/bootrom.mem $(BSG_OUT_DIR)/bootrom.mem
	
########################################
## Run Targets
########################################

run: clean $(BSG_OUT_SIM)
	cd $(BSG_OUT_DIR); ./simv | tee -i $(BSG_OUT_DIR)/run.log

run-no-tee: clean $(BSG_OUT_SIM)
	cd $(BSG_OUT_DIR); ./simv

rerun: $(BSG_OUT_SIM)
	cd $(BSG_OUT_DIR); ./simv | tee -i $(BSG_OUT_DIR)/run.log

rerun-no-tee: $(BSG_OUT_SIM)
	cd $(BSG_OUT_DIR); ./simv

view:
	cd $(BSG_OUT_DIR); $(VCS_BIN)/dve -full64 -vpd vcdplus.vpd

build: $(BSG_OUT_SIM)
$(BSG_OUT_SIM): $(BSG_CHIP_FILELIST) $(BSG_CHIP_LIBRARY) $(BSG_DESIGNS_TESTING_FILELIST) $(BSG_DESIGNS_TESTING_LIBRARY) $(BSG_TRACE_ROMS) prog.mem prog.dump cce_ucode.mem dram_ch.ini dram_sys.ini prog.nbf bootrom
	$(VCS) $(VCS_OPTIONS) | tee -i $(BSG_OUT_DIR)/build.log

$(BSG_OUT_DIR):
	mkdir -p $@

clean:
	rm -rf $(BSG_OUT_DIR)
	rm -rf DVEfiles
	rm -rf stack.info.*
	rm -f  vc_hdrs.h
	rm -f  vcdplus.vpd
	rm -f  inter.vpd
	rm -f  ucli.key
	rm -f  main.riscv main_dmem.mem main_dram.mem

