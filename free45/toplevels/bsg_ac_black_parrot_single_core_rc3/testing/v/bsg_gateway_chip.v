`timescale 1ps/1ps

// TODO: Change this value based on simulation type
`ifndef BLACKPARROT_CLK_PERIOD
  `define BLACKPARROT_CLK_PERIOD 5000.0
`endif

`include "bsg_noc_links.vh"

module bsg_gateway_chip

import bsg_chip_pkg::*;

import bp_common_pkg::*;
import bp_common_aviary_pkg::*;
import bp_be_pkg::*;
import bp_common_rv64_pkg::*;
import bp_cce_pkg::*;
import bp_me_pkg::*;
import bp_common_cfg_link_pkg::*;
  #(parameter bp_params_e bp_params_p = e_bp_unicore_l1_small_cfg
   `declare_bp_proc_params(bp_params_p)
  
   , localparam mem_cap_in_bytes_lp = 2**28
   , localparam preload_mem_lp = 0
   , localparam mem_zero_lp = 1
   , localparam mem_file_lp = "prog.mem"
   , localparam [paddr_width_p-1:0] mem_offset_lp = dram_base_addr_gp
   , localparam use_max_latency_lp = 1
   , localparam use_random_latency_lp = 0
   , localparam use_dramsim2_latency_lp = 0
   , localparam max_latency_lp = 15
   , localparam dram_clock_period_in_ps_lp = `BLACKPARROT_CLK_PERIOD
   , localparam dram_cfg_lp = "dram_ch.ini"
   , localparam dram_sys_cfg_lp = "dram_sys.ini"
   , localparam dram_capacity_lp = 16384
   )
   ();

  //////////////////////////////////////////////////
  //
  // Nonsynth Clock Generator(s)
  //

  logic blackparrot_clk;
  bsg_nonsynth_clock_gen 
    #(.cycle_time_p(`BLACKPARROT_CLK_PERIOD)) 
    blackparrot_clk_gen 
    (.o(blackparrot_clk));

  //////////////////////////////////////////////////
  //
  // Nonsynth Reset Generator(s)
  //

   logic blackparrot_reset;
   bsg_nonsynth_reset_gen 
    #(.num_clocks_p(1)
     ,.reset_cycles_lo_p(0)
     ,.reset_cycles_hi_p(20))
     blackparrot_reset_gen
     (.clk_i(blackparrot_clk)
     ,.async_reset_o(blackparrot_reset)
     );

  //////////////////////////////////////////////////
  //
  // Initial Conditions + Waveform Dump
  //

  initial
    begin
      $assertoff();
      @(posedge blackparrot_clk);
      @(negedge blackparrot_reset);
      $asserton();
      $vcdpluson;
      $vcdplusmemon;
      $vcdplusautoflushon;
    end

  //////////////////////////////////////////////////
  //
  // DUT, Fake memory, Host, Config Loader
  //
  `declare_bp_me_if(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p)

  logic [num_core_p-1:0] program_finish_lo;
  logic done_lo;
  
  bp_cce_mem_msg_s proc_mem_cmd_lo;
  logic proc_mem_cmd_v_lo, proc_mem_cmd_ready_li;
  bp_cce_mem_msg_s proc_mem_resp_li;
  logic proc_mem_resp_v_li, proc_mem_resp_yumi_lo;
  
  bp_cce_mem_msg_s proc_io_cmd_lo;
  logic proc_io_cmd_v_lo, proc_io_cmd_ready_li;
  bp_cce_mem_msg_s proc_io_resp_li;
  logic proc_io_resp_v_li, proc_io_resp_yumi_lo;
  
  bp_cce_mem_msg_s io_cmd_lo;
  logic io_cmd_v_lo, io_cmd_ready_li;
  bp_cce_mem_msg_s io_resp_li;
  logic io_resp_v_li, io_resp_yumi_lo;
  
  bp_cce_mem_msg_s load_cmd_lo;
  logic load_cmd_v_lo, load_cmd_yumi_li;
  bp_cce_mem_msg_s load_resp_li;
  logic load_resp_v_li, load_resp_ready_lo;
  
  wire [io_noc_did_width_p-1:0] proc_did_li = '1;
  wire [io_noc_did_width_p-1:0] dram_did_li = '1;

  assign stub_cmd_link_li = '0;
  assign stub_resp_link_li = '0;

  wrapper
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

    ,.io_cmd_i(load_cmd_lo)
    ,.io_cmd_v_i(load_cmd_v_lo)
    ,.io_cmd_yumi_o(load_cmd_yumi_li)

    ,.io_resp_o(load_resp_li)
    ,.io_resp_v_o(load_resp_v_li)
    ,.io_resp_ready_i(load_resp_ready_lo)

    ,.mem_cmd_o(proc_mem_cmd_lo)
    ,.mem_cmd_v_o(proc_mem_cmd_v_lo)
    ,.mem_cmd_ready_i(proc_mem_cmd_ready_li)

    ,.mem_resp_i(proc_mem_resp_li)
    ,.mem_resp_v_i(proc_mem_resp_v_li)
    ,.mem_resp_yumi_o(proc_mem_resp_yumi_lo)
    );
  
  
  bp_mem
   #(.bp_params_p(bp_params_p)
     ,.mem_cap_in_bytes_p(mem_cap_in_bytes_lp)
     ,.mem_load_p(preload_mem_lp)
     ,.mem_zero_p(mem_zero_lp)
     ,.mem_file_p(mem_file_lp)
     ,.mem_offset_p(mem_offset_lp)

     ,.use_max_latency_p(use_max_latency_lp)
     ,.use_random_latency_p(use_random_latency_lp)
     ,.use_dramsim2_latency_p(use_dramsim2_latency_lp)
     ,.max_latency_p(max_latency_lp)

     ,.dram_clock_period_in_ps_p(dram_clock_period_in_ps_lp)
     ,.dram_cfg_p(dram_cfg_lp)
     ,.dram_sys_cfg_p(dram_sys_cfg_lp)
     ,.dram_capacity_p(dram_capacity_lp)
     )
   mem
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_cmd_i(proc_mem_cmd_lo)
     ,.mem_cmd_v_i(proc_mem_cmd_ready_li & proc_mem_cmd_v_lo)
     ,.mem_cmd_ready_o(proc_mem_cmd_ready_li)

     ,.mem_resp_o(proc_mem_resp_li)
     ,.mem_resp_v_o(proc_mem_resp_v_li)
     ,.mem_resp_yumi_i(proc_mem_resp_yumi_lo)
     );
  
  bp_nonsynth_nbf_loader
    #(.bp_params_p(bp_params_p))
    nbf_loader
    (.clk_i(blackparrot_clk)
    ,.reset_i(blackparrot_reset)

    ,.lce_id_i(lce_id_width_p'('b10))

    ,.io_cmd_o(load_cmd_lo)
    ,.io_cmd_v_o(load_cmd_v_lo)
    ,.io_cmd_yumi_i(load_cmd_yumi_li)

    ,.io_resp_i(load_resp_li)
    ,.io_resp_v_i(load_resp_v_li)
    ,.io_resp_ready_o(load_resp_ready_lo)

    ,.done_o(done_lo)
    );
       
  bp_nonsynth_host
   #(.bp_params_p(bp_params_p))
   host
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)
     
     ,.io_cmd_i(proc_io_cmd_lo)
     ,.io_cmd_v_i(proc_io_cmd_v_lo & proc_io_cmd_ready_li)
     ,.io_cmd_ready_o(proc_io_cmd_ready_li)

     ,.io_resp_o(proc_io_resp_li)
     ,.io_resp_v_o(proc_io_resp_v_li)
     ,.io_resp_yumi_i(proc_io_resp_yumi_lo)

     ,.program_finish_o(program_finish_lo)
     );
  
  bind bp_be_top
  bp_nonsynth_watchdog
    #(.bp_params_p(bp_params_p)
     ,.timeout_cycles_p(100000)
     ,.heartbeat_instr_p(100000)
     )
     watchdog
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.freeze_i(calculator.pipe_sys.csr.cfg_bus_cast_i.freeze)

     ,.mhartid_i(calculator.pipe_sys.csr.cfg_bus_cast_i.core_id)

     ,.npc_i(director.npc_r)
     ,.instret_i(calculator.commit_pkt.instret)
     );
 
endmodule

