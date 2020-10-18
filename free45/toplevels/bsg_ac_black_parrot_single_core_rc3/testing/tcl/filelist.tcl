#------------------------------------------------------------
# Do NOT arbitrarily change the order of files. Some module
# and macro definitions may be needed by the subsequent files
#------------------------------------------------------------

set basejump_stl_dir       $::env(BASEJUMP_STL_DIR)
set black_parrot_dir       $::env(BLACK_PARROT_DIR)
set bsg_designs_target_dir $::env(BSG_DESIGNS_TARGET_DIR)
set board_dir              $::env(BOARD_DIR)
set bsg_designs_dir        $::env(BSG_DESIGNS_DIR)
set bsg_packaging_dir      $::env(BSG_PACKAGING_DIR)

set bsg_package       $::env(BSG_PACKAGE)
set bsg_pinout        $::env(BSG_PINOUT)
set bsg_padmapping    $::env(BSG_PADMAPPING)

set bp_common_dir ${black_parrot_dir}/bp_common
set bp_top_dir    ${black_parrot_dir}/bp_top
set bp_fe_dir     ${black_parrot_dir}/bp_fe
set bp_be_dir     ${black_parrot_dir}/bp_be
set bp_me_dir     ${black_parrot_dir}/bp_me

set TESTING_SOURCE_FILES [join "
  $basejump_stl_dir/bsg_test/bsg_nonsynth_clock_gen.v
  $basejump_stl_dir/bsg_test/bsg_nonsynth_reset_gen.v
  $basejump_stl_dir/bsg_test/bsg_nonsynth_test_rom.v
  $basejump_stl_dir/testing/bsg_dmc/lpddr_verilog_model/mobile_ddr.v
  $bp_top_dir/test/common/bp_monitor.cpp
  $bp_me_dir/test/common/bp_mem.v
  $bp_me_dir/test/common/bp_mem_transducer.v
  $bp_me_dir/test/common/bp_mem_delay_model.v
  $bp_me_dir/test/common/bp_mem_storage_sync.v
  $bp_me_dir/test/common/bp_mem_utils.cpp
  $bp_top_dir/test/common/bp_nonsynth_host.v
  $bp_top_dir/test/common/bp_nonsynth_nbf_loader.v
  $bp_top_dir/test/common/bp_nonsynth_watchdog.v
  $bsg_designs_target_dir/testing/v/wrapper.v
  $bsg_designs_target_dir/testing/v/bsg_gateway_chip.v
"]

