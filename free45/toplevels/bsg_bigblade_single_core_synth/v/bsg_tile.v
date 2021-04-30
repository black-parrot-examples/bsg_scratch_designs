/**
 *  bsg_tile.v
 *
 */

module bsg_tile
  import bsg_noc_pkg::*; // { P=0, W,E,N,S }
  import bsg_manycore_pkg::*;
  import bsg_tile_pkg::*;
  #(parameter x_subcord_width_lp = `BSG_SAFE_CLOG2(num_tiles_x_p)
    , parameter y_subcord_width_lp = `BSG_SAFE_CLOG2(num_tiles_y_p)

    , parameter ruche_factor_X_p = 3
    
    , parameter data_width_p = 32
    , parameter addr_width_p = 28

    , parameter num_vcache_rows_p = 1
    , parameter vcache_block_size_in_words_p=8
    , parameter vcache_sets_p=64

    , parameter dims_p = 3
    , parameter dirs_lp = (dims_p*2)

    , parameter stub_p = {dirs_lp{1'b0}}           // {re,rw,s,n,e,w}
    , parameter repeater_output_p = {dirs_lp{1'b0}} // {re,rw,s,n,e,w}
    , parameter hetero_type_p = 0
    , parameter debug_p = 0

    , parameter link_sif_width_lp =
      `bsg_manycore_link_sif_width(addr_width_p,data_width_p,x_cord_width_p,y_cord_width_p)
    , parameter ruche_x_link_sif_width_lp =
      `bsg_manycore_ruche_x_link_sif_width(addr_width_p,data_width_p,x_cord_width_p,y_cord_width_p)
  )
  (
    input clk_i
    , input reset_i
    , output logic reset_o

    // local links
    , input  [S:W][link_sif_width_lp-1:0] link_i
    , output [S:W][link_sif_width_lp-1:0] link_o

    // ruche links
    , input  [ruche_factor_X_p-1:0][E:W][ruche_x_link_sif_width_lp-1:0] ruche_link_i
    , output [ruche_factor_X_p-1:0][E:W][ruche_x_link_sif_width_lp-1:0] ruche_link_o

    // tile coordinates
    , input [x_cord_width_p-1:0] global_x_i
    , input [y_cord_width_p-1:0] global_y_i
    , output logic [x_cord_width_p-1:0] global_x_o
    , output logic [y_cord_width_p-1:0] global_y_o
  );

  bsg_manycore_tile_compute_ruche #(
    .dmem_size_p(1024),
    .icache_entries_p(1024),
    .icache_tag_width_p(12),
    .x_cord_width_p(7),
    .y_cord_width_p(7),
    .pod_x_cord_width_p(3),
    .pod_y_cord_width_p(4),
    .num_tiles_x_p(16),
    .num_tiles_y_p(8),
    .data_width_p(32),
    .addr_width_p(28),
    .vcache_size_p(2048),
    .vcache_block_size_in_words_p(8),
    .vcache_sets_p(64),
    .num_vcache_rows_p(1)
  ) u_tile (
    .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.reset_o(reset_o)
    ,.link_i(link_i)
    ,.link_o(link_o)
    ,.ruche_link_i(ruche_link_i)
    ,.ruche_link_o(ruche_link_o)
    ,.global_x_i(global_x_i)
    ,.global_y_i(global_y_i)
    ,.global_x_o(global_x_o)
    ,.global_y_o(global_y_o)
  );



endmodule
