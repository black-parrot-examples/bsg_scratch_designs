
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

   , localparam cfg_bus_width_lp = `bp_cfg_bus_width(vaddr_width_p, hio_width_p, core_id_width_p, cce_id_width_p, lce_id_width_p)
   )
  (input                                               clk_i
   , input                                             reset_i

   , input [cfg_bus_width_lp-1:0]                      cfg_bus_i

   // Outgoing BP Stream Mem Buses from I$ and D$
   , output logic [1:0][mem_fwd_header_width_lp-1:0]   mem_fwd_header_o
   , output logic [1:0][bedrock_fill_width_p-1:0]      mem_fwd_data_o
   , output logic [1:0]                                mem_fwd_v_o
   , input [1:0]                                       mem_fwd_ready_and_i

   , input [1:0][mem_rev_header_width_lp-1:0]          mem_rev_header_i
   , input [1:0][bedrock_fill_width_p-1:0]             mem_rev_data_i
   , input [1:0]                                       mem_rev_v_i
   , output logic [1:0]                                mem_rev_ready_and_o

   , input                                             debug_irq_i
   , input                                             timer_irq_i
   , input                                             software_irq_i
   , input                                             m_external_irq_i
   , input                                             s_external_irq_i
   );

  bp_unicore_lite
   #(.bp_params_p(bp_params_p))
   chip
    (.*);

endmodule

