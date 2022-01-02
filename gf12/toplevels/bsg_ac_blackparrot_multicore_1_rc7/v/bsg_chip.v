
`include "bp_common_defines.svh"
`include "bp_me_defines.svh"

module bsg_chip
 import bp_common_pkg::*;
 import bp_me_pkg::*;
 import bsg_chip_pkg::*;
 import bsg_noc_pkg::*;
 #(localparam bp_params_e bp_params_p = bp_cfg_gp
   `declare_bp_proc_params(bp_params_p)

   , localparam coh_noc_ral_link_width_lp = `bsg_ready_and_link_sif_width(coh_noc_flit_width_p)
   , localparam mem_noc_ral_link_width_lp = `bsg_ready_and_link_sif_width(mem_noc_flit_width_p)
   , localparam io_noc_ral_link_width_lp = `bsg_ready_and_link_sif_width(io_noc_flit_width_p)
   )
  (input                                                    core_clk_i
   , input                                                  core_reset_i

   , input                                                  coh_clk_i
   , input                                                  coh_reset_i

   , input                                                  io_clk_i
   , input                                                  io_reset_i

   , input                                                  mem_clk_i
   , input                                                  mem_reset_i

   , input [io_noc_did_width_p-1:0]                         my_did_i
   , input [io_noc_did_width_p-1:0]                         host_did_i

   , input  [E:W][io_noc_ral_link_width_lp-1:0]             io_cmd_link_i
   , output [E:W][io_noc_ral_link_width_lp-1:0]             io_cmd_link_o

   , input  [E:W][io_noc_ral_link_width_lp-1:0]             io_resp_link_i
   , output [E:W][io_noc_ral_link_width_lp-1:0]             io_resp_link_o

   , output [mc_x_dim_p-1:0][mem_noc_ral_link_width_lp-1:0] dram_cmd_link_o
   , input [mc_x_dim_p-1:0][mem_noc_ral_link_width_lp-1:0]  dram_resp_link_i
   );

  bp_multicore
   #(.bp_params_p(bp_params_p))
   multicore
    (.*);

endmodule

