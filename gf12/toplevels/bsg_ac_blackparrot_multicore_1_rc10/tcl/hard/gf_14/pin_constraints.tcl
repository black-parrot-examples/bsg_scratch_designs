remove_individual_pin_constraints
remove_block_pin_constraints

set tile_width [core_width]
set tile_height [core_height]

### Just make sure that other layers are not used.
set_block_pin_constraints -allowed_layers { C4 C5 K1 K2 K3 K4 }

set tile_dma_pins_o   [get_ports -filter "name=~dma_*_o*"]
set tile_dma_pins_i   [get_ports -filter "name=~dma_*_i*"]

set tile_io_pins_o    [get_ports -filter "name=~io_*_o*"]
set tile_io_pins_i    [get_ports -filter "name=~io_*_i*"]

set k_pitch 0.128
set c_pitch 0.160

set io_pins_len [sizeof_collection $tile_io_pins_o]
set start_x [expr ($tile_width / 2) - ($k_pitch*$io_pins_len/2)]
set last_loc [bsg_pins_line_constraint $tile_io_pins_o  "K2 K4" top  $start_x "self" $tile_io_pins_i 1 0]

set dma_pins_len [sizeof_collection $tile_dma_pins_o]
set start_x [expr ($tile_width / 2) - (2*$c_pitch*$dma_pins_len/2)]
set last_loc [bsg_pins_line_constraint $tile_dma_pins_o "C5" top  $start_x "self"]
set last_loc [bsg_pins_line_constraint $tile_dma_pins_i "C5" bottom $start_x "self"]

set                  misc_pins [get_ports  -filter "name=~*clk_i"]
append_to_collection misc_pins [get_ports  -filter "name=~*reset_i"]

set misc_pins_len [expr [sizeof_collection $misc_pins]]
set start_y [expr ($tile_height / 2)  - (2*$c_pitch*$misc_pins_len/2)]
set last_loc [bsg_pins_line_constraint $misc_pins "C4" left $start_y "self"]

