remove_individual_pin_constraints
remove_block_pin_constraints

### Just make sure that other layers are not used.
set_block_pin_constraints -allowed_layers { C4 C5 K1 K2 K3 K4 }

set tile_mem_cmd_pins_o   [get_ports -filter "name=~mem_*_o*"]
set tile_mem_resp_pins_i  [get_ports -filter "name=~mem_*_i*"]

set tile_io_cmd_pins_o    [get_ports -filter "name=~io_*cmd*_o*"]
set tile_io_resp_pins_i   [get_ports -filter "name=~io_*resp*_i*"]

set tile_io_cmd_pins_i    [get_ports -filter "name=~io_*cmd*_i*"]
set tile_io_resp_pins_o   [get_ports -filter "name=~io_*resp*_o*"]

set start_x [expr 0.128*1600]
set last_loc [bsg_pins_line_constraint $tile_mem_cmd_pins_o  "K2" top  $start_x "self" $tile_io_cmd_pins_o 1 0]
set start_x [expr 0.128*1600]
set last_loc [bsg_pins_line_constraint $tile_mem_resp_pins_i "K4" top  $start_x "self" $tile_io_resp_pins_i 1 0]
set start_y [expr 0.128*1600]
set last_loc [bsg_pins_line_constraint $tile_io_cmd_pins_i   "K1" left  $start_y "self" $tile_io_resp_pins_o 1 0]

set                  misc_pins [get_ports  -filter "name=~*clk_i"]
append_to_collection misc_pins [get_ports  -filter "name=~*reset_i"]

set start_x [expr 0.8 * 300]
set last_loc [bsg_pins_line_constraint $misc_pins "C5" top $start_x "self"]

