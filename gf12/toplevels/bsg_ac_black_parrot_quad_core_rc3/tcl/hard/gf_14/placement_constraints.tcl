################################################################################
## Create Bounds
################################################################################

current_design ${DESIGN_NAME}

# Start script fresh
set_locked_objects -unlock [get_cells -hier]
remove_bounds -all
remove_edit_groups -all
remove_routing_corridors -all
remove_placement_blockages -all

#set core_height 2500
#set core_width 2500

set keepout_margin_x 2
set keepout_margin_y 2
set keepout_margins [list $keepout_margin_x $keepout_margin_y $keepout_margin_x $keepout_margin_y]

set master_tile "y_0__x_0__tile_node"
set tile_llx [lindex [get_attribute [get_cell -hier $master_tile] boundary_bbox] 0 0]
set tile_lly [lindex [get_attribute [get_cell -hier $master_tile] boundary_bbox] 0 1]
set tile_width [get_attribute [get_cell -hier $master_tile] width]
set tile_height [get_attribute [get_cell -hier $master_tile] height]

set end_tile "y_0__x_1__tile_node"
set end_tile_llx [lindex [get_attribute [get_cell -hier $end_tile] boundary_bbox] 0 0]
set end_tile_lly [lindex [get_attribute [get_cell -hier $end_tile] boundary_bbox] 0 1]
set end_tile_width [get_attribute [get_cell -hier $end_tile] width]
set end_tile_height [get_attribute [get_cell -hier $end_tile] height]

set tile_left       $tile_llx                            
set tile_right      [expr $tile_llx+$tile_width]         
set tile_bottom     $tile_lly                            
set tile_top        [expr $tile_lly+$tile_height]        

set end_tile_left   $end_tile_llx                        
set end_tile_right  [expr $end_tile_llx+$end_tile_width] 
set end_tile_bottom $end_tile_lly                        
set end_tile_top    [expr $end_tile_lly+$end_tile_height]

set io_complex_llx [expr $tile_left]
set io_complex_lly [expr $tile_top + 10]
set io_complex_urx [expr $end_tile_llx + $tile_width]
set io_complex_ury [round_up_to_nearest [expr $tile_top + 200] [unit_height]]

set io_complex_bound [create_bound -name "io_complex" -type soft -boundary [list [list $io_complex_llx $io_complex_lly] [list $io_complex_urx $io_complex_ury]]]
add_to_bound $io_complex_bound [get_cells -hier -filter "full_name=~*/ic/*"]

set mem_complex_llx [expr $tile_left]
set mem_complex_lly [expr $tile_bottom - $tile_height - 20 - 10]
set mem_complex_urx [expr $end_tile_llx + $tile_width]
set mem_complex_ury [round_up_to_nearest [expr $tile_bottom - $tile_height - 20 - 200] [unit_height]]

set mem_complex_bound [create_bound -name "mem_complex" -type soft -boundary [list [list $mem_complex_llx $mem_complex_lly] [list $mem_complex_urx $mem_complex_ury]]]
add_to_bound $mem_complex_bound [get_cells -hier -filter "full_name=~*/mc/*"]
add_to_bound $mem_complex_bound [get_cells -hier -filter "full_name=~*dram*"]

set tile0 [get_attribute [get_cell -hier "y_0__x_0__tile_node"] boundary_bbox]
set tile1 [get_attribute [get_cell -hier "y_0__x_1__tile_node"] boundary_bbox]
set tile2 [get_attribute [get_cell -hier "y_1__x_0__tile_node"] boundary_bbox]
set tile3 [get_attribute [get_cell -hier "y_1__x_1__tile_node"] boundary_bbox]

set top_box [list [list [expr [lindex $tile0 0 0] - 200] [expr [lindex $tile0 1 1] + 10]] [list [expr [lindex $tile1 1 0] + 200] [expr [lindex $tile1 1 1] + 200]]]
set bot_box [list [list [expr [lindex $tile2 0 0] - 200] [expr [lindex $tile2 0 0] - 200]] [list [expr [lindex $tile3 1 0] + 200] [expr [lindex $tile3 0 1] - 10]]]

set left_box [list [list [expr [lindex $tile0 0 0] - 200] [expr [lindex $tile2 0 1] - 200]] [list [expr [lindex $tile0 0 0] - 10] [expr [lindex $tile0 1 1] + 200]]]
set right_box [list [list [expr [lindex $tile1 1 0] + 10] [expr [lindex $tile3 0 1] - 200]] [list [expr [lindex $tile1 1 0] + 200] [expr [lindex $tile1 1 1] + 200]]]

