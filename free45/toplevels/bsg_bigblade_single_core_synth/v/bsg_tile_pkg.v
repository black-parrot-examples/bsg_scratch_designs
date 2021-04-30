`ifndef BSG_TILE_PKG_V
`define BSG_TILE_PKG_V

package bsg_tile_pkg;

  `include "bsg_defines.v"

  localparam dmem_size_p = 1024;
  localparam vcache_size_p = 2048;
  localparam icache_entries_p = 1024;
  localparam icache_tag_width_p = 12;
  localparam x_cord_width_p = 7;
  localparam y_cord_width_p = 7;
  localparam pod_x_cord_width_p = 3;
  localparam pod_y_cord_width_p = 4;

  localparam num_tiles_x_p = 16;
  localparam num_tiles_y_p = 8;


endpackage 

`endif

