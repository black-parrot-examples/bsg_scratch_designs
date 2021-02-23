################################################################################
## Create Bounds
################################################################################

current_design ${DESIGN_NAME}

# Start script fresh
set_locked_objects -unlock [get_cells -hier]
remove_bounds -all
remove_edit_groups -all

set tile_height [core_height]
set tile_width  [core_width]

set keepout_margin_x 2
set keepout_margin_y 2
set keepout_margins [list $keepout_margin_x $keepout_margin_y $keepout_margin_x $keepout_margin_y]

#####################################
### I CACHE DATA
###

set icache_data_mems_bot [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*icache*data_mems_*"] 0 5]
set icache_data_ma_bot [create_macro_array \
  -num_rows 2 \
  -num_cols 3 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $icache_data_mems_bot]

create_keepout_margin -type hard -outer $keepout_margins $icache_data_mems_bot

set_macro_relative_location \
  -target_object $icache_data_ma_bot \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_corner bl \
  -offset [list 0 0]

set icache_data_mems_top [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*icache*data_mems_*"] 6 7]
set icache_data_ma_top [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $icache_data_mems_top]

create_keepout_margin -type hard -outer $keepout_margins $icache_data_mems_top

set_macro_relative_location \
  -target_object $icache_data_ma_top \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_object $icache_data_ma_bot \
  -anchor_corner tl \
  -offset [list 0 0]


#####################################
### I CACHE TAG
###

set icache_tag_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*icache*tag_mem*"]
set icache_tag_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $icache_tag_mems]

create_keepout_margin -type hard -outer $keepout_margins $icache_tag_mems

set_macro_relative_location \
  -target_object $icache_tag_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_object $icache_data_ma_bot \
  -anchor_corner br \
  -offset [list 0 0]

#####################################
### D CACHE DATA
###

set dcache_data_mems_bot [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*dcache*data_mem_*"] 0 5]
set dcache_data_ma_bot [create_macro_array \
  -num_rows 2 \
  -num_cols 3 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $dcache_data_mems_bot]

create_keepout_margin -type hard -outer $keepout_margins $dcache_data_mems_bot

set_macro_relative_location \
  -target_object $dcache_data_ma_bot \
  -target_corner br \
  -target_orientation R0 \
  -anchor_corner br \
  -offset [list 0 0]

set dcache_data_mems_top [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*dcache*data_mem_*"] 6 7]
set dcache_data_ma_top [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $dcache_data_mems_top]

create_keepout_margin -type hard -outer $keepout_margins $dcache_data_mems_top

set_macro_relative_location \
  -target_object $dcache_data_ma_top \
  -target_corner br \
  -target_orientation R0 \
  -anchor_object $dcache_data_ma_bot \
  -anchor_corner tr \
  -offset [list 0 0]


#####################################
### D CACHE TAG
###

set dcache_tag_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*dcache*tag_mem*"]
set dcache_tag_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $dcache_tag_mems]

create_keepout_margin -type hard -outer $keepout_margins $dcache_tag_mems

set_macro_relative_location \
  -target_object $dcache_tag_ma \
  -target_corner br \
  -target_orientation R0 \
  -anchor_object $dcache_data_ma_bot \
  -anchor_corner bl \
  -offset [list 0 0]

#####################################
### L2S DATA
###

set l2s_data_mems_c0_top [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*data_mem*db_0*"] 0 5]
set l2s_data_mems_west_top [concat $l2s_data_mems_c0_top]
set l2s_data_ma_west_top [create_macro_array \
  -num_rows 2 \
  -num_cols 3 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $l2s_data_mems_west_top]

create_keepout_margin -type hard -outer $keepout_margins $l2s_data_mems_west_top

set_macro_relative_location \
  -target_object $l2s_data_ma_west_top \
  -target_corner tl \
  -target_orientation R0 \
  -anchor_corner tl \
  -offset [list 0 0]

set l2s_data_mems_c0_bot [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*data_mem*db_0*"] 6 7]
set l2s_data_mems_west_bot [concat $l2s_data_mems_c0_bot]
set l2s_data_ma_west_bot [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $l2s_data_mems_west_bot]

create_keepout_margin -type hard -outer $keepout_margins $l2s_data_mems_west_bot

set_macro_relative_location \
  -target_object $l2s_data_ma_west_bot \
  -target_corner tl \
  -target_orientation R0 \
  -anchor_object $l2s_data_ma_west_top \
  -anchor_corner bl \
  -offset [list 0 0]

set l2s_data_mems_c1_top [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*data_mem*db_1*"] 0 5]
set l2s_data_mems_east_top [concat $l2s_data_mems_c1_top]
set l2s_data_ma_east_top [create_macro_array \
  -num_rows 2 \
  -num_cols 3 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $l2s_data_mems_east_top]

create_keepout_margin -type hard -outer $keepout_margins $l2s_data_mems_east_top

set_macro_relative_location \
  -target_object $l2s_data_ma_east_top \
  -target_corner tr \
  -target_orientation R0 \
  -anchor_corner tr \
  -offset [list 0 0]

set l2s_data_mems_c1_bot [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*data_mem*db_1*"] 6 7]
set l2s_data_mems_east_bot [concat $l2s_data_mems_c1_bot]
set l2s_data_ma_east_bot [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $l2s_data_mems_east_bot]

create_keepout_margin -type hard -outer $keepout_margins $l2s_data_mems_east_bot

set_macro_relative_location \
  -target_object $l2s_data_ma_east_bot \
  -target_corner tr \
  -target_orientation R0 \
  -anchor_object $l2s_data_ma_east_top \
  -anchor_corner br \
  -offset [list 0 0]

#####################################
### L2S TAG
###

set l2s_tag_mems_b0 [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*tag_mem*wb_0*"]
set l2s_tag_mems_west [concat $l2s_tag_mems_b0]
set l2s_tag_ma_west [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $l2s_tag_mems_west]

create_keepout_margin -type hard -outer $keepout_margins $l2s_tag_mems_west

set l2s_tag_margin 0
set_macro_relative_location \
  -target_object $l2s_tag_ma_west \
  -target_corner tl \
  -target_orientation R0 \
  -anchor_object $l2s_data_ma_west_top \
  -anchor_corner tr \
  -offset [list -$l2s_tag_margin 0]

set l2s_tag_mems_b1 [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*tag_mem*wb_1*"]
set l2s_tag_mems_east [concat $l2s_tag_mems_b1]
set l2s_tag_ma_east [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $l2s_tag_mems_east]

create_keepout_margin -type hard -outer $keepout_margins $l2s_tag_mems_east

set l2s_tag_margin 0
set_macro_relative_location \
  -target_object $l2s_tag_ma_east \
  -target_corner tr \
  -target_orientation R0 \
  -anchor_object $l2s_data_ma_east_top \
  -anchor_corner tl \
  -offset [list -$l2s_tag_margin 0]

####################################
### L2S STAT
###

set l2s_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*stat_mem*"]
set_macro_relative_location \
  -target_object $l2s_stat_mem \
  -target_corner tl \
  -target_orientation FN \
  -anchor_object $l2s_tag_ma_west \
  -anchor_corner bl \
  -offset [list $keepout_margin_x -$keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $l2s_stat_mem

#####################################
### BTB Memory
###

set btb_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/btb/*"]
set_macro_relative_location \
  -target_object $btb_mem \
  -target_corner bl \
  -target_orientation FN \
  -anchor_object $icache_data_ma_top \
  -anchor_corner br \
  -offset [list $keepout_margin_x $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $btb_mem

#####################################
### I CACHE STAT
###

set icache_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache*stat_mem/*"]
set_macro_relative_location \
  -target_object $icache_stat_mem \
  -target_corner bl \
  -target_orientation MY \
  -anchor_object $icache_tag_ma \
  -anchor_corner tl \
  -offset [list $keepout_margin_x $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $icache_stat_mem

#####################################
### INT + FP RF
###

set int_regfile_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/int_regfile/*"]
set fp_regfile_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/fp_regfile/*"]
set ireg_mem_height   [lindex [get_attribute [get_cell -hier $int_regfile_mems] height ] 0]
set ireg_mem_width    [lindex [get_attribute [get_cell -hier $int_regfile_mems] width ] 0]
set freg_mem_height   [lindex [get_attribute [get_cell -hier $fp_regfile_mems] height ] 0]
set freg_mem_width    [lindex [get_attribute [get_cell -hier $fp_regfile_mems] width ] 0]

set fp_regfile_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 3 \
  -align left \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $fp_regfile_mems]

set_macro_relative_location \
  -target_object $fp_regfile_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_corner bl \
  -offset [list [expr $tile_width/2-$freg_mem_width-2*$freg_mem_width-$keepout_margin_x*2] [expr $tile_height/2-$freg_mem_height/2]]

create_keepout_margin -type hard -outer $keepout_margins $fp_regfile_mems

set int_regfile_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align left \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation FN \
  $int_regfile_mems]

set_macro_relative_location \
  -target_object $int_regfile_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_object $fp_regfile_ma \
  -anchor_corner br \
  -offset [list $keepout_margin_x $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $int_regfile_mems

#####################################
### D CACHE STAT
###

set dcache_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*dcache*stat_mem*"]
set_macro_relative_location \
  -target_object $dcache_stat_mem \
  -target_corner br \
  -target_orientation R0 \
  -anchor_object $dcache_tag_ma \
  -anchor_corner tr \
  -offset [list -$keepout_margin_x $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $dcache_stat_mem



current_design bsg_chip