#create_bound -name bypass_link_bound -type soft -boundary $bot_box [get_cells *bypass_link*]
#create_bound -name bypass_router_bound -type soft -boundary $bot_box [get_cells *bypass_router*]
#
#create_bound -name prev_bypass_bound -type soft -boundary $left_box [get_cells *prev_bypass_repeater]
#create_bound -name next_bypass_bound -type soft -boundary $right_box [get_cells *next_bypass_repeater]
#
#set prev_uplink_bound [create_bound -name "prev_uplink" -type soft -boundary {{237.0180 2014.3200} {307.1580 2763.1200}}]
#add_to_bound ${prev_uplink_bound} [get_cells -hier -filter "full_name=~prev/uplink/*"]
#
#set prev_downlink_bound [create_bound -name "prev_downlink" -type soft -boundary {{307.1580 2697.3600} {1040.0580 2763.1200}}]
#add_to_bound ${prev_downlink_bound} [get_cells -hier -filter "full_name=~prev/downlink/*"]
#add_to_bound ${prev_downlink_bound} [get_cells -hier -filter "full_name=~prev*"]
#
#set next_uplink_bound [create_bound -name "next_uplink" -type soft -boundary {{1959.9420 2697.3600} {2692.8420 2763.1200}}]
#add_to_bound ${next_uplink_bound} [get_cells -hier -filter "full_name=~next/uplink/*"]
#
#set next_downlink_bound [create_bound -name "next_downlink" -type soft -boundary {{2692.8420 2014.3200} {2762.9820 2763.1200}}]
#add_to_bound ${next_downlink_bound} [get_cells -hier -filter "full_name=~next/downlink/*"]
#add_to_bound ${next_downlink_bound} [get_cells -hier -filter "full_name=~next*"]
#
#set bt_bound [create_bound -name "bt_bound" -type soft -boundary $top_box]
#add_to_bound ${bt_bound} [get_cells *btm*]
#add_to_bound ${bt_bound} [get_cells *btc*]

set tile_blockage_box [list [list [lindex $tile2 0 0] [lindex $tile2 0 1]] [list [lindex $tile1 1 0] [lindex $tile1 1 1]]]
create_placement_blockage -type hard -boundary $tile_blockage_box
#create_routing_blockage -layers [get_layers] -boundary $tile_blockage_box -zero_spacing

#create_routing_corridor -name bypass_link_corridor -boundary $bot_box -object [get_nets *bypass_link*]
#create_routing_corridor -name prev_bypass_corridor -boundary $left_box -object [get_nets *repeated_prev*]
#create_routing_corridor -name next_bypass_corridor -boundary $right_box -object [get_nets *repeated_next*]

## BP Tile bounds
current_design bp_tile_node

# Start script fresh
set_locked_objects -unlock [get_cells -hier]
remove_bounds -all
remove_edit_groups -all


#####################################
### I CACHE DATA
###

set icache_data_mems_bot [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/data_mems_*"] 0 5]
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

set icache_data_mems_top [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/data_mems_*"] 6 7]
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

set icache_tag_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/tag_mem*"]
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

set dcache_data_mems_bot [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/data_mem_*"] 0 5]
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

set dcache_data_mems_top [index_collection [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/data_mem_*"] 6 7]
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

set dcache_tag_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/tag_mem*"]
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
  -orientation FN \
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
  -anchor_corner tr \
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

set icache_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/icache/stat_mem/*"]
set icache_stat_margin 0
set_macro_relative_location \
  -target_object $icache_stat_mem \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_object $icache_tag_ma \
  -anchor_corner br \
  -offset [list $icache_stat_margin $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $icache_stat_mem

#####################################
### INT RF
###

set int_regfile_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/int_regfile/*"]
set reg_mem_width    [lindex [get_attribute [get_cell -hier $int_regfile_mems] width ] 0]
set int_regfile_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 2 \
  -align left \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $int_regfile_mems]

set_macro_relative_location \
  -target_object $int_regfile_ma \
  -target_corner br \
  -target_orientation R0 \
  -anchor_object $dcache_data_ma_top \
  -anchor_corner bl \
  -offset [list 0 0]

create_keepout_margin -type hard -outer $keepout_margins $int_regfile_mems

#####################################
### D CACHE STAT
###

set dcache_stat_mem [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*/dcache/stat_mem*"]
set_macro_relative_location \
  -target_object $dcache_stat_mem \
  -target_corner br \
  -target_orientation R0 \
  -anchor_object $dcache_tag_ma \
  -anchor_corner bl \
  -offset [list -$keepout_margin_x $keepout_margin_y]

create_keepout_margin -type hard -outer $keepout_margins $dcache_stat_mem

#####################################
### CCE Directory
###

set directory_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*cce*directory*"]
set directory_mem_height [get_attribute -objects [index_collection $directory_mems 0] -name height]
set directory_mem_width [get_attribute -objects [index_collection $directory_mems 0] -name width]
set directory_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 8 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $directory_mems]

set_macro_relative_location \
  -target_object $directory_ma \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_corner bl \
  -offset [list [expr $tile_width/2-$directory_mem_width*4-$keepout_margin_x*4] [expr $tile_height/2]]

#####################################
### CCE Instr RAM
###

set cce_instr_ram [get_cells -design bp_tile_node -hier -filter "ref_name=~gf14_* && full_name=~*cce/*inst_ram*"]
set cce_instr_ram_width [get_attribute -objects $cce_instr_ram -name width]
set cce_instr_ma [create_macro_array \
  -num_rows 1 \
  -num_cols 1 \
  -align bottom \
  -horizontal_channel_height [expr $keepout_margin_y] \
  -vertical_channel_width [expr $keepout_margin_x] \
  -orientation N \
  $cce_instr_ram]

set_macro_relative_location \
  -target_object $cce_instr_ram \
  -target_corner bl \
  -target_orientation R0 \
  -anchor_object $directory_ma \
  -anchor_corner tl \
  -offset [list [expr $directory_mem_width*4-$cce_instr_ram_width/2] $keepout_margin_y]

current_design bsg_chip

