`timescale 1ps/1ps

`ifndef BLACKPARROT_CLK_PERIOD
  `define BLACKPARROT_CLK_PERIOD 5000.0
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

#(localparam bp_params_e bp_params_p = bp_cfg_gp `declare_bp_proc_params(bp_params_p)
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
  bp_bedrock_cce_mem_msg_s io_cmd_lo;
  logic io_cmd_v_lo, io_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s io_resp_li;
  logic io_resp_v_li, io_resp_ready_lo;

  bp_bedrock_cce_mem_msg_s io_cmd_li;
  logic io_cmd_v_li, io_cmd_ready_lo;
  bp_bedrock_cce_mem_msg_s io_resp_lo;
  logic io_resp_v_lo, io_resp_ready_li;

  bp_bedrock_cce_mem_msg_s dram_cmd_lo;
  logic dram_cmd_v_lo, dram_cmd_ready_li;
  bp_bedrock_cce_mem_msg_s dram_resp_li;
  logic dram_resp_v_li, dram_resp_ready_lo;

  `declare_bsg_ready_and_link_sif_s(io_noc_flit_width_p, bp_io_noc_ral_link_s);
  `declare_bsg_ready_and_link_sif_s(mem_noc_flit_width_p, bp_mem_noc_ral_link_s);

  bp_io_noc_ral_link_s proc_cmd_link_li, proc_cmd_link_lo;
  bp_io_noc_ral_link_s proc_resp_link_li, proc_resp_link_lo;
  bp_mem_noc_ral_link_s dram_cmd_link_lo, dram_resp_link_li;
  bp_io_noc_ral_link_s stub_cmd_link_li, stub_resp_link_li;
  bp_io_noc_ral_link_s stub_cmd_link_lo, stub_resp_link_lo;

  assign stub_cmd_link_li = '0;
  assign stub_resp_link_li = '0;

  bsg_chip
   DUT
    (.core_clk_i(blackparrot_clk)
     ,.core_reset_i(blackparrot_reset)

     ,.coh_clk_i(blackparrot_clk)
     ,.coh_reset_i(blackparrot_reset)

     ,.io_clk_i(blackparrot_clk)
     ,.io_reset_i(blackparrot_reset)

     ,.mem_clk_i(blackparrot_clk)
     ,.mem_reset_i(blackparrot_reset)

     ,.my_did_i(io_noc_did_width_p'(1'b1))
     ,.host_did_i('1)

     ,.io_cmd_link_i({proc_cmd_link_li, stub_cmd_link_li})
     ,.io_cmd_link_o({proc_cmd_link_lo, stub_cmd_link_lo})

     ,.io_resp_link_i({proc_resp_link_li, stub_resp_link_li})
     ,.io_resp_link_o({proc_resp_link_lo, stub_resp_link_lo})

     ,.dram_cmd_link_o(dram_cmd_link_lo)
     ,.dram_resp_link_i(dram_resp_link_li)
     );

  bp_me_cce_to_mem_link_bidir
   #(.bp_params_p(bp_params_p)
     ,.num_outstanding_req_p(io_noc_max_credits_p)
     ,.flit_width_p(io_noc_flit_width_p)
     ,.cord_width_p(io_noc_cord_width_p)
     ,.cid_width_p(io_noc_cid_width_p)
     ,.len_width_p(io_noc_len_width_p)
     )
   host_link
    (.clk_i(blackparrot_clk)
     ,.reset_i(blackparrot_reset)

     ,.mem_cmd_i(io_cmd_lo)
     ,.mem_cmd_v_i(io_cmd_v_lo & io_cmd_ready_li)
     ,.mem_cmd_ready_o(io_cmd_ready_li)

     ,.mem_resp_o(io_resp_li)
     ,.mem_resp_v_o(io_resp_v_li)
     ,.mem_resp_yumi_i(io_resp_ready_lo & io_resp_v_li)

     ,.my_cord_i(io_noc_cord_width_p'('1))
     ,.my_cid_i('0)
     ,.dst_cord_i(io_noc_cord_width_p'(1'b1))
     ,.dst_cid_i('0)

     ,.mem_cmd_o(io_cmd_li)
     ,.mem_cmd_v_o(io_cmd_v_li)
     ,.mem_cmd_yumi_i(io_cmd_ready_lo & io_cmd_v_li)

     ,.mem_resp_i(io_resp_lo)
     ,.mem_resp_v_i(io_resp_v_lo & io_resp_ready_li)
     ,.mem_resp_ready_o(io_resp_ready_li)

     ,.cmd_link_i(proc_cmd_link_lo)
     ,.cmd_link_o(proc_cmd_link_li)
     ,.resp_link_i(proc_resp_link_lo)
     ,.resp_link_o(proc_resp_link_li)
     );

  bp_me_cce_to_mem_link_client
   #(.bp_params_p(bp_params_p)
     ,.num_outstanding_req_p(mem_noc_max_credits_p)
     ,.flit_width_p(mem_noc_flit_width_p)
     ,.cord_width_p(mem_noc_cord_width_p)
     ,.cid_width_p(mem_noc_cid_width_p)
     ,.len_width_p(mem_noc_len_width_p)
     )
   dram_link
    (.clk_i(blackparrot_clk)

     ,.reset_i(blackparrot_reset)
  
     ,.mem_cmd_o(dram_cmd_lo)
     ,.mem_cmd_v_o(dram_cmd_v_lo)
     ,.mem_cmd_yumi_i(dram_cmd_ready_li & dram_cmd_v_lo)
  
     ,.mem_resp_i(dram_resp_li)
     ,.mem_resp_v_i(dram_resp_v_li & dram_resp_ready_lo)
     ,.mem_resp_ready_o(dram_resp_ready_lo)
  
     ,.cmd_link_i(dram_cmd_link_lo)
     ,.resp_link_o(dram_resp_link_li)
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

     ,.mem_cmd_i(dram_cmd_lo)
     ,.mem_cmd_v_i(dram_cmd_v_lo & dram_cmd_v_lo)
     ,.mem_cmd_ready_o(dram_cmd_ready_li)

     ,.mem_resp_o(dram_resp_li)
     ,.mem_resp_v_o(dram_resp_v_li)
     ,.mem_resp_yumi_i(dram_resp_ready_lo & dram_resp_v_li)

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
  
     ,.io_cmd_i(io_cmd_li)
     ,.io_cmd_v_i(io_cmd_v_li & io_cmd_ready_lo)
     ,.io_cmd_ready_o(io_cmd_ready_lo)
  
     ,.io_resp_o(io_resp_lo)
     ,.io_resp_v_o(io_resp_v_lo)
     ,.io_resp_yumi_i(io_resp_ready_li & io_resp_v_lo)

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
  
     ,.lce_id_i('1)
  
     ,.io_cmd_o(io_cmd_lo)
     ,.io_cmd_v_o(io_cmd_v_lo)
     ,.io_cmd_yumi_i(io_cmd_ready_li & io_cmd_v_lo)
  
     ,.io_resp_i(io_resp_li)
     ,.io_resp_v_i(io_resp_v_li)
     ,.io_resp_ready_o(io_resp_ready_lo)
    );



endmodule

