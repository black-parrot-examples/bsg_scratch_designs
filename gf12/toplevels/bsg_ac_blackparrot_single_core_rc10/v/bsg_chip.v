
`include "bp_common_defines.svh"
`include "bp_top_defines.svh"

module bsg_chip
 import bsg_wormhole_router_pkg::*;
 import bp_common_pkg::*;
 import bp_be_pkg::*;
 import bp_fe_pkg::*;
 import bp_me_pkg::*;
 import bsg_noc_pkg::*;
 #(parameter bp_params_e bp_params_p = e_bp_default_cfg
   `declare_bp_proc_params(bp_params_p)
   `declare_bp_bedrock_mem_if_widths(paddr_width_p, did_width_p, lce_id_width_p, lce_assoc_p)

   , localparam dma_pkt_width_lp = `bsg_cache_dma_pkt_width(daddr_width_p, l2_block_size_in_words_p)
   )
  (input                                                 clk_i
   , input                                               rt_clk_i
   , input                                               reset_i

   , input [mem_noc_did_width_p-1:0]                     my_did_i
   , input [mem_noc_did_width_p-1:0]                     host_did_i
   , input [coh_noc_cord_width_p-1:0]                    my_cord_i

   // Outgoing I/O
   , output logic [mem_fwd_header_width_lp-1:0]          mem_fwd_header_o
   , output logic [bedrock_fill_width_p-1:0]             mem_fwd_data_o
   , output logic                                        mem_fwd_v_o
   , input                                               mem_fwd_ready_and_i

   , input [mem_rev_header_width_lp-1:0]                 mem_rev_header_i
   , input [bedrock_fill_width_p-1:0]                    mem_rev_data_i
   , input                                               mem_rev_v_i
   , output logic                                        mem_rev_ready_and_o

   // Incoming I/O
   , input [mem_fwd_header_width_lp-1:0]                 mem_fwd_header_i
   , input [bedrock_fill_width_p-1:0]                    mem_fwd_data_i
   , input                                               mem_fwd_v_i
   , output logic                                        mem_fwd_ready_and_o

   , output logic [mem_rev_header_width_lp-1:0]          mem_rev_header_o
   , output logic [bedrock_fill_width_p-1:0]             mem_rev_data_o
   , output logic                                        mem_rev_v_o
   , input                                               mem_rev_ready_and_i

   // DRAM interface
   , output logic [l2_dmas_p-1:0][dma_pkt_width_lp-1:0] dma_pkt_o
   , output logic [l2_dmas_p-1:0]                       dma_pkt_v_o
   , input [l2_dmas_p-1:0]                              dma_pkt_ready_and_i

   , input [l2_dmas_p-1:0][l2_fill_width_p-1:0]         dma_data_i
   , input [l2_dmas_p-1:0]                              dma_data_v_i
   , output logic [l2_dmas_p-1:0]                       dma_data_ready_and_o

   , output logic [l2_dmas_p-1:0][l2_fill_width_p-1:0]  dma_data_o
   , output logic [l2_dmas_p-1:0]                       dma_data_v_o
   , input [l2_dmas_p-1:0]                              dma_data_ready_and_i
   );

  bp_unicore
   #(.bp_params_p(bp_params_p))
   chip
    (.*);

endmodule

