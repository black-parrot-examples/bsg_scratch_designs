
`include "bp_common_defines.svh"
`include "bp_top_defines.svh"
`include "bp_me_defines.svh"

module bsg_chip
 import bp_common_pkg::*;
 import bp_be_pkg::*;
 import bsg_noc_pkg::*;
 import bsg_wormhole_router_pkg::*;
 import bp_me_pkg::*;
 #(parameter bp_params_e bp_params_p = e_bp_multicore_1_cfg
   `declare_bp_proc_params(bp_params_p)

   , localparam coh_noc_ral_link_width_lp = `bsg_ready_and_link_sif_width(coh_noc_flit_width_p)
   , localparam dma_noc_ral_link_width_lp = `bsg_ready_and_link_sif_width(dma_noc_flit_width_p)
   )
  (input                                               core_clk_i
   , input                                             rt_clk_i
   , input                                             core_reset_i

   , input                                             coh_clk_i
   , input                                             coh_reset_i

   , input                                             dma_clk_i
   , input                                             dma_reset_i

   // Memory side connection
   , input [mem_noc_did_width_p-1:0]                   my_did_i
   , input [mem_noc_did_width_p-1:0]                   host_did_i
   , input [coh_noc_cord_width_p-1:0]                  my_cord_i

   // Connected to other tiles on east and west
   , input [S:W][coh_noc_ral_link_width_lp-1:0]        coh_lce_req_link_i
   , output logic [S:W][coh_noc_ral_link_width_lp-1:0] coh_lce_req_link_o

   , input [S:W][coh_noc_ral_link_width_lp-1:0]        coh_lce_cmd_link_i
   , output logic [S:W][coh_noc_ral_link_width_lp-1:0] coh_lce_cmd_link_o

   , input [S:W][coh_noc_ral_link_width_lp-1:0]        coh_lce_fill_link_i
   , output logic [S:W][coh_noc_ral_link_width_lp-1:0] coh_lce_fill_link_o

   , input [S:W][coh_noc_ral_link_width_lp-1:0]        coh_lce_resp_link_i
   , output logic [S:W][coh_noc_ral_link_width_lp-1:0] coh_lce_resp_link_o

   , input [S:N][dma_noc_ral_link_width_lp-1:0]        dma_link_i
   , output logic [S:N][dma_noc_ral_link_width_lp-1:0] dma_link_o
   );

  bp_core_tile_node
   #(.bp_params_p(bp_params_p))
   chip
    (.*);

endmodule

