
# Select the design type for the toplevel. If set to 'block' then the toplevel
# will not have IO drivers but rather pins (good for creating hard-macros or
# for doing apr runs before the toplevel is ready). If set to 'chip_*' the
# toplevel will have IO drivers, and the die size is determined by the *. Only
# certain die sizes have been implemented. Right now only block is supported.

export BSG_TOPLEVEL_DESIGN_TYPE :=block

# Select the backend flow style (either hier or flat). This determines if ICC2
# is going to perform a hierarchical or flat physical implementation of the
# chip. When set to flat, you may still synthesize hierarchically. To
# synthesize flat, setup your design's hier.mk such that there is only a single
# block. If there is only a single block in your design's hier.mk, this
# variable has no affect and is effectively  forced to flat.

export BSG_FLOW_STYLE :=hier
#export BSG_FLOW_STYLE :=flat

# Select the target package. Inside of bsg_packaging there multiple packages to
# choose from that determine the intended package for the ASIC.

export BSG_PACKAGE :=

# Select the target pinout. For each package inside of bsg_packaging, there can
# be multiple specific pinouts defined. This selects the intended pinout for
# the ASIC.

export BSG_PINOUT :=

# Select the target packaging foundry. This is going to select IO cells for
# your specific process but for a given target process there may be multiple IP
# vendors that supply IO cells that we have support for therefore we don't just
# use the BSG_TARGET_PROCESS variables.

export BSG_PACKAGING_FOUNDRY :=

# Select the target padmapping. For each pinout inside of a package inside of
# bsg_packaging, there can be multiple padmappings. These padmappings often
# change configurations of various pads.

export BSG_PADMAPPING :=

# Select the power grid that we would like to use. The available power grids
# currently available are the following:
#   1. none => No straps or rings, just standard cell rails

export BSG_POWER_GRID :=none

# Select the power intent that we would like to use. The available power
# intents currently available are the following:
#   1. sv_standard => Single voltage domain - standard (VDD/VSS)

export BSG_POWER_INTENT :=sv_standard

#=======================================
# PDK Setup Overrides
#=======================================

export PDK_ENABLE_KIT_STDCELL :=true
export PDK_ENABLE_KIT_MEMGEN  :=true

export MEMGEN_JSON_FILE :=$(BSG_DESIGNS_TARGET_DIR)/json/memgen.json
