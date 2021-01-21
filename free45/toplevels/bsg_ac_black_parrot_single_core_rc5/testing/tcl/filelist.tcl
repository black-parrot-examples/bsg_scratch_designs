#------------------------------------------------------------
# Do NOT arbitrarily change the order of files. Some module
# and macro definitions may be needed by the subsequent files
#------------------------------------------------------------

set basejump_stl_dir       $::env(BASEJUMP_STL_DIR)
set blackparrot_dir        $::env(BLACKPARROT_DIR)
set bsg_designs_target_dir $::env(BSG_DESIGNS_TARGET_DIR)
set board_dir              $::env(BOARD_DIR)
set bsg_designs_dir        $::env(BSG_DESIGNS_DIR)
set bsg_packaging_dir      $::env(BSG_PACKAGING_DIR)

set bsg_package       $::env(BSG_PACKAGE)
set bsg_pinout        $::env(BSG_PINOUT)
set bsg_padmapping    $::env(BSG_PADMAPPING)

set bp_common_dir ${blackparrot_dir}/bp_common
set bp_top_dir    ${blackparrot_dir}/bp_top
set bp_fe_dir     ${blackparrot_dir}/bp_fe
set bp_be_dir     ${blackparrot_dir}/bp_be
set bp_me_dir     ${blackparrot_dir}/bp_me

set TESTING_SOURCE_FILES [join "
  $basejump_stl_dir/bsg_test/bsg_dramsim3_pkg.v
  $basejump_stl_dir/bsg_tag/bsg_tag_pkg.v
  $basejump_stl_dir/bsg_noc/bsg_noc_pkg.v
  $basejump_stl_dir/bsg_noc/bsg_wormhole_router_pkg.v
  $bp_common_dir/src/include/bp_common_rv64_pkg.sv
  $bp_common_dir/src/include/bp_common_cfg_link_pkg.sv
  $bp_common_dir/src/include/bp_common_pkg.sv
  $bp_common_dir/src/include/bp_common_aviary_pkg.sv
  $bp_me_dir/src/include/v/bp_me_pkg.sv
  $bp_me_dir/src/include/v/bp_cce_pkg.sv
  $bp_me_dir/test/common/bp_dramsim3_pkg.sv
  $bp_be_dir/src/include/bp_be_pkg.sv
  $bp_be_dir/src/include/bp_be_dcache_pkg.sv

  $basejump_stl_dir/bsg_async/bsg_async_fifo.v
  $basejump_stl_dir/bsg_async/bsg_async_ptr_gray.v
  $basejump_stl_dir/bsg_async/bsg_launch_sync_sync.v
  $basejump_stl_dir/bsg_dataflow/bsg_flow_counter.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_reorder.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1r1w_small.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_1r1w_small_unhardened.v
  $basejump_stl_dir/bsg_dataflow/bsg_fifo_tracker.v
  $basejump_stl_dir/bsg_dataflow/bsg_flow_counter.v
  $basejump_stl_dir/bsg_dataflow/bsg_parallel_in_serial_out.v
  $basejump_stl_dir/bsg_dataflow/bsg_parallel_in_serial_out_dynamic.v
  $basejump_stl_dir/bsg_dataflow/bsg_round_robin_1_to_n.v
  $basejump_stl_dir/bsg_dataflow/bsg_round_robin_n_to_1.v
  $basejump_stl_dir/bsg_dataflow/bsg_serial_in_parallel_out_full.v
  $basejump_stl_dir/bsg_dataflow/bsg_serial_in_parallel_out_dynamic.v
  $basejump_stl_dir/bsg_dataflow/bsg_one_fifo.v
  $basejump_stl_dir/bsg_dataflow/bsg_two_fifo.v
  $basejump_stl_dir/bsg_mem/bsg_cam_1r1w.v
  $basejump_stl_dir/bsg_mem/bsg_cam_1r1w_tag_array.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w.v
  $basejump_stl_dir/bsg_mem/bsg_mem_1r1w_synth.v
  $basejump_stl_dir/bsg_mem/bsg_nonsynth_mem_1rw_sync_mask_write_byte_dma.v
  $basejump_stl_dir/bsg_mem/bsg_nonsynth_mem_1r1w_sync_mask_write_byte_dma.v
  $basejump_stl_dir/bsg_mem/bsg_mem_dma.cpp
  $basejump_stl_dir/bsg_misc/bsg_buf.v
  $basejump_stl_dir/bsg_misc/bsg_circular_ptr.v
  $basejump_stl_dir/bsg_misc/bsg_counter_clear_up.v
  $basejump_stl_dir/bsg_misc/bsg_counter_up_down.v
  $basejump_stl_dir/bsg_misc/bsg_decode.v
  $basejump_stl_dir/bsg_misc/bsg_decode_with_v.v
  $basejump_stl_dir/bsg_misc/bsg_dff.v
  $basejump_stl_dir/bsg_misc/bsg_dff_en.v
  $basejump_stl_dir/bsg_misc/bsg_dff_en_bypass.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset_en.v
  $basejump_stl_dir/bsg_misc/bsg_dff_reset_set_clear.v
  $basejump_stl_dir/bsg_misc/bsg_encode_one_hot.v
  $basejump_stl_dir/bsg_misc/bsg_mux.v
  $basejump_stl_dir/bsg_misc/bsg_muxi2_gatestack.v
  $basejump_stl_dir/bsg_misc/bsg_nand.v
  $basejump_stl_dir/bsg_misc/bsg_nor3.v
  $basejump_stl_dir/bsg_misc/bsg_priority_encode.v
  $basejump_stl_dir/bsg_misc/bsg_priority_encode_one_hot_out.v
  $basejump_stl_dir/bsg_misc/bsg_reduce.v
  $basejump_stl_dir/bsg_misc/bsg_rotate_right.v
  $basejump_stl_dir/bsg_misc/bsg_rotate_left.v
  $basejump_stl_dir/bsg_misc/bsg_scan.v
  $basejump_stl_dir/bsg_misc/bsg_strobe.v
  $basejump_stl_dir/bsg_misc/bsg_xnor.v


  $basejump_stl_dir/bsg_test/bsg_nonsynth_clock_gen.v
  $basejump_stl_dir/bsg_test/bsg_nonsynth_reset_gen.v
  $basejump_stl_dir/bsg_test/bsg_nonsynth_test_rom.v
  $basejump_stl_dir/testing/bsg_dmc/lpddr_verilog_model/mobile_ddr.v
  $bp_me_dir/test/common/bp_mem.sv
  $bp_me_dir/test/common/bp_mem_to_dram.sv
  $bp_top_dir/test/common/bp_nonsynth_host.sv
  $bp_top_dir/test/common/bp_monitor.cpp
  $bp_top_dir/test/common/bp_nonsynth_nbf_loader.sv
  $bp_common_dir/src/v/bsg_bus_pack.sv
  $bp_me_dir/src/v/wormhole/bp_burst_to_lite.sv
  $bp_me_dir/src/v/wormhole/bp_lite_to_burst.sv

  $bsg_designs_target_dir/v/bsg_chip_pkg.v
  $bsg_designs_target_dir/testing/v/bsg_gateway_chip.v
"]

