set core_width 2500
set core_height 2500

# Number of blackparrot tiles
set num_bp_tiles 4
set tile_rows 2
set tile_cols 2

set channel_width 10
set channel_height 10

set keepout_margin_x 2
set keepout_margin_y 2
set keepout_margins [list $keepout_margin_x $keepout_margin_y $keepout_margin_x $keepout_margin_y]

set dcache_data_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*dcache*data_mem_*"]

set data_mem_width         [lindex [get_attribute [get_cell -hier $dcache_data_mems] width ] 0]
set data_mem_height        [lindex [get_attribute [get_cell -hier $dcache_data_mems] height] 0]

# TODO: Hack to get pins off the power grid
set pgrid_offset_y 1.08
set tile_height [round_up_to_nearest [expr 7*($data_mem_height+2*$keepout_margin_y)+$pgrid_offset_y] [unit_height]]
set tile_width [round_up_to_nearest $tile_height [unit_width]]

# Old width/height
#set tile_width [round_up_to_nearest 580.000 [unit_width]]
#set tile_height [round_up_to_nearest 581.080 [unit_height]]

set tile_x [expr $core_width/2 - $tile_width*$tile_cols/2 - $channel_width]
set tile_y [expr $core_height - $tile_height*$tile_rows - 35*$channel_height]

foreach {y} {1 0} {
  foreach {x} {0 1} {
    append_to_collection bp_tile_cells [get_cells -hier y_${y}__x_${x}__tile_node]
  }
}

# Shape the BP tile blocks
bsg_create_block_array_grid $bp_tile_cells \
  -grid mib_placement_grid \
  -relative_to core \
  -x $tile_x \
  -y $tile_y \
  -rows $tile_rows \
  -cols [expr $tile_cols] \
  -min_channel [list $channel_width $channel_height] \
  -width $tile_width \
  -height $tile_height

