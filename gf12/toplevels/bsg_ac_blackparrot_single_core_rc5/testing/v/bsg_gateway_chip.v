`timescale 1ps/1ps

`ifndef BLACKPARROT_CLK_PERIOD
  `define BLACKPARROT_CLK_PERIOD 2100.0
  `define BLACKPARROT_IO_DELAY 400.0
`endif

module bsg_gateway_chip

import bsg_chip_pkg::*;

import bp_common_pkg::*;
import bp_common_aviary_pkg::*;
import bp_common_rv64_pkg::*;
import bp_be_pkg::*;
import bp_cce_pkg::*;
import bp_me_pkg::*;
import bsg_noc_pkg::*;
import bsg_wormhole_router_pkg::*;

#(localparam bp_params_e bp_params_p = e_bp_unicore_cfg `declare_bp_proc_params(bp_params_p)
  `declare_bp_bedrock_mem_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p, cce))
  ();


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
  // Waveform Dump
  //

  initial
    begin
      //$vcdpluson;
      //$vcdplusmemon;
      //$vcdplusautoflushon;
    end

  initial
    begin
      $assertoff();
      @(posedge blackparrot_clk);
      @(negedge blackparrot_reset);
      $asserton();
    end

  logic trigger_saif;
  initial
    begin
      $set_gate_level_monitoring("rtl_on");
      $set_toggle_region(DUT);
      @(posedge blackparrot_clk);
      @(negedge blackparrot_reset);
      @(posedge trigger_saif);
      $toggle_start();
    end

  final
    begin
      $toggle_stop();
      $toggle_report("run.saif", 1.0e-12, DUT);
    end


  //////////////////////////////////////////////////
  //
  // DUT
  //
  `declare_bp_bedrock_mem_if(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p, cce);
  bp_bedrock_cce_mem_msg_s proc_io_cmd_lo;
  logic proc_io_cmd_v_lo, proc_io_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s proc_io_resp_li;
  logic proc_io_resp_v_li, proc_io_resp_yumi_lo;
  bp_bedrock_cce_mem_msg_s dram_mem_cmd_lo;
  logic dram_mem_cmd_v_lo, dram_mem_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s dram_mem_resp_li;
  logic dram_mem_resp_v_li, dram_mem_resp_yumi_lo;
  bp_bedrock_cce_mem_msg_s proc_io_cmd_li;
  logic proc_io_cmd_v_li, proc_io_cmd_yumi_lo;
  bp_bedrock_cce_mem_msg_s proc_io_resp_lo;
  logic proc_io_resp_v_lo, proc_io_resp_ready_li;

  bp_bedrock_cce_mem_msg_header_s proc_mem_cmd_header_lo;
  logic proc_mem_cmd_header_v_lo, proc_mem_cmd_header_ready_li;
  logic [dword_width_p-1:0] proc_mem_cmd_data_lo;
  logic proc_mem_cmd_data_v_lo, proc_mem_cmd_data_ready_li;

  bp_bedrock_cce_mem_msg_header_s proc_mem_resp_header_li;
  logic proc_mem_resp_header_v_li, proc_mem_resp_header_yumi_lo;
  logic [dword_width_p-1:0] proc_mem_resp_data_li;
  logic proc_mem_resp_data_v_li, proc_mem_resp_data_yumi_lo;

  // Delayed proc signals
  logic _proc_io_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s _proc_io_resp_li;
  logic _proc_io_resp_v_li;
  bp_bedrock_cce_mem_msg_s _proc_io_cmd_li;
  logic _proc_io_cmd_v_li;
  logic _proc_io_resp_ready_li;

  logic _proc_mem_cmd_header_ready_li;
  logic _proc_mem_cmd_data_ready_li;
  bp_bedrock_cce_mem_msg_header_s _proc_mem_resp_header_li;
  logic _proc_mem_resp_header_v_li;
  logic [dword_width_p-1:0] _proc_mem_resp_data_li;
  logic _proc_mem_resp_data_v_li;

  // Add delay to simulate realistic input delays 20% frequency
  assign #`BLACKPARROT_IO_DELAY _proc_io_cmd_ready_li         = proc_io_cmd_ready_li;
  assign #`BLACKPARROT_IO_DELAY _proc_io_resp_li              = proc_io_resp_li;
  assign #`BLACKPARROT_IO_DELAY _proc_io_resp_v_li            = proc_io_resp_v_li;
  assign #`BLACKPARROT_IO_DELAY _proc_io_cmd_li               = proc_io_cmd_li;
  assign #`BLACKPARROT_IO_DELAY _proc_io_cmd_v_li             = proc_io_cmd_v_li;
  assign #`BLACKPARROT_IO_DELAY _proc_io_resp_ready_li        = proc_io_resp_ready_li;
  assign #`BLACKPARROT_IO_DELAY _proc_mem_cmd_header_ready_li = proc_mem_cmd_header_ready_li;
  assign #`BLACKPARROT_IO_DELAY _proc_mem_cmd_data_ready_li   = proc_mem_cmd_data_ready_li;
  assign #`BLACKPARROT_IO_DELAY _proc_mem_resp_header_li      = proc_mem_resp_header_li;
  assign #`BLACKPARROT_IO_DELAY _proc_mem_resp_header_v_li    = proc_mem_resp_header_v_li;
  assign #`BLACKPARROT_IO_DELAY _proc_mem_resp_data_li        = proc_mem_resp_data_li;
  assign #`BLACKPARROT_IO_DELAY _proc_mem_resp_data_v_li      = proc_mem_resp_data_v_li;

  bsg_chip
   DUT
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.io_cmd_o(proc_io_cmd_lo)
     ,.io_cmd_v_o(proc_io_cmd_v_lo)
     ,.io_cmd_ready_i(_proc_io_cmd_ready_li)

     ,.io_resp_i(_proc_io_resp_li)
     ,.io_resp_v_i(_proc_io_resp_v_li)
     ,.io_resp_yumi_o(proc_io_resp_yumi_lo)

     ,.io_cmd_i(_proc_io_cmd_li)
     ,.io_cmd_v_i(_proc_io_cmd_v_li)
     ,.io_cmd_yumi_o(proc_io_cmd_yumi_lo)

     ,.io_resp_o(proc_io_resp_lo)
     ,.io_resp_v_o(proc_io_resp_v_lo)
     ,.io_resp_ready_i(_proc_io_resp_ready_li)

     ,.mem_cmd_header_o(proc_mem_cmd_header_lo)
     ,.mem_cmd_header_v_o(proc_mem_cmd_header_v_lo)
     ,.mem_cmd_header_ready_i(_proc_mem_cmd_header_ready_li)

     ,.mem_cmd_data_o(proc_mem_cmd_data_lo)
     ,.mem_cmd_data_v_o(proc_mem_cmd_data_v_lo)
     ,.mem_cmd_data_ready_i(_proc_mem_cmd_data_ready_li)

     ,.mem_resp_header_i(_proc_mem_resp_header_li)
     ,.mem_resp_header_v_i(_proc_mem_resp_header_v_li)
     ,.mem_resp_header_yumi_o(proc_mem_resp_header_yumi_lo)

     ,.mem_resp_data_i(_proc_mem_resp_data_li)
     ,.mem_resp_data_v_i(_proc_mem_resp_data_v_li)
     ,.mem_resp_data_yumi_o(proc_mem_resp_data_yumi_lo)
     );

  bp_burst_to_lite
   #(.bp_params_p(bp_params_p)
     ,.in_data_width_p(dword_width_p)
     ,.out_data_width_p(cce_block_width_p)
     ,.payload_mask_p(mem_cmd_payload_mask_gp)
     )
   burst2lite
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_header_i(proc_mem_cmd_header_lo)
     ,.mem_header_v_i(proc_mem_cmd_header_v_lo)
     ,.mem_header_ready_and_o(proc_mem_cmd_header_ready_li)

     ,.mem_data_i(proc_mem_cmd_data_lo)
     ,.mem_data_v_i(proc_mem_cmd_data_v_lo)
     ,.mem_data_ready_and_o(proc_mem_cmd_data_ready_li)

     ,.mem_o(dram_mem_cmd_lo)
     ,.mem_v_o(dram_mem_cmd_v_lo)
     ,.mem_ready_and_i(dram_mem_cmd_ready_li)
     );

  logic dram_mem_resp_ready_lo;
  assign dram_mem_resp_yumi_lo = dram_mem_resp_ready_lo & dram_mem_resp_v_li;
  bp_lite_to_burst
   #(.bp_params_p(bp_params_p)
     ,.in_data_width_p(cce_block_width_p)
     ,.out_data_width_p(dword_width_p)
     ,.payload_mask_p(mem_resp_payload_mask_gp)
     )
   lite2burst
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_i(dram_mem_resp_li)
     ,.mem_v_i(dram_mem_resp_v_li)
     ,.mem_ready_and_o(dram_mem_resp_ready_lo)

     ,.mem_header_o(proc_mem_resp_header_li)
     ,.mem_header_v_o(proc_mem_resp_header_v_li)
     ,.mem_header_ready_and_i(proc_mem_resp_header_yumi_lo)

     ,.mem_data_o(proc_mem_resp_data_li)
     ,.mem_data_v_o(proc_mem_resp_data_v_li)
     ,.mem_data_ready_and_i(proc_mem_resp_data_yumi_lo)
     );

  bp_mem
   #(.bp_params_p(bp_params_p)
     ,.mem_offset_p(32'h80000000)
     ,.mem_cap_in_bytes_p(2**25)
     ,.mem_load_p(1)
     ,.mem_file_p("prog.mem")
     ,.dram_fixed_latency_p(100)
     )
   mem
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_cmd_i(dram_mem_cmd_lo)
     ,.mem_cmd_v_i(dram_mem_cmd_v_lo & dram_mem_cmd_ready_li)
     ,.mem_cmd_ready_o(dram_mem_cmd_ready_li)

     ,.mem_resp_o(dram_mem_resp_li)
     ,.mem_resp_v_o(dram_mem_resp_v_li)
     ,.mem_resp_yumi_i(dram_mem_resp_yumi_lo)

     // TODO: Async clock?
     ,.dram_clk_i(blackparrot_clk)
     ,.dram_reset_i(blackparrot_reset)
     );

  logic [num_core_p-1:0] program_finish;
  bp_nonsynth_host
   #(.bp_params_p(bp_params_p))
   host_mmio
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)
  
     ,.io_cmd_i(proc_io_cmd_lo)
     ,.io_cmd_v_i(proc_io_cmd_v_lo & proc_io_cmd_ready_li)
     ,.io_cmd_ready_o(proc_io_cmd_ready_li)
  
     ,.io_resp_o(proc_io_resp_li)
     ,.io_resp_v_o(proc_io_resp_v_li)
     ,.io_resp_yumi_i(proc_io_resp_yumi_lo)

     ,.icache_trace_en_o()
     ,.dcache_trace_en_o()
     ,.lce_trace_en_o()
     ,.cce_trace_en_o()
     ,.dram_trace_en_o()
     ,.vm_trace_en_o()
     ,.cmt_trace_en_o()
     ,.core_profile_en_o()
     ,.branch_profile_en_o()
     ,.pc_profile_en_o()
     ,.cosim_en_o()
     );

  localparam cce_instr_ram_addr_width_lp = `BSG_SAFE_CLOG2(num_cce_instr_ram_els_p);
  logic nbf_done_lo;
  bp_nonsynth_nbf_loader
    #(.bp_params_p(bp_params_p))
    nbf_loader
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)
  
     ,.lce_id_i(4'b10)
  
     ,.io_cmd_o(proc_io_cmd_li)
     ,.io_cmd_v_o(proc_io_cmd_v_li)
     ,.io_cmd_yumi_i(proc_io_cmd_yumi_lo)
  
     ,.io_resp_i(proc_io_resp_lo)
     ,.io_resp_v_i(proc_io_resp_v_lo)
     ,.io_resp_ready_o(proc_io_resp_ready_li)

     ,.done_o(nbf_done_lo)
    );
  assign trigger_saif = nbf_done_lo;



endmodule

