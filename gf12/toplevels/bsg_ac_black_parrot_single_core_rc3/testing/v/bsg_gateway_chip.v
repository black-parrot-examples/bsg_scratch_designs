`timescale 1ps/1ps

`ifndef BLACKPARROT_CLK_PERIOD
  `define BLACKPARROT_CLK_PERIOD 5000.0
`endif

`ifndef IO_MASTER_CLK_PERIOD
  `define IO_MASTER_CLK_PERIOD 5000.0
`endif

`ifndef ROUTER_CLK_PERIOD
  `define ROUTER_CLK_PERIOD 5000.0
`endif

`ifndef TAG_CLK_PERIOD
  `define TAG_CLK_PERIOD 10000.0
`endif

module bsg_gateway_chip

import bsg_tag_pkg::*;
import bsg_chip_pkg::*;

import bp_common_pkg::*;
import bp_common_aviary_pkg::*;
import bp_common_rv64_pkg::*;
import bp_be_pkg::*;
import bp_cce_pkg::*;
import bp_me_pkg::*;
import bsg_noc_pkg::*;
import bsg_wormhole_router_pkg::*;

#(localparam bp_params_e bp_params_p = e_bp_single_core_cfg `declare_bp_proc_params(bp_params_p))
();


  //////////////////////////////////////////////////
  //
  // Waveform Dump
  //

  initial
    begin
      $vcdpluson;
      $vcdplusmemon;
      $vcdplusautoflushon;
    end

  //////////////////////////////////////////////////
  //
  // Nonsynth Clock Generator(s)
  //

  logic blackparrot_clk;
  bsg_nonsynth_clock_gen #(.cycle_time_p(`BLACKPARROT_CLK_PERIOD)) blackparrot_clk_gen (.o(blackparrot_clk));

  //////////////////////////////////////////////////
  //
  // Nonsynth Reset Generator(s)
  //

  logic blackparrot_reset;
  bsg_nonsynth_reset_gen #(.num_clocks_p(1),.reset_cycles_lo_p(10),.reset_cycles_hi_p(5))
    blackparrot_reset_gen
      (.clk_i(blackparrot_clk)
      ,.async_reset_o(blackparrot_reset)
      );

  //////////////////////////////////////////////////
  //
  // DUT
  //
  `declare_bp_me_if(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p);
  bp_cce_mem_msg_s proc_io_cmd_lo;
  logic proc_io_cmd_v_lo, proc_io_cmd_ready_li;
  bp_cce_mem_msg_s proc_io_resp_li;
  logic proc_io_resp_v_li, proc_io_resp_yumi_lo;

  bp_softcore
   #(.bp_params_p(bp_params_p))
   DUT
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.io_cmd_o(proc_io_cmd_lo)
     ,.io_cmd_v_o(proc_io_cmd_v_lo)
     ,.io_cmd_ready_i(proc_io_cmd_ready_li)

     ,.io_resp_i(proc_io_resp_li)
     ,.io_resp_v_i(proc_io_resp_v_li)
     ,.io_resp_yumi_o(proc_io_resp_yumi_lo)

     ,.mem_cmd_o(proc_mem_cmd_lo)
     ,.mem_cmd_v_o(proc_mem_cmd_v_lo)
     ,.mem_cmd_ready_i(proc_mem_cmd_ready_li)

     ,.mem_resp_i(proc_mem_resp_li)
     ,.mem_resp_v_i(proc_mem_resp_v_li)
     ,.mem_resp_yumi_o(proc_mem_resp_yumi_lo)
     );

  bp_cce_mem_msg_s dram_cmd_lo;
  logic dram_cmd_v_lo, dram_cmd_ready_li;
  bp_cce_mem_msg_s host_resp_li;
  logic host_resp_v_li, host_resp_yumi_lo;

  bp_mem
   #(.bp_params_p(bp_params_p)
     ,.mem_cap_in_bytes_p(32'h10000)
     ,.mem_load_p(1)
     ,.mem_file_p("prog.mem")
     ,.mem_offset_p(32'h80000000)

     ,.use_max_latency_p(1)
     ,.max_latency_p(5)
     )
   mem
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_cmd_i(proc_mem_cmd_lo)
     ,.mem_cmd_v_i(proc_mem_cmd_v_lo & proc_mem_cmd_ready_li)
     ,.mem_cmd_ready_o(proc_mem_cmd_ready_li)

     ,.mem_resp_o(proc_mem_resp_li)
     ,.mem_resp_v_o(proc_mem_resp_v_li)
     ,.mem_resp_yumi_i(proc_mem_resp_yumi_lo)
     );

  logic [num_core_p-1:0] program_finish;
  bp_nonsynth_host
   #(.bp_params_p(bp_params_p))
   host_mmio
    (.clk_i(blackparrot_clk)
     ,.reset_i(core_reset_lo | ~tag_trace_done_lo)
  
     ,.io_cmd_i(proc_io_cmd_lo)
     ,.io_cmd_v_i(proc_io_cmd_v_lo & proc_io_cmd_ready_li)
     ,.io_cmd_ready_o(proc_io_cmd_ready_li)
  
     ,.io_resp_o(proc_io_resp_li)
     ,.io_resp_v_o(proc_io_resp_v_li)
     ,.io_resp_yumi_i(proc_io_resp_yumi_lo)
  
     ,.program_finish_o(program_finish)
     );



endmodule

