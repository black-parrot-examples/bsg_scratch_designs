
set basejump_stl_dir       $::env(BASEJUMP_STL_DIR)
set bsg_designs_target_dir $::env(BSG_DESIGNS_TARGET_DIR)
set blackparrot_dir        $::env(BLACKPARROT_DIR)

set bp_common_dir ${blackparrot_dir}/bp_common
set bp_top_dir    ${blackparrot_dir}/bp_top
set bp_fe_dir     ${blackparrot_dir}/bp_fe
set bp_be_dir     ${blackparrot_dir}/bp_be
set bp_me_dir     ${blackparrot_dir}/bp_me

set HARD_INCLUDE_PATHS [join "
  $basejump_stl_dir/hard/gf14/bsg_mem/
"]

# list of files to replace
set HARD_SWAP_FILELIST [join "
  $bsg_designs_target_dir/hard/gf_14/bsg_mem/bsg_mem_1rw_sync.v
  $bsg_designs_target_dir/hard/gf_14/bsg_mem/bsg_mem_1rw_sync_mask_write_bit.v
  $bsg_designs_target_dir/hard/gf_14/bsg_mem/bsg_mem_1rw_sync_mask_write_byte.v
  $bsg_designs_target_dir/hard/gf_14/bsg_mem/bsg_mem_1r1w_sync.v
  $bsg_designs_target_dir/hard/gf_14/bsg_mem/bsg_mem_2r1w_sync.v
  $bsg_designs_target_dir/hard/gf_14/bsg_mem/bsg_mem_3r1w_sync.v
  $bsg_designs_target_dir/hard/gf_14/bsg_misc/bsg_mux.v
"]

set NETLIST_SOURCE_FILES [join "
"]

set NEW_SVERILOG_SOURCE_FILES [join "
"]

