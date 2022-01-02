puts "BSG-info: Running script [info script]\n"

########################################
## Source common scripts
source -echo -verbose $::env(BSG_DESIGNS_TARGET_DIR)/../common/bsg_chip_cdc.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_TARGET_DIR)/../common/bsg_chip_async.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_TARGET_DIR)/../common/bsg_chip_misc.tcl

########################################
## App Var Setup
# Needed for CDC multiple clock path constraints
set_app_var timing_enable_multiple_clocks_per_reg true
# Needed for retiming in some cases
set_app_var compile_keep_original_for_external_references true
# Needed for automatic clock-gate insertions
set_app_var case_analysis_propagate_through_icg true

########################################
## Clock Setup
set bp_clk_name "bp_clk" ;# main clock running black parrot
#set bp_clk_period_ps       1000
set bp_clk_period_ps       800
set bp_clk_uncertainty_per 3.0
set bp_clk_uncertainty_ps  [expr min([expr ${bp_clk_period_ps}*(${bp_clk_uncertainty_per}/100.0)], 20)]

set bp_input_delay_min_per 2.0
set bp_input_delay_min_ps  [expr ${bp_clk_period_ps}*(${bp_input_delay_min_per}/100.0)]
set bp_input_delay_max_per 60.0
set bp_input_delay_max_ps  [expr ${bp_clk_period_ps}*(${bp_input_delay_max_per}/100.0)]

set bp_output_delay_min_per 2.0
set bp_output_delay_min_ps  [expr ${bp_clk_period_ps}*(${bp_output_delay_min_per}/100.0)]
set bp_output_delay_max_per 20.0
set bp_output_delay_max_ps  [expr ${bp_clk_period_ps}*(${bp_output_delay_max_per}/100.0)]

########################################
## Reg2Reg
remove_clock -all
create_clock -period ${bp_clk_period_ps} -name ${bp_clk_name} [get_ports "clk_i"]
set_clock_uncertainty ${bp_clk_uncertainty_ps} [get_clocks ${bp_clk_name}]

#set l2_clk_name "l2_clk"
#create_generated_clock -name $l2_clk_name -divide_by 4 [get_pins unicore/l2s/dc.l2_ds/clk_r_o] -source [get_ports "clk_i"]
### TODO: Multicycle input same as output?
##set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/reset_i]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/cache_pkt_i[*]]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/v_i]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/ready_o]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/data_o[*]]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/v_o]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/yumi_i]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/dma_pkt_o[*]]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/dma_pkt_v_o]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/dma_pkt_yumi_i]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/dma_data_o[*]]
#set_multicycle_path 4 -end -through [get_pins unicore/l2s/cache/dma_data_v_o]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/dma_data_yumi_i]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/dma_data_i[*]]
#set_multicycle_path 4 -start -through [get_pins unicore/l2s/cache/dma_data_v_i]
#set_multicycle_path 4 -through [get_pins unicore/l2s/cache/dma_data_ready_o]

########################################
## In2Reg
set bp_input_pins [filter_collection [all_inputs] "name!~*clk*"]
set_input_delay -min ${bp_input_delay_min_ps} -clock ${bp_clk_name} ${bp_input_pins}
set_input_delay -max ${bp_input_delay_max_ps} -clock ${bp_clk_name} ${bp_input_pins}
set_driving_cell -min -no_design_rule -lib_cell $LIB_CELLS(invx2) [all_inputs]
set_driving_cell -max -no_design_rule -lib_cell $LIB_CELLS(invx8) [all_inputs]

########################################
## Reg2Out
set bp_output_pins [all_outputs]
set_output_delay -min ${bp_output_delay_min_ps} -clock ${bp_clk_name} ${bp_output_pins}
set_output_delay -max ${bp_output_delay_max_ps} -clock ${bp_clk_name} ${bp_output_pins}
set_load -min [load_of [get_lib_pin */$LIB_CELLS(invx2,load_pin)]] [all_outputs]
set_load -max [load_of [get_lib_pin */$LIB_CELLS(invx8,load_pin)]] [all_outputs]

########################################
## Disabled or false paths
bsg_chip_disable_1r1w_paths {"*regfile*rf*"}
bsg_chip_disable_1r1w_paths {"*btb*tag_mem*"}
bsg_chip_disable_1r1w_paths {"*bht*mem*"}

