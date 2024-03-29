
`include "bp_common_defines.svh"
`include "bp_me_defines.svh"

module bsg_chip
 import bp_common_pkg::*;
 import bp_me_pkg::*;
 import bsg_chip_pkg::*;
 #(localparam bp_params_e bp_params_p = bp_cfg_gp
   `declare_bp_proc_params(bp_params_p)
   , localparam uce_mem_data_width_lp = `BSG_MAX(icache_fill_width_p, dcache_fill_width_p)
   `declare_bp_bedrock_mem_if_widths(paddr_width_p, uce_mem_data_width_lp, lce_id_width_p, lce_assoc_p, uce)

   , localparam dma_pkt_width_lp = `bsg_cache_dma_pkt_width(daddr_width_p)
   )
  (input                                               clk_i
   , input                                             reset_i

   // Outgoing I/O
   , output logic [uce_mem_msg_header_width_lp-1:0]    io_cmd_header_o
   , output logic [uce_mem_data_width_lp-1:0]          io_cmd_data_o
   , output logic                                      io_cmd_v_o
   , input                                             io_cmd_ready_and_i
   , output logic                                      io_cmd_last_o

   , input [uce_mem_msg_header_width_lp-1:0]           io_resp_header_i
   , input [uce_mem_data_width_lp-1:0]                 io_resp_data_i
   , input                                             io_resp_v_i
   , output logic                                      io_resp_ready_and_o
   , input                                             io_resp_last_i

   // Incoming I/O
   , input [uce_mem_msg_header_width_lp-1:0]           io_cmd_header_i
   , input [uce_mem_data_width_lp-1:0]                 io_cmd_data_i
   , input                                             io_cmd_v_i
   , output logic                                      io_cmd_ready_and_o
   , input                                             io_cmd_last_i

   , output logic [uce_mem_msg_header_width_lp-1:0]    io_resp_header_o
   , output logic [uce_mem_data_width_lp-1:0]          io_resp_data_o
   , output logic                                      io_resp_v_o
   , input                                             io_resp_ready_and_i
   , output logic                                      io_resp_last_o

   // DRAM interface
   , output logic [dma_pkt_width_lp-1:0]               dma_pkt_o
   , output logic                                      dma_pkt_v_o
   , input                                             dma_pkt_yumi_i

   , input [l2_fill_width_p-1:0]                       dma_data_i
   , input                                             dma_data_v_i
   , output logic                                      dma_data_ready_and_o

   , output logic [l2_fill_width_p-1:0]                dma_data_o
   , output logic                                      dma_data_v_o
   , input                                             dma_data_yumi_i
   );

  bp_unicore
   #(.bp_params_p(bp_params_p))
   unicore
    (.*);

endmodule

