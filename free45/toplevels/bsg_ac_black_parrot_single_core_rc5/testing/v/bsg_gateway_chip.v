`timescale 1ps/1ps

`ifndef BLACKPARROT_CLK_PERIOD
  `define BLACKPARROT_CLK_PERIOD 5000.0
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

#(localparam bp_params_e bp_params_p = e_bp_unicore_cfg 
  `declare_bp_proc_params(bp_params_p)

  , localparam uce_mem_data_width_lp = `BSG_MAX(icache_fill_width_p, dcache_fill_width_p)
  `declare_bp_bedrock_mem_if_widths(paddr_width_p, cce_block_width_p, lce_id_width_p, lce_assoc_p, cce)
  `declare_bp_bedrock_mem_if_widths(paddr_width_p, uce_mem_data_width_lp, lce_id_width_p, lce_assoc_p, uce)
  )
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
  bsg_nonsynth_reset_gen #(.num_clocks_p(1),.reset_cycles_lo_p(10),.reset_cycles_hi_p(10))
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
      $vcdpluson;
      $vcdplusmemon;
      $vcdplusautoflushon;
    end

  initial
    begin
      $assertoff();
      @(posedge blackparrot_clk);
      @(negedge blackparrot_reset);
      $asserton();
    end

  initial
    begin
      $set_gate_level_monitoring("rtl_on");
      $set_toggle_region(DUT);
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
  `declare_bp_bedrock_mem_if(paddr_width_p, uce_mem_data_width_lp, lce_id_width_p, lce_assoc_p, uce);

  bp_bedrock_cce_mem_msg_s proc_mem_cmd_lo;
  logic proc_mem_cmd_v_lo, proc_mem_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s proc_mem_resp_li;
  logic proc_mem_resp_v_li, proc_mem_resp_yumi_lo;

  bp_bedrock_cce_mem_msg_s proc_io_cmd_lo;
  logic proc_io_cmd_v_lo, proc_io_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s proc_io_resp_li;
  logic proc_io_resp_v_li, proc_io_resp_yumi_lo;

  bp_bedrock_cce_mem_msg_s load_cmd_lo;
  logic load_cmd_v_lo, load_cmd_yumi_li;
  bp_bedrock_cce_mem_msg_s load_resp_li;
  logic load_resp_v_li, load_resp_ready_lo;

  bp_bedrock_uce_mem_msg_s io_cmd_lo, io_cmd_li;
  bp_bedrock_uce_mem_msg_s io_resp_lo, io_resp_li;

  bp_bedrock_uce_mem_msg_header_s mem_cmd_header_lo;
  logic mem_cmd_header_v_lo, mem_cmd_header_ready_li;
  logic [dword_width_p-1:0] mem_cmd_data_lo;
  logic mem_cmd_data_v_lo, mem_cmd_data_ready_li;

  bp_bedrock_uce_mem_msg_header_s mem_resp_header_li;
  logic mem_resp_header_v_li, mem_resp_header_yumi_lo;
  logic [dword_width_p-1:0] mem_resp_data_li;
  logic mem_resp_data_v_li, mem_resp_data_yumi_lo;

  assign proc_io_cmd_lo = io_cmd_lo;
  assign io_resp_li = proc_io_resp_li;
  assign io_cmd_li = load_cmd_lo;
  assign load_resp_li = io_resp_lo;

  bsg_chip
    #(.bp_params_p(bp_params_p))
   DUT
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.io_cmd_o(io_cmd_lo)
     ,.io_cmd_v_o(proc_io_cmd_v_lo)
     ,.io_cmd_ready_i(proc_io_cmd_ready_li)

     ,.io_resp_i(io_resp_li)
     ,.io_resp_v_i(proc_io_resp_v_li)
     ,.io_resp_yumi_o(proc_io_resp_yumi_lo)

     ,.io_cmd_i(io_cmd_li)
     ,.io_cmd_v_i(load_cmd_v_lo)
     ,.io_cmd_yumi_o(load_cmd_yumi_li)

     ,.io_resp_o(io_resp_lo)
     ,.io_resp_v_o(load_resp_v_li)
     ,.io_resp_ready_i(load_resp_ready_lo)

     ,.mem_cmd_header_o(mem_cmd_header_lo)
     ,.mem_cmd_header_v_o(mem_cmd_header_v_lo)
     ,.mem_cmd_header_ready_i(mem_cmd_header_ready_li)

     ,.mem_cmd_data_o(mem_cmd_data_lo)
     ,.mem_cmd_data_v_o(mem_cmd_data_v_lo)
     ,.mem_cmd_data_ready_i(mem_cmd_data_ready_li)

     ,.mem_resp_header_i(mem_resp_header_li)
     ,.mem_resp_header_v_i(mem_resp_header_v_li)
     ,.mem_resp_header_yumi_o(mem_resp_header_yumi_lo)

     ,.mem_resp_data_i(mem_resp_data_li)
     ,.mem_resp_data_v_i(mem_resp_data_v_li)
     ,.mem_resp_data_yumi_o(mem_resp_data_yumi_lo)
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

     ,.mem_header_i(mem_cmd_header_lo)
     ,.mem_header_v_i(mem_cmd_header_v_lo)
     ,.mem_header_ready_and_o(mem_cmd_header_ready_li)

     ,.mem_data_i(mem_cmd_data_lo)
     ,.mem_data_v_i(mem_cmd_data_v_lo)
     ,.mem_data_ready_and_o(mem_cmd_data_ready_li)

     ,.mem_o(proc_mem_cmd_lo)
     ,.mem_v_o(proc_mem_cmd_v_lo)
     ,.mem_ready_and_i(proc_mem_cmd_ready_li)
     );

  logic proc_mem_resp_ready_lo;
  assign proc_mem_resp_yumi_lo = proc_mem_resp_ready_lo & proc_mem_resp_v_li;
  bp_lite_to_burst
   #(.bp_params_p(bp_params_p)
     ,.in_data_width_p(cce_block_width_p)
     ,.out_data_width_p(dword_width_p)
     ,.payload_mask_p(mem_resp_payload_mask_gp)
     )
   lite2burst
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_i(proc_mem_resp_li)
     ,.mem_v_i(proc_mem_resp_v_li)
     ,.mem_ready_and_o(proc_mem_resp_ready_lo)

     ,.mem_header_o(mem_resp_header_li)
     ,.mem_header_v_o(mem_resp_header_v_li)
     ,.mem_header_ready_and_i(mem_resp_header_yumi_lo)

     ,.mem_data_o(mem_resp_data_li)
     ,.mem_data_v_o(mem_resp_data_v_li)
     ,.mem_data_ready_and_i(mem_resp_data_yumi_lo)
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

     ,.mem_cmd_i(proc_mem_cmd_lo)
     ,.mem_cmd_v_i(proc_mem_cmd_v_lo & proc_mem_cmd_ready_li)
     ,.mem_cmd_ready_o(proc_mem_cmd_ready_li)

     ,.mem_resp_o(proc_mem_resp_li)
     ,.mem_resp_v_o(proc_mem_resp_v_li)
     ,.mem_resp_yumi_i(proc_mem_resp_yumi_lo)

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
  bp_nonsynth_nbf_loader
    #(.bp_params_p(bp_params_p))
    nbf_loader
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)
  
     ,.lce_id_i(4'b10)
  
     ,.io_cmd_o(load_cmd_lo)
     ,.io_cmd_v_o(load_cmd_v_lo)
     ,.io_cmd_yumi_i(load_cmd_yumi_li)
  
     ,.io_resp_i(load_resp_li)
     ,.io_resp_v_i(load_resp_v_li)
     ,.io_resp_ready_o(load_resp_ready_lo)

     ,.done_o()
    );
  
  localparam num_cycles_lp = 500000;
  logic [`BSG_SAFE_CLOG2(num_cycles_lp)-1:0] watchdog_cnt;
  bsg_counter_clear_up
   #(.max_val_p(num_cycles_lp), .init_val_p(0))
   watchdog_counter
   (.clk_i(blackparrot_clk)
   ,.reset_i(blackparrot_reset)
  
  ,.clear_i(1'b0)
  ,.up_i(1'b1)
  ,.count_o(watchdog_cnt)
  );

  always_ff @(negedge blackparrot_clk) begin
    if (watchdog_cnt == num_cycles_lp) begin
      $display("Terminating; TIMEOUT!");
      $finish;
    end
   end

endmodule