## This is a hack, should be multicycle or latched
set_false_path -from [get_ports "reset_i"]

########################################
## CDC Paths
update_timing
#bsg_chip_async_constraints
#bsg_chip_cdc_constraints [all_clocks]

########################################
## Derate
bsg_chip_derate_cells
bsg_chip_derate_mems
#report_timing_derate

########################################
## Ungrouping
set_ungroup [get_designs -filter "hdl_template==bsg_dff_chain"                   ] true
set_ungroup [get_designs -filter "hdl_template==bsg_mux_one_hot"                 ] true
set_ungroup [get_designs -filter "hdl_template==bsg_scan"                        ] true
set_ungroup [get_designs -filter "hdl_template==bsg_priority_encode_one_hot_out" ] true
set_ungroup [get_designs -filter "hdl_template==bsg_priority_encode"             ] true

set_ungroup [get_designs -filter "hdl_template==bp_be_dcache"                    ] true
set_ungroup [get_designs -filter "hdl_template==bp_be_dcache_decoder"            ] true
set_ungroup [get_designs -filter "hdl_template==bp_be_dcache_wbuf"               ] true
set_ungroup [get_designs -filter "hdl_template==bp_be_fp_to_reg"                 ] true
set_ungroup [get_designs -filter "hdl_template==bp_be_reg_to_fp"                 ] true
set_ungroup [get_designs -filter "hdl_template==bp_fe_icache"                    ] true
set_ungroup [get_designs -filter "hdl_template==bp_fe_pc_gen"                    ] true
set_ungroup [get_designs -filter "hdl_template==bp_fe_instr_scan"                ] true
set_ungroup [get_designs -filter "hdl_template==bp_mmu"                          ] true
set_ungroup [get_designs -filter "hdl_template==bp_be_ptw"                       ] true
set_ungroup [get_designs -filter "hdl_template==bp_tlb"                          ] true
#set_ungroup [get_designs -filter "hdl_template==bsg_bus_pack"                    ] true

set_ungroup [get_designs -filter "hdl_template==compareRecFN"                    ] true 
set_ungroup [get_designs -filter "hdl_template==divSqrtRecFNToRaw_small"         ] true
set_ungroup [get_designs -filter "hdl_template==fNToRecFN"                       ] true
set_ungroup [get_designs -filter "hdl_template==recFNToRawFN"                    ] true
set_ungroup [get_designs -filter "hdl_template==roundAnyRawFNToRecFN"            ] true
set_ungroup [get_designs -filter "hdl_template==iNFromException"                 ] true
set_ungroup [get_designs -filter "hdl_template==iNToRawFN"                       ] true
set_ungroup [get_designs -filter "hdl_template==iNToRecFN"                       ] true
set_ungroup [get_designs -filter "hdl_template==isSigNaNRecFN"                   ] true
set_ungroup [get_designs -filter "hdl_template==mulAddRecFNToRaw"                ] true
set_ungroup [get_designs -filter "hdl_template==recFNToFN"                       ] true
set_ungroup [get_designs -filter "hdl_template==recFNToIN"                       ] true
set_ungroup [get_designs -filter "hdl_template==recFNToRecFN"                    ] true
set_ungroup [get_designs -filter "hdl_template==reverse"                         ] true
set_ungroup [get_designs -filter "hdl_template==lowMaskHiLo"                     ] true
set_ungroup [get_designs -filter "hdl_template==lowMaskLoHi"                     ] true
set_ungroup [get_designs -filter "hdl_template==bsg_counting_leading_zeros"      ] true
set_ungroup [get_designs -filter "hdl_template==compressBy2"                     ] true
set_ungroup [get_designs -filter "hdl_template==compressBy4"                     ] true

########################################
## Retiming
set_optimize_registers true -designs [get_designs bp_be_pipe_aux* ] -check_design -verbose
set_optimize_registers true -designs [get_designs bp_be_pipe_fma* ] -check_design -verbose
set_optimize_registers true -designs [get_designs bp_be_pipe_long*] -check_design -verbose
update_timing

#set_app_var sh_continue_on_error false
#error

puts "BSG-info: Completed script [info script]\n"

