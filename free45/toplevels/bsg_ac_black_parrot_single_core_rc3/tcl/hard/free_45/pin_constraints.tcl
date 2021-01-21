remove_individual_pin_constraints
remove_block_pin_constraints

### Just make sure that other layers are not used.

set_block_pin_constraints -allowed_layers { metal3 metal2 metal5 metal4 }

# Master instance of the BP tile mibs
set master_tile "y_0__x_0__tile_node"

# Useful numbers for the master tile
set tile_llx    [lindex [get_attribute [get_cell -hier $master_tile] boundary_bbox] 0 0]
set tile_lly    [lindex [get_attribute [get_cell -hier $master_tile] boundary_bbox] 0 1]
set tile_width  [get_attribute [get_cell -hier $master_tile] width]
set tile_height [get_attribute [get_cell -hier $master_tile] height]
set tile_left   $tile_llx
set tile_right  [expr $tile_llx+$tile_width]
set tile_bottom $tile_lly
set tile_top    [expr $tile_lly+$tile_height]

set tile_req_pins_o       [get_pins -hier $master_tile/* -filter "name=~coh_lce_req_link_o*"]
set tile_req_pins_i       [get_pins -hier $master_tile/* -filter "name=~coh_lce_req_link_i*"]
set tile_cmd_pins_o       [get_pins -hier $master_tile/* -filter "name=~coh_lce_cmd_link_o*"]
set tile_cmd_pins_i       [get_pins -hier $master_tile/* -filter "name=~coh_lce_cmd_link_i*"]
set tile_resp_pins_o      [get_pins -hier $master_tile/* -filter "name=~coh_lce_resp_link_o*"]
set tile_resp_pins_i      [get_pins -hier $master_tile/* -filter "name=~coh_lce_resp_link_i*"]

set tile_mem_cmd_pins_o   [get_pins -hier $master_tile/* -filter "name=~mem_cmd_link_o*"]
set tile_mem_cmd_pins_i   [get_pins -hier $master_tile/* -filter "name=~mem_cmd_link_i*"]
set tile_mem_resp_pins_o  [get_pins -hier $master_tile/* -filter "name=~mem_resp_link_o*"]
set tile_mem_resp_pins_i  [get_pins -hier $master_tile/* -filter "name=~mem_resp_link_i*"]

set tile_req_pin_len       [expr [sizeof_collection $tile_req_pins_o] / 4]
set tile_cmd_pin_len       [expr [sizeof_collection $tile_cmd_pins_o] / 4]
set tile_resp_pin_len      [expr [sizeof_collection $tile_resp_pins_o] / 4]
set tile_mem_cmd_pin_len   [expr [sizeof_collection $tile_mem_cmd_pins_o] / 4]
set tile_mem_resp_pin_len  [expr [sizeof_collection $tile_mem_resp_pins_o] / 4]

# TODO: Refactor make list indexed by NSEW
set tile_req_pins_o_S      [index_collection $tile_req_pins_o       [expr 0*$tile_req_pin_len]        [expr 1*$tile_req_pin_len-1]]
set tile_req_pins_i_S      [index_collection $tile_req_pins_i       [expr 0*$tile_req_pin_len]        [expr 1*$tile_req_pin_len-1]]
set tile_cmd_pins_o_S      [index_collection $tile_cmd_pins_o       [expr 0*$tile_cmd_pin_len]        [expr 1*$tile_cmd_pin_len-1]]
set tile_cmd_pins_i_S      [index_collection $tile_cmd_pins_i       [expr 0*$tile_cmd_pin_len]        [expr 1*$tile_cmd_pin_len-1]]
set tile_resp_pins_o_S     [index_collection $tile_resp_pins_o      [expr 0*$tile_resp_pin_len]       [expr 1*$tile_resp_pin_len-1]]
set tile_resp_pins_i_S     [index_collection $tile_resp_pins_i      [expr 0*$tile_resp_pin_len]       [expr 1*$tile_resp_pin_len-1]]
set tile_mem_cmd_pins_o_S  [index_collection $tile_mem_cmd_pins_o   [expr 0*$tile_mem_cmd_pin_len]    [expr 1*$tile_mem_cmd_pin_len-1]]
set tile_mem_cmd_pins_i_S  [index_collection $tile_mem_cmd_pins_i   [expr 0*$tile_mem_cmd_pin_len]    [expr 1*$tile_mem_cmd_pin_len-1]]
set tile_mem_resp_pins_o_S [index_collection $tile_mem_resp_pins_o  [expr 0*$tile_mem_resp_pin_len]   [expr 1*$tile_mem_resp_pin_len-1]]
set tile_mem_resp_pins_i_S [index_collection $tile_mem_resp_pins_i  [expr 0*$tile_mem_resp_pin_len]   [expr 1*$tile_mem_resp_pin_len-1]]

set tile_req_pins_o_N      [index_collection $tile_req_pins_o       [expr 1*$tile_req_pin_len]        [expr 2*$tile_req_pin_len-1]]
set tile_req_pins_i_N      [index_collection $tile_req_pins_i       [expr 1*$tile_req_pin_len]        [expr 2*$tile_req_pin_len-1]]
set tile_cmd_pins_o_N      [index_collection $tile_cmd_pins_o       [expr 1*$tile_cmd_pin_len]        [expr 2*$tile_cmd_pin_len-1]]
set tile_cmd_pins_i_N      [index_collection $tile_cmd_pins_i       [expr 1*$tile_cmd_pin_len]        [expr 2*$tile_cmd_pin_len-1]]
set tile_resp_pins_o_N     [index_collection $tile_resp_pins_o      [expr 1*$tile_resp_pin_len]       [expr 2*$tile_resp_pin_len-1]]
set tile_resp_pins_i_N     [index_collection $tile_resp_pins_i      [expr 1*$tile_resp_pin_len]       [expr 2*$tile_resp_pin_len-1]]
set tile_mem_cmd_pins_o_N  [index_collection $tile_mem_cmd_pins_o   [expr 1*$tile_mem_cmd_pin_len]    [expr 2*$tile_mem_cmd_pin_len-1]]
set tile_mem_cmd_pins_i_N  [index_collection $tile_mem_cmd_pins_i   [expr 1*$tile_mem_cmd_pin_len]    [expr 2*$tile_mem_cmd_pin_len-1]]
set tile_mem_resp_pins_o_N [index_collection $tile_mem_resp_pins_o  [expr 1*$tile_mem_resp_pin_len]   [expr 2*$tile_mem_resp_pin_len-1]]
set tile_mem_resp_pins_i_N [index_collection $tile_mem_resp_pins_i  [expr 1*$tile_mem_resp_pin_len]   [expr 2*$tile_mem_resp_pin_len-1]]

set tile_req_pins_o_E      [index_collection $tile_req_pins_o       [expr 2*$tile_req_pin_len]        [expr 3*$tile_req_pin_len-1]]
set tile_req_pins_i_E      [index_collection $tile_req_pins_i       [expr 2*$tile_req_pin_len]        [expr 3*$tile_req_pin_len-1]]
set tile_cmd_pins_o_E      [index_collection $tile_cmd_pins_o       [expr 2*$tile_cmd_pin_len]        [expr 3*$tile_cmd_pin_len-1]]
set tile_cmd_pins_i_E      [index_collection $tile_cmd_pins_i       [expr 2*$tile_cmd_pin_len]        [expr 3*$tile_cmd_pin_len-1]]
set tile_resp_pins_o_E     [index_collection $tile_resp_pins_o      [expr 2*$tile_resp_pin_len]       [expr 3*$tile_resp_pin_len-1]]
set tile_resp_pins_i_E     [index_collection $tile_resp_pins_i      [expr 2*$tile_resp_pin_len]       [expr 3*$tile_resp_pin_len-1]]
set tile_mem_cmd_pins_o_E  [index_collection $tile_mem_cmd_pins_o   [expr 2*$tile_mem_cmd_pin_len]    [expr 3*$tile_mem_cmd_pin_len-1]]
set tile_mem_cmd_pins_i_E  [index_collection $tile_mem_cmd_pins_i   [expr 2*$tile_mem_cmd_pin_len]    [expr 3*$tile_mem_cmd_pin_len-1]]
set tile_mem_resp_pins_o_E [index_collection $tile_mem_resp_pins_o  [expr 2*$tile_mem_resp_pin_len]   [expr 3*$tile_mem_resp_pin_len-1]]
set tile_mem_resp_pins_i_E [index_collection $tile_mem_resp_pins_i  [expr 2*$tile_mem_resp_pin_len]   [expr 3*$tile_mem_resp_pin_len-1]]

set tile_req_pins_o_W      [index_collection $tile_req_pins_o       [expr 3*$tile_req_pin_len]        [expr 4*$tile_req_pin_len-1]]
set tile_req_pins_i_W      [index_collection $tile_req_pins_i       [expr 3*$tile_req_pin_len]        [expr 4*$tile_req_pin_len-1]]
set tile_cmd_pins_o_W      [index_collection $tile_cmd_pins_o       [expr 3*$tile_cmd_pin_len]        [expr 4*$tile_cmd_pin_len-1]]
set tile_cmd_pins_i_W      [index_collection $tile_cmd_pins_i       [expr 3*$tile_cmd_pin_len]        [expr 4*$tile_cmd_pin_len-1]]
set tile_resp_pins_o_W     [index_collection $tile_resp_pins_o      [expr 3*$tile_resp_pin_len]       [expr 4*$tile_resp_pin_len-1]]
set tile_resp_pins_i_W     [index_collection $tile_resp_pins_i      [expr 3*$tile_resp_pin_len]       [expr 4*$tile_resp_pin_len-1]]
set tile_mem_cmd_pins_o_W  [index_collection $tile_mem_cmd_pins_o   [expr 3*$tile_mem_cmd_pin_len]    [expr 4*$tile_mem_cmd_pin_len-1]]
set tile_mem_cmd_pins_i_W  [index_collection $tile_mem_cmd_pins_i   [expr 3*$tile_mem_cmd_pin_len]    [expr 4*$tile_mem_cmd_pin_len-1]]
set tile_mem_resp_pins_o_W [index_collection $tile_mem_resp_pins_o  [expr 3*$tile_mem_resp_pin_len]   [expr 4*$tile_mem_resp_pin_len-1]]
set tile_mem_resp_pins_i_W [index_collection $tile_mem_resp_pins_i  [expr 3*$tile_mem_resp_pin_len]   [expr 4*$tile_mem_resp_pin_len-1]]


# 0.04 = tile_height to track spacing
# 0.08*N = N tracks of space
# East/West pins - metal3, metal5
set start_y [expr 0.280*40]
set last_loc [bsg_pins_line_constraint $tile_req_pins_i_E      "metal4" right $start_y               $master_tile $tile_req_pins_o_W      1 0]
set last_loc [bsg_pins_line_constraint $tile_resp_pins_i_E     "metal4" right [expr $last_loc+0.560] $master_tile $tile_resp_pins_o_W     1 0]
set last_loc [bsg_pins_line_constraint $tile_cmd_pins_i_E      "metal4" right [expr $last_loc+0.560] $master_tile $tile_cmd_pins_o_W      1 0]

set last_loc [bsg_pins_line_constraint $tile_req_pins_o_E      "metal4" right [expr $last_loc+0.560] $master_tile $tile_req_pins_i_W      1 0]
set last_loc [bsg_pins_line_constraint $tile_resp_pins_o_E     "metal4" right [expr $last_loc+0.560] $master_tile $tile_resp_pins_i_W     1 0]
set last_loc [bsg_pins_line_constraint $tile_cmd_pins_o_E      "metal4" right [expr $last_loc+0.560] $master_tile $tile_cmd_pins_i_W      1 0]

set last_loc [bsg_pins_line_constraint $tile_mem_cmd_pins_i_E  "metal4" right $start_y               $master_tile $tile_mem_cmd_pins_o_W  1 0]
set last_loc [bsg_pins_line_constraint $tile_mem_resp_pins_i_E "metal4" right [expr $last_loc+0.560] $master_tile $tile_mem_resp_pins_o_W 1 0]

set last_loc [bsg_pins_line_constraint $tile_mem_cmd_pins_o_E  "metal4" right [expr $last_loc+0.560] $master_tile $tile_mem_cmd_pins_i_W  1 0]
set last_loc [bsg_pins_line_constraint $tile_mem_resp_pins_o_E "metal4" right [expr $last_loc+0.560] $master_tile $tile_mem_resp_pins_i_W 1 0]

# North/South pins - metal2, metal4
set start_x  [expr 0.280*40]
set last_loc [bsg_pins_line_constraint $tile_req_pins_i_N      "metal5" top   $start_y               $master_tile $tile_req_pins_o_S      1 0]
set last_loc [bsg_pins_line_constraint $tile_resp_pins_i_N     "metal5" top   [expr $last_loc+0.560] $master_tile $tile_resp_pins_o_S     1 0]
set last_loc [bsg_pins_line_constraint $tile_cmd_pins_i_N      "metal5" top   [expr $last_loc+0.560] $master_tile $tile_cmd_pins_o_S      1 0]

set last_loc [bsg_pins_line_constraint $tile_req_pins_o_N      "metal5" top   [expr $last_loc+0.560] $master_tile $tile_req_pins_i_S      1 0]
set last_loc [bsg_pins_line_constraint $tile_resp_pins_o_N     "metal5" top   [expr $last_loc+0.560] $master_tile $tile_resp_pins_i_S     1 0]
set last_loc [bsg_pins_line_constraint $tile_cmd_pins_o_N      "metal5" top   [expr $last_loc+0.560] $master_tile $tile_cmd_pins_i_S      1 0]

set last_loc [bsg_pins_line_constraint $tile_mem_cmd_pins_i_N  "metal5" top   $start_y               $master_tile $tile_mem_cmd_pins_o_S  1 0]
set last_loc [bsg_pins_line_constraint $tile_mem_resp_pins_i_N "metal5" top   [expr $last_loc+0.560] $master_tile $tile_mem_resp_pins_o_S 1 0]

set last_loc [bsg_pins_line_constraint $tile_mem_cmd_pins_o_N  "metal5" top   [expr $last_loc+0.560] $master_tile $tile_mem_cmd_pins_i_S  1 0]
set last_loc [bsg_pins_line_constraint $tile_mem_resp_pins_o_N "metal5" top   [expr $last_loc+0.560] $master_tile $tile_mem_resp_pins_i_S 1 0]

################################################################################
###
### MISC Pins. Slow signals in the center on the top, K4
###

set                  misc_pins [get_pins -hier $master_tile/* -filter "name=~*clk_i"]
append_to_collection misc_pins [get_pins -hier $master_tile/* -filter "name=~*reset_i"]
append_to_collection misc_pins [get_pins -hier $master_tile/* -filter "name=~*cord*"]
append_to_collection misc_pins [get_pins -hier $master_tile/* -filter "name=~*irq_i*"]

set start_x [expr 0.280 * 1800]
set last_loc [bsg_pins_line_constraint $misc_pins "metal5" top $start_x $master_tile {} 2 0]

### Set ports for top level
set prev_pins [get_ports "prev*"]
set next_pins [get_ports "next_*"]
set slow_pins [get_ports "*clk*"]
append_to_collection slow_pins [get_ports "*reset*"]
append_to_collection slow_pins [get_ports "*cord*"]

set start_y [expr 0.280*480]
set last_loc [bsg_pins_line_constraint $prev_pins "metal4" left $start_y self {} 1 0]

set start_y [expr 2500 - 0.280*480]
set last_loc [bsg_pins_line_constraint $next_pins "metal4" right $start_y self {} 1 0]

set start_x [expr 1200]
set last_loc [bsg_pins_line_constraint $slow_pins "metal5" top $start_x self {} 1 0]





