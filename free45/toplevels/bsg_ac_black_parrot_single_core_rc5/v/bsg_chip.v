
module bsg_chip
 import bp_common_pkg::*;
 import bp_common_aviary_pkg::*;
 import bp_me_pkg::*;
 import bp_cce_pkg::*;
 import bsg_chip_pkg::*;
 #(localparam bp_params_e bp_params_p = bp_cfg_gp
   `declare_bp_proc_params(bp_params_p)
   `declare_bp_bedrock_mem_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p, cce)
   )
  (input                                               clk_i
   , input                                             reset_i

   // Outgoing I/O
   , output [cce_mem_msg_width_lp-1:0]                 io_cmd_o
   , output                                            io_cmd_v_o
   , input                                             io_cmd_ready_i

   , input [cce_mem_msg_width_lp-1:0]                  io_resp_i
   , input                                             io_resp_v_i
   , output                                            io_resp_yumi_o

   // Incoming I/O
   , input [cce_mem_msg_width_lp-1:0]                  io_cmd_i
   , input                                             io_cmd_v_i
   , output                                            io_cmd_yumi_o

   , output [cce_mem_msg_width_lp-1:0]                 io_resp_o
   , output                                            io_resp_v_o
   , input                                             io_resp_ready_i

   , output logic [cce_mem_msg_header_width_lp-1:0]    mem_cmd_header_o
   , output logic                                      mem_cmd_header_v_o
   , input                                             mem_cmd_header_ready_i

   , output logic [dword_width_p-1:0]                  mem_cmd_data_o
   , output logic                                      mem_cmd_data_v_o
   , input                                             mem_cmd_data_ready_i

   , input [cce_mem_msg_header_width_lp-1:0]           mem_resp_header_i
   , input                                             mem_resp_header_v_i
   , output logic                                      mem_resp_header_yumi_o

   , input [dword_width_p-1:0]                         mem_resp_data_i
   , input                                             mem_resp_data_v_i
   , output logic                                      mem_resp_data_yumi_o
   );

  bp_unicore
   #(.bp_params_p(bp_params_p))
   unicore
    (.*);

endmodule

