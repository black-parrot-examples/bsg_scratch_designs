#------------------------------------------------------------
# Do NOT arbitrarily change the order of files. Some module
# and macro definitions may be needed by the subsequent files
#------------------------------------------------------------

set basejump_stl_dir       $::env(BASEJUMP_STL_DIR)
set bsg_designs_target_dir $::env(BSG_DESIGNS_TARGET_DIR)
set blackparrot_dir        $::env(BLACKPARROT_DIR)
set hardfloat_dir          $::env(BLACKPARROT_DIR)/external/HardFloat

set bsg_packaging_dir $::env(BSG_PACKAGING_DIR)
set bsg_package       $::env(BSG_PACKAGE)
set bsg_pinout        $::env(BSG_PINOUT)
set bsg_padmapping    $::env(BSG_PADMAPPING)

set bp_common_dir ${blackparrot_dir}/bp_common
set bp_top_dir    ${blackparrot_dir}/bp_top
set bp_fe_dir     ${blackparrot_dir}/bp_fe
set bp_be_dir     ${blackparrot_dir}/bp_be
set bp_me_dir     ${blackparrot_dir}/bp_me

set SVERILOG_SOURCE_FILES [join "
  $basejump_stl_dir/bsg_cache/bsg_cache_pkg.v
  $basejump_stl_dir/bsg_noc/bsg_mesh_router_pkg.v
  $basejump_stl_dir/bsg_noc/bsg_noc_pkg.v
  $basejump_stl_dir/bsg_tag/bsg_tag_pkg.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_pkg.v
  $bp_common_dir/src/include/bp_common_pkg.sv
  $bp_fe_dir/src/include/bp_fe_pkg.sv
  $bp_be_dir/src/include/bp_be_pkg.sv
  $bp_me_dir/src/include/bp_me_pkg.sv
  $bp_top_dir/src/include/bp_top_pkg.sv
  $basejump_stl_dir/bsg_cache/bsg_cache.v
  $basejump_stl_dir/bsg_cache/bsg_cache_dma.v
  $basejump_stl_dir/bsg_cache/bsg_cache_miss.v
  $basejump_stl_dir/bsg_cache/bsg_cache_decode.v
  $basejump_stl_dir/bsg_cache/bsg_cache_sbuf.v
  $basejump_stl_dir/bsg_cache/bsg_cache_sbuf_queue.v
  $basejump_stl_dir/bsg_dataflow/bsg_channel_tunnel.v
  $basejump_stl_dir/bsg_dataflow/bsg_channel_tunnel_in.v
  $basejump_stl_dir/bsg_dataflow/bsg_channel_tunnel_out.v
  $basejump_stl_dir/bsg_dataflow/bsg_1_to_n_tagged_fifo.v
  $basejump_stl_dir/bsg_dataflow/bsg_1_to_n_tagged.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1r1w_large.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1rw_large.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_reorder.v
  $basejump_stl_dir/bsg_dataflow/bsg_serial_in_parallel_out.v
  $basejump_stl_dir/bsg_dataflow/bsg_one_fifo.v
  $basejump_stl_dir/bsg_dataflow/bsg_round_robin_2_to_2.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1r1w_pseudo_large.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1r1w_small.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1r1w_small_unhardened.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_tracker.v
  $basejump_stl_dir/bsg_dataflow/bsg_flow_counter.v
  $basejump_stl_dir/bsg_dataflow/bsg_parallel_in_serial_out_dynamic.v
  $basejump_stl_dir/bsg_dataflow/bsg_round_robin_n_to_1.v
  $basejump_stl_dir/bsg_dataflow/bsg_serial_in_parallel_out_dynamic.v
  $basejump_stl_dir/bsg_dataflow/bsg_shift_reg.v
  $basejump_stl_dir/bsg_dataflow/bsg_two_fifo.v
  $basejump_stl_dir/bsg_mem/bsg_cam_1r1w.v
  $basejump_stl_dir/bsg_mem/bsg_cam_1r1w_replacement.v
  $basejump_stl_dir/bsg_mem/bsg_cam_1r1w_sync.v
  $basejump_stl_dir/bsg_mem/bsg_cam_1r1w_tag_array.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w_one_hot.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w_sync.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w_sync_synth.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w_synth.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_mask_write_bit.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_mask_write_bit_banked.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_mask_write_bit_synth.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_mask_write_byte.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_mask_write_byte_banked.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_mask_write_byte_synth.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1rw_sync_synth.v
  $basejump_stl_dir/bsg_mem/bsg_mem_2r1w_sync.v
  $basejump_stl_dir/bsg_mem/bsg_mem_2r1w_sync_synth.v
  $basejump_stl_dir/bsg_mem/bsg_mem_3r1w_sync.v
  $basejump_stl_dir/bsg_mem/bsg_mem_3r1w_sync_synth.v
  $basejump_stl_dir/bsg_misc/bsg_adder_ripple_carry.v
  $basejump_stl_dir/bsg_misc/bsg_adder_one_hot.v
  $basejump_stl_dir/bsg_misc/bsg_arb_fixed.v
  $basejump_stl_dir/bsg_misc/bsg_arb_round_robin.v
  $basejump_stl_dir/bsg_misc/bsg_array_concentrate_static.v
  $basejump_stl_dir/bsg_misc/bsg_circular_ptr.v
  $basejump_stl_dir/bsg_misc/bsg_concentrate_static.v
  $basejump_stl_dir/bsg_misc/bsg_counter_clear_up.v
  $basejump_stl_dir/bsg_misc/bsg_counter_clear_up_one_hot.v
  $basejump_stl_dir/bsg_misc/bsg_counter_set_en.v
  $basejump_stl_dir/bsg_misc/bsg_counter_set_down.v
  $basejump_stl_dir/bsg_misc/bsg_counter_up_down.v
  $basejump_stl_dir/bsg_misc/bsg_counter_up_down_variable.v
  $basejump_stl_dir/bsg_misc/bsg_crossbar_o_by_i.v
  $basejump_stl_dir/bsg_misc/bsg_cycle_counter.v
  $basejump_stl_dir/bsg_misc/bsg_decode.v
  $basejump_stl_dir/bsg_misc/bsg_decode_with_v.v
  $basejump_stl_dir/bsg_misc/bsg_dff.v
  $basejump_stl_dir/bsg_misc/bsg_dff_en_bypass.v
  $basejump_stl_dir/bsg_misc/bsg_dff_chain.v
  $basejump_stl_dir/bsg_misc/bsg_dff_en.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset_en.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset_en_bypass.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset_set_clear.v
  $basejump_stl_dir/bsg_misc/bsg_edge_detect.v
  $basejump_stl_dir/bsg_misc/bsg_encode_one_hot.v
  $basejump_stl_dir/bsg_misc/bsg_expand_bitmask.v
  $basejump_stl_dir/bsg_misc/bsg_hash_bank.v
  $basejump_stl_dir/bsg_misc/bsg_hash_bank_reverse.v
  $basejump_stl_dir/bsg_misc/bsg_idiv_iterative.v
  $basejump_stl_dir/bsg_misc/bsg_idiv_iterative_controller.v
  $basejump_stl_dir/bsg_misc/bsg_lfsr.v
  $basejump_stl_dir/bsg_misc/bsg_lru_pseudo_tree_decode.v
  $basejump_stl_dir/bsg_misc/bsg_lru_pseudo_tree_encode.v
  $basejump_stl_dir/bsg_misc/bsg_lru_pseudo_tree_backup.v
  $basejump_stl_dir/bsg_misc/bsg_mux.v
  $basejump_stl_dir/bsg_misc/bsg_mux_bitwise.v
  $basejump_stl_dir/bsg_misc/bsg_mux_butterfly.v
  $basejump_stl_dir/bsg_misc/bsg_mux_one_hot.v
  $basejump_stl_dir/bsg_misc/bsg_mux_segmented.v
  $basejump_stl_dir/bsg_misc/bsg_priority_encode.v
  $basejump_stl_dir/bsg_misc/bsg_priority_encode_one_hot_out.v
  $basejump_stl_dir/bsg_misc/bsg_round_robin_arb.v
  $basejump_stl_dir/bsg_misc/bsg_rotate_left.v
  $basejump_stl_dir/bsg_misc/bsg_rotate_right.v
  $basejump_stl_dir/bsg_misc/bsg_scan.v
  $basejump_stl_dir/bsg_misc/bsg_swap.v
  $basejump_stl_dir/bsg_misc/bsg_thermometer_count.v
  $basejump_stl_dir/bsg_misc/bsg_tiehi.v
  $basejump_stl_dir/bsg_misc/bsg_tielo.v
  $basejump_stl_dir/bsg_misc/bsg_transpose.v
  $basejump_stl_dir/bsg_misc/bsg_unconcentrate_static.v
  $basejump_stl_dir/bsg_noc/bsg_mesh_router.v
  $basejump_stl_dir/bsg_noc/bsg_mesh_router_buffered.v
  $basejump_stl_dir/bsg_noc/bsg_mesh_router_decoder_dor.v
  $basejump_stl_dir/bsg_noc/bsg_mesh_stitch.v
  $basejump_stl_dir/bsg_noc/bsg_noc_repeater_node.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_concentrator.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_concentrator_in.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_concentrator_out.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_adapter.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_adapter_in.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_adapter_out.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_decoder_dor.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_input_control.v  
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_output_control.v 
  $hardfloat_dir/source/addRecFN.v
  $hardfloat_dir/source/compareRecFN.v
  $hardfloat_dir/source/divSqrtRecFN_small.v
  $hardfloat_dir/source/fNToRecFN.v
  $hardfloat_dir/source/HardFloat_primitives.v
  $hardfloat_dir/source/HardFloat_rawFN.v
  $hardfloat_dir/source/iNToRecFN.v
  $hardfloat_dir/source/isSigNaNRecFN.v
  $hardfloat_dir/source/mulAddRecFN.v
  $hardfloat_dir/source/mulRecFN.v
  $hardfloat_dir/source/recFNToFN.v
  $hardfloat_dir/source/recFNToIN.v
  $hardfloat_dir/source/recFNToRecFN.v
  $hardfloat_dir/source/RISCV/HardFloat_specialize.v
  $bp_common_dir/src/v/bp_mmu.sv
  $bp_common_dir/src/v/bp_pma.sv
  $bp_common_dir/src/v/bp_tlb.sv
  $bp_common_dir/src/v/bsg_fifo_1r1w_rolly.sv
  $bp_common_dir/src/v/bsg_bus_pack.sv
  $bp_common_dir/src/v/bsg_crossbar_control_locking_o_by_i.v
  $bp_be_dir/src/v/bp_be_top.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_calculator_top.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_csr.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_fp_to_rec.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_ctl.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_int.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_long.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_mem.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_sys.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_fma.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_pipe_aux.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_ptw.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_rec_to_fp.sv
  $bp_be_dir/src/v/bp_be_calculator/bp_be_nan_unbox.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_detector.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_director.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_instr_decoder.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_issue_queue.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_regfile.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_scheduler.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_scoreboard.sv
  $bp_be_dir/src/v/bp_be_checker/bp_be_cmd_queue.sv
  $bp_be_dir/src/v/bp_be_dcache/bp_be_dcache.sv
  $bp_be_dir/src/v/bp_be_dcache/bp_be_dcache_decoder.sv
  $bp_be_dir/src/v/bp_be_dcache/bp_be_dcache_wbuf.sv
  $bp_fe_dir/src/v/bp_fe_bht.sv
  $bp_fe_dir/src/v/bp_fe_btb.sv
  $bp_fe_dir/src/v/bp_fe_icache.sv
  $bp_fe_dir/src/v/bp_fe_instr_scan.sv
  $bp_fe_dir/src/v/bp_fe_pc_gen.sv
  $bp_fe_dir/src/v/bp_fe_top.sv
  $bp_me_dir/src/v/dev/bp_me_dram_hash_encode.sv
  $bp_me_dir/src/v/dev/bp_me_dram_hash_decode.sv
  $bp_me_dir/src/v/dev/bp_me_cce_to_cache.sv
  $bp_me_dir/src/v/dev/bp_me_bedrock_register.sv
  $bp_me_dir/src/v/network/bp_me_xbar_stream.sv
  $bp_me_dir/src/v/cce/bp_uce.sv
  $bp_me_dir/src/v/lce/bp_lce.sv
  $bp_me_dir/src/v/lce/bp_lce_req.sv
  $bp_me_dir/src/v/lce/bp_lce_cmd.sv
  $bp_me_dir/src/v/cce/bp_cce.sv
  $bp_me_dir/src/v/cce/bp_cce_alu.sv
  $bp_me_dir/src/v/cce/bp_cce_arbitrate.sv
  $bp_me_dir/src/v/cce/bp_cce_branch.sv
  $bp_me_dir/src/v/cce/bp_cce_dir.sv
  $bp_me_dir/src/v/cce/bp_cce_dir_lru_extract.sv
  $bp_me_dir/src/v/cce/bp_cce_dir_segment.sv
  $bp_me_dir/src/v/cce/bp_cce_dir_tag_checker.sv
  $bp_me_dir/src/v/cce/bp_cce_gad.sv
  $bp_me_dir/src/v/cce/bp_cce_inst_decode.sv
  $bp_me_dir/src/v/cce/bp_cce_inst_predecode.sv
  $bp_me_dir/src/v/cce/bp_cce_inst_ram.sv
  $bp_me_dir/src/v/cce/bp_cce_inst_stall.sv
  $bp_me_dir/src/v/dev/bp_me_loopback.sv
  $bp_me_dir/src/v/cce/bp_cce_msg.sv
  $bp_me_dir/src/v/cce/bp_cce_pending_bits.sv
  $bp_me_dir/src/v/cce/bp_cce_pma.sv
  $bp_me_dir/src/v/cce/bp_cce_reg.sv
  $bp_me_dir/src/v/cce/bp_cce_spec_bits.sv
  $bp_me_dir/src/v/cce/bp_cce_src_sel.sv
  $bp_me_dir/src/v/cce/bp_cce_wrapper.sv
  $bp_me_dir/src/v/cce/bp_cce_fsm.sv
  $bp_me_dir/src/v/cce/bp_io_cce.sv
  $bp_me_dir/src/v/cce/bp_bedrock_size_to_len.sv
  $bp_me_dir/src/v/network/bp_me_addr_to_cce_id.sv
  $bp_me_dir/src/v/network/bp_me_cce_id_to_cord.sv
  $bp_me_dir/src/v/network/bp_me_cce_to_mem_link_recv.sv
  $bp_me_dir/src/v/network/bp_me_cce_to_mem_link_send.sv
  $bp_me_dir/src/v/network/bp_me_cord_to_id.sv
  $bp_me_dir/src/v/network/bp_me_lce_id_to_cord.sv
  $bp_me_dir/src/v/network/bp_me_wormhole_packet_encode_lce_req.sv
  $bp_me_dir/src/v/network/bp_me_wormhole_packet_encode_lce_cmd.sv
  $bp_me_dir/src/v/network/bp_me_wormhole_packet_encode_lce_resp.sv
  $bp_me_dir/src/v/network/bp_me_wormhole_packet_encode_mem.sv
  $bp_me_dir/src/v/network/bp_me_burst_to_lite.sv
  $bp_me_dir/src/v/network/bp_me_burst_to_wormhole.sv
  $bp_me_dir/src/v/network/bp_me_wormhole_to_burst.sv
  $bp_me_dir/src/v/network/bp_me_lite_to_burst.sv
  $bp_me_dir/src/v/network/bp_me_stream_pump_in.sv
  $bp_me_dir/src/v/network/bp_me_stream_pump_out.sv
  $bp_me_dir/src/v/network/bp_me_stream_fifo.sv
  $bp_me_dir/src/v/network/bp_me_stream_wraparound.sv
  $bp_common_dir/src/v/bsg_cache_dma_to_wormhole.v
  $bp_common_dir/src/v/bsg_wormhole_stream_control.v
  $bp_common_dir/src/v/bsg_async_noc_link.sv
  $bp_common_dir/src/v/bsg_parallel_in_serial_out_passthrough_dynamic_last.v
  $bp_common_dir/src/v/bsg_serial_in_parallel_out_passthrough_dynamic_last.v
  $bp_common_dir/src/v/bsg_dff_sync_read.v
  $bp_common_dir/src/v/bsg_deff_reset.v
  $bp_top_dir/src/v/bp_cacc_complex.sv
  $bp_me_dir/src/v/dev/bp_me_cfg_slice.sv
  $bp_me_dir/src/v/dev/bp_me_clint_slice.sv
  $bp_me_dir/src/v/dev/bp_me_cache_slice.sv
  $bp_top_dir/src/v/bp_core.sv
  $bp_top_dir/src/v/bp_core_minimal.sv
  $bp_top_dir/src/v/bp_core_complex.sv
  $bp_top_dir/src/v/bp_io_complex.sv
  $bp_top_dir/src/v/bp_io_link_to_lce.sv
  $bp_top_dir/src/v/bp_io_tile.sv
  $bp_top_dir/src/v/bp_io_tile_node.sv
  $bp_top_dir/src/v/bp_mem_complex.sv
  $bp_top_dir/src/v/bp_nd_socket.sv
  $bp_top_dir/src/v/bp_multicore.sv
  $bp_top_dir/src/v/bp_sacc_complex.sv
  $bp_top_dir/src/v/bp_tile.sv
  $bp_top_dir/src/v/bp_tile_node.sv
  $bp_top_dir/src/v/bp_unicore.sv
  $bp_top_dir/src/v/bp_unicore_lite.sv

  $basejump_stl_dir/bsg_clk_gen/bsg_clk_gen.v
  $basejump_stl_dir/bsg_async/bsg_async_fifo.v
  $basejump_stl_dir/bsg_async/bsg_async_credit_counter.v
  $basejump_stl_dir/bsg_async/bsg_async_ptr_gray.v
  $basejump_stl_dir/bsg_async/bsg_launch_sync_sync.v
  $basejump_stl_dir/bsg_dataflow/bsg_round_robin_1_to_n.v
  $basejump_stl_dir/bsg_dataflow/bsg_parallel_in_serial_out.v
  $basejump_stl_dir/bsg_dataflow/bsg_serial_in_parallel_out_full.v
  $basejump_stl_dir/bsg_dataflow/bsg_parallel_in_serial_out_passthrough.v
  $basejump_stl_dir/bsg_dataflow/bsg_serial_in_parallel_out_passthrough.v
  $basejump_stl_dir/bsg_link/bsg_link_ddr_downstream.v
  $basejump_stl_dir/bsg_link/bsg_link_ddr_upstream.v
  $basejump_stl_dir/bsg_link/bsg_link_oddr_phy.v
  $basejump_stl_dir/bsg_link/bsg_link_iddr_phy.v
  $basejump_stl_dir/bsg_link/bsg_link_source_sync_upstream.v
  $basejump_stl_dir/bsg_link/bsg_link_source_sync_downstream.v
  $basejump_stl_dir/bsg_misc/bsg_xnor.v
  $basejump_stl_dir/bsg_misc/bsg_counting_leading_zeros.v
  $basejump_stl_dir/bsg_misc/bsg_mul_add_unsigned.v
  $basejump_stl_dir/bsg_misc/bsg_locking_arb_fixed.v
  $basejump_stl_dir/bsg_misc/bsg_nand.v
  $basejump_stl_dir/bsg_misc/bsg_buf.v
  $basejump_stl_dir/bsg_misc/bsg_adder_cin.v
  $basejump_stl_dir/bsg_misc/bsg_buf_ctrl.v
  $basejump_stl_dir/bsg_misc/bsg_dlatch.v
  $basejump_stl_dir/bsg_misc/bsg_gray_to_binary.v
  $basejump_stl_dir/bsg_misc/bsg_reduce.v
  $basejump_stl_dir/bsg_misc/bsg_reduce_segmented.v
  $basejump_stl_dir/bsg_misc/bsg_nor2.v
  $basejump_stl_dir/bsg_misc/bsg_nor3.v
  $basejump_stl_dir/bsg_misc/bsg_muxi2_gatestack.v
  $basejump_stl_dir/bsg_misc/bsg_mux2_gatestack.v
  $basejump_stl_dir/bsg_misc/bsg_counter_clock_downsample.v
  $basejump_stl_dir/bsg_misc/bsg_strobe.v
  $basejump_stl_dir/bsg_noc/bsg_ready_and_link_async_to_wormhole.v

  $bsg_designs_target_dir/v/bsg_chip_pkg.v
  $bsg_designs_target_dir/v/bsg_chip.v
"]

