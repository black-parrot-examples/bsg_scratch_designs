#===============================================================================
# mk/hier.mk
#
# This partial makefile is used to describe the physical hierarchy for the cad
# flow. There are three variables that must be set: TOP_HIER_BLOCK,
# MID_HIER_BLOCKS, and BOT_HIER_BLOCKS. TOP_HIER_BLOCK is a single item and is
# the name of the toplvel modules. MID_HIER_BLOCKS is a list of all
# hierarchical blocks that have sub-blocks (either another mid-level block or a
# bottom-level block). Finally, BOT_HIER_BLOCKS is a list of all hierarchical
# blocks with no sub-block dependancies.
#
# Note: If the are inter mid-level block dependancies, specify the lower-level
# mid-level blocks first in the MID_HIER_BLOCKS list.
#===============================================================================

export TOP_HIER_BLOCK  := bsg_manycore_tile_compute_ruche_wrapper
export MID_HIER_BLOCKS :=
export BOT_HIER_BLOCKS :=

