################################################################################
## Create Bounds
################################################################################

current_design ${DESIGN_NAME}

# Start script fresh
set_locked_objects -unlock [get_cells -hier]
remove_bounds -all
remove_edit_groups -all

set core_height 600
set core_width 600

set keepout_margin_x 2
set keepout_margin_y 2
set keepout_margins [list $keepout_margin_x $keepout_margin_y $keepout_margin_x $keepout_margin_y]

### I CACHE DATA
###

set icache_data_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/data_mems_*"]
set icache_data_ma [create_macro_array \
  -num_rows 2 \
  -num_cols 4 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation FN \
  $icache_data_mems]

create_keepout_margin -type hard -outer $keepout_margins $icache_data_mems

set_macro_relative_location \
  -target_object $icache_data_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_corner bl \
  -offset [list 0 0]


#####################################
### I CACHE TAG
###

set icache_tag_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/tag_mem*"]
set icache_tag_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation FN \
  $icache_tag_mems]

create_keepout_margin -type hard -outer $keepout_margins $icache_tag_mems

set icache_tag_margin 0
set_macro_relative_location \
  -target_object $icache_tag_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_object $icache_data_ma \
  -anchor_corner tl \
  -offset [list $icache_tag_margin 0]

#####################################
### I CACHE STAT
###

#set icache_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/stat_mem/*"]
#set icache_stat_margin 0
#set_macro_relative_location \
#  -target_object $icache_stat_mem \
#  -target_corner bl \
#  -target_orientation MY \
#  -anchor_object $icache_tag_ma \
#  -anchor_corner br \
#  -offset [list $icache_stat_margin $keepout_margin_y]
#
#create_keepout_margin -type hard -outer $keepout_margins $icache_stat_mem

#####################################
### D CACHE DATA
###

set dcache_data_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/data_mem_*"]
set dcache_data_ma [create_macro_array \
  -num_rows 2 \
  -num_cols 4 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation N \
  $dcache_data_mems]

create_keepout_margin -type hard -outer $keepout_margins $dcache_data_mems

set_macro_relative_location \
  -target_object $dcache_data_ma \
  -target_corner br \
  -target_orientation R0 \
  -anchor_corner br \
  -offset [list 0 0]

#####################################
### D CACHE TAG
###

set dcache_tag_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/tag_mem*"]
set dcache_tag_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation N \
  $dcache_tag_mems]

create_keepout_margin -type hard -outer $keepout_margins $dcache_tag_mems

set dcache_tag_margin 0
set_macro_relative_location \
  -target_object $dcache_tag_ma \
  -target_corner br \
  -target_orientation R0 \
  -anchor_object $dcache_data_ma \
  -anchor_corner tr \
  -offset [list -$dcache_tag_margin 0]

#####################################
### D CACHE STAT
###

#set dcache_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/stat_mem*"]
#set dcache_stat_margin 0
#set_macro_relative_location \
#  -target_object $dcache_stat_mem \
#  -target_corner br \
#  -target_orientation R0 \
#  -anchor_object $dcache_tag_ma \
#  -anchor_corner bl \
#  -offset [list -$dcache_stat_margin $keepout_margin_y]
#
#create_keepout_margin -type hard -outer $keepout_margins $dcache_stat_mem

#####################################
### L2S DATA
###

set l2s_data_mems_c0 [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*data_mem*db_0*"]
set l2s_data_mems_west [concat $l2s_data_mems_c0]
set l2s_data_ma_west [create_macro_array \
  -num_rows 2 \
  -num_cols 4 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation FN \
  $l2s_data_mems_west]

create_keepout_margin -type hard -outer $keepout_margins $l2s_data_mems_west

set_macro_relative_location \
  -target_object $l2s_data_ma_west \
  -target_corner tl \
  -target_orientation R0 \
  -anchor_corner tl \
  -offset [list 0 0]

set l2s_data_mems_c1 [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*data_mem*db_1*"]
set l2s_data_mems_east [concat $l2s_data_mems_c1]
set l2s_data_ma_east [create_macro_array \
  -num_rows 2 \
  -num_cols 4 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation N \
  $l2s_data_mems_east]

create_keepout_margin -type hard -outer $keepout_margins $l2s_data_mems_east

set_macro_relative_location \
  -target_object $l2s_data_ma_east \
  -target_corner tr \
  -target_orientation R0 \
  -anchor_corner tr \
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
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation FN \
  $l2s_tag_mems_west]

create_keepout_margin -type hard -outer $keepout_margins $l2s_tag_mems_west

set l2s_tag_margin 0
set_macro_relative_location \
  -target_object $l2s_tag_ma_west \
  -target_corner tl \
  -target_orientation R0 \
  -anchor_object $l2s_data_ma_west \
  -anchor_corner tr \
  -offset [list -$l2s_tag_margin 0]

set l2s_tag_mems_b1 [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*l2s*tag_mem*wb_1*"]
set l2s_tag_mems_east [concat $l2s_tag_mems_b1]
set l2s_tag_ma_east [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align bottom \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation N \
  $l2s_tag_mems_east]

create_keepout_margin -type hard -outer $keepout_margins $l2s_tag_mems_east

set l2s_tag_margin 0
set_macro_relative_location \
  -target_object $l2s_tag_ma_east \
  -target_corner tr \
  -target_orientation R0 \
  -anchor_object $l2s_data_ma_east \
  -anchor_corner tl \
  -offset [list -$l2s_tag_margin 0]

#####################################
### BTB Memory
###

#set btb_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/btb/*"]
#set_macro_relative_location \
#  -target_object $btb_mem \
#  -target_corner br \
#  -target_orientation R0 \
#  -anchor_corner br \
#  -offset [list [expr -$tile_width/2-$keepout_margin_x] $keepout_margin_y]
#
#create_keepout_margin -type hard -outer $keepout_margins $btb_mem

#####################################
### INT RF
###

set int_regfile_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/int_regfile/*"]
set reg_mem_width    [lindex [get_attribute [get_cell -hier $int_regfile_mems] width ] 0]
set int_regfile_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align left \
  -horizontal_channel_height [expr 2*$keepout_margin_y] \
  -vertical_channel_width [expr 2*$keepout_margin_x] \
  -orientation FN \
  $int_regfile_mems]

set_macro_relative_location \
  -target_object $int_regfile_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_corner bl \
  -offset [list [expr $core_width/2 - $reg_mem_width - $keepout_margin_x] $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $int_regfile_mems


current_design bsg_chip
