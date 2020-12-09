###################
# Design Variables
###################

# Select the design type for the toplevel. If set to 'block' then the toplevel
# will not have IO drivers but rather pins (good for creating hard-macros or
# for doing apr runs before the toplevel is ready). If set to 'chip_*' the
# toplevel will have IO drivers, and the die size is determined by the *. Only
# certain die sizes have been implemented. Right now only 3x3mm is supported.

export BSG_TOPLEVEL_DESIGN_TYPE :=block
#export BSG_TOPLEVEL_DESIGN_TYPE :=chip_3x3

# Select the backend flow style (either hier or flat). This determines if ICC2
# is going to perform a hierarchical or flat physical implementation of the
# chip. When set to flat, you may still synthesize hierarchically. To
# synthesize flat, setup your design's hier.mk such that there is only a single
# block. If there is only a single block in your design's hier.mk, this
# variable has no effect and is effectively  forced to flat.

export BSG_FLOW_STYLE :=hier
#export BSG_FLOW_STYLE :=flat

# Select if the backend flor is going to perform Design Planning (DP). Design
# planning is about 10 additional steps that occurs before any placement and
# routing actually occurs. These steps are used to partition the physical
# hierarchy and implement a full-chip floorplan early on in the building flow.
# It is possible to skip this step and go directly to place and route however
# this may result is poor QoR, particularly for hierarchical flows.

export BSG_FLOW_USE_DP :=true
#export BSG_FLOW_USE_DP :=false

# Select the target package. Inside of bsg_packaging there multiple packages to
# choose from that determine the intended package for the ASIC.

export BSG_PACKAGE :=uw_bga

# Select the target pinout. For each package inside of bsg_packaging, there can
# be multiple specific pinouts defined. This selects the intended pinout for
# the ASIC.

export BSG_PINOUT :=bsg_asic_cloud

# Select the target packaging foundry. This is going to select IO cells for
# your specific process but for a given target process there may be multiple IP
# vendors that supply IO cells that we have support for therefore we don't just
# use the BSG_TARGET_PROCESS variables.

export BSG_PACKAGING_FOUNDRY :=gf_14_invecas_1p8v

# Select the target padmapping. For each pinout inside of a package inside of
# bsg_packaging, there can be multiple padmappings. These padmappings often
# change configurations of various pads.

export BSG_PADMAPPING :=default

# Select the target power grid. We have multiple power grid implementations
# that can be used. Currently available power grids include none, default_wb
export BSG_POWER_GRID :=none

# Select the target power intent. The power intent contains the power ports
# and nets that will be available as well as maps cells to power domains.
# Currently available power intents: sv_standard, mv_standard_pll
export BSG_POWER_INTENT :=sv_standard

###################
# Flow Variables
###################

# Change the CAD setup file that is used throughout the flow.
# This has a HUGE impact on run time and QoR. The default setup is default.
# Available options are:
# - default
#     puts the CAD flow into the highest effort signoff quality mode we have.
# - tt_only
#     puts the CAD flow into a single scenario mode (typical corner).
export BSG_CAD_SETUP :=tt_only

# Overrides the default memgen.json in bsg_14. Only these memories will be
# generated when running make prep; however, SRAMs which have already been
# generated will not be removed.
export PREP_MEMGEN_JSON_FILE :=$(BSG_DESIGNS_TARGET_DIR)/scripts/harden/bsg_14.memgen.json

# Selects the RM+ flow for DC. This is part of the Synopsys Reference
# Methodology and controls the effort and optimizations performed during
# synthesis. Available options are the following:
# - blank (like set this to an empty string…)
#     This is the default mode and is the most balanced
# - hc
#     High-connectivity is design to optimize area and density
# - hplp
#     High-performance, low-power is designed to optimize performance
#     in terms of speed and power at the expense of area
# - rtm_exp
#     Runtime exploration is designed to be quick and used for early experiments
export DC_FLOW_RMPLUS_FLOW :=rtm_exp

# Turns on topographical mode to take into physical design constraints and wire
# delay. This will increase runtime significantly and if the constraints are
# not setcorrectly can actually reduce QoR for designs with lots of
# structure (like large mesh topographies).
export DC_FLOW_ENABLE_TOPOGRAPHICAL_MODE :=false

# Turns off automatic clock gate insertion during synthesis compilation.
export DC_FLOW_COMPILE_DISABLE_CLOCK_GATING :=false

# Turns on design flattening during synthesis compilation,
# removing all logical hierarchy in the design.
export DC_FLOW_COMPILE_FLATTEN_DESIGN :=false

# Turns off register retiming during synthesis compilation. Note: even when
# retiming is enabled, register retiming is only performed on registers
# that have been marked in the design constraints.
export DC_FLOW_COMPILE_DISABLE_RETIMING :=false

# The same as DC_FLOW_COMPILE_DISABLE_CLOCK_GATING but for the incremental
# compile stage of synthesis (note: depending on the value of
# DC_FLOW_RMPLUS_FLOW, incremental compilation might not be executed).
export DC_FLOW_INCREMENTAL_COMPILE_DISABLE_CLOCK_GATING :=false

# The same as DC_FLOW_COMPILE_FLATTEN_DESIGN but for the incremental compile
# stage of synthesis (note: depending on the value of DC_FLOW_RMPLUS_FLOW,
# incremental compilation might not be executed).
export DC_FLOW_INCREMENTAL_COMPILE_FLATTEN_DESIGN :=false

# The same as DC_FLOW_COMPILE_DISABLE_RETIMING, but for the incremental
# compile stage of synthesis (note: depending on the value of
# DC_FLOW_RMPLUS_FLOW, incremental compilation might not be executed).
export DC_FLOW_INCREMENTAL_COMPILE_DISABLE_RETIMING :=false

# The path to a set of SAIF files to use for power analysis in PTSI.
#export PTSI_FLOW_ACTIVITY_FILE    :=$(abspath $(wildcard ../testing/post_apr_ff/out/*/*.saif))
export PTSI_FLOW_ACTIVITY_FILE    :=$(abspath $(wildcard ../testing/post_ptsi_sdf/out/*/*.saif))

# The relative weights of each activity file. Does not need to be normalized.
export PTSI_FLOW_ACTIVITY_WEIGHTS :=$(foreach _,$(PTSI_FLOW_ACTIVITY_FILE), 1.0)

# The module hierarchy to strip from the SAIF file.
# Most often this is the path to the DUT starting from the testbench.
export PTSI_FLOW_STRIP_PATH       :=bsg_gateway_chip/DUT

