
set keepout_margin_x 2
set keepout_margin_y 2
set keepout_margins [list $keepout_margin_x $keepout_margin_y $keepout_margin_x $keepout_margin_y]

set dcache_data_mems [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*dcache*data_mem_*"]

set data_mem_width         [lindex [get_attribute [get_cell -hier $dcache_data_mems] width ] 0]
set data_mem_height        [lindex [get_attribute [get_cell -hier $dcache_data_mems] height] 0]

set tile_height [round_up_to_nearest [expr 6*($data_mem_height +2*$keepout_margin_x)] [unit_height]]
set tile_width [expr 1.25*$tile_height]

initialize_floorplan        \
  -control_type die         \
  -coincident_boundary true \
  -shape R                  \
  -core_utilization 0.80    \
  -core_offset 0.0          \
  -side_length [list $tile_width $tile_height]


