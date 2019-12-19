source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_tag.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_chip_cdc.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_comm_link.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_clk_gen.constraints.tcl

########################################
##
## Clock Setup
##

set router_clk_name    "router_clk"     ;# core clock (everything that isn't a part of another clock is on this domain)
set io_master_clk_name "io_master_clk"  ;# 2x clock for DDR IO paths (1x clock generated from this clock)
set bp_clk_name        "bp_clk"         ;# main clock running block parrot
set coh_clk_name       "coh_clk"        ;# clock running coherence network
set tag_clk_name       "tag_clk"

set router_clk_period_ns       1.6660 ;# 600 MHz
set router_clk_uncertainty_ns 0.0020

set io_master_clk_period_ns       1.6660 ;# 600MHz
set io_master_clk_uncertainty_ns  0.0020
set io_clk_uncertainty_ns         0.0020

set bp_clk_period_ns       1.200
set bp_clk_uncertainty_per 0.0030
#set bp_clk_uncertainty_ns  [expr min([expr ${bp_clk_period_ns}*(${bp_clk_uncertainty_per}/100.0)], 50)]
set bp_clk_uncertainty_ns 0.0020

set coh_clk_period_ns       1.200
set coh_clk_uncertainty_per 0.0030
#set coh_clk_uncertainty_ns  [expr min([expr ${coh_clk_period_ns}*(${coh_clk_uncertainty_per}/100.0)], 50)]
set coh_clk_uncertainty_ns 0.0020

set oscillator_period_ns       .02500 ;# Raw oscillator frequency
set oscillator_uncertainty_ns  .0020
set ds_uncertainty_ns          .0020

set tag_clk_period_ns          6.6660 ;# 150 MHz
set tag_clk_uncertainty_ns     0.0020

########################################
##
## BP Tile Constraints
##

if { ${DESIGN_NAME} == "bp_tile_node" || ${DESIGN_NAME} == "bp_processor"} {

  set core_clk_name           ${bp_clk_name}
  set core_clk_period_ns      ${bp_clk_period_ns}
  set core_clk_uncertainty_ns ${bp_clk_uncertainty_ns}

  # TODO: tied to core clock at the moment
  set coh_clk_name           ${coh_clk_name}
  set coh_clk_period_ns      ${coh_clk_period_ns}
  set coh_clk_uncertainty_ns ${coh_clk_uncertainty_ns}

  set mem_clk_name           ${router_clk_name}
  set mem_clk_period_ns      ${router_clk_period_ns}
  set mem_clk_uncertainty_ns ${router_clk_uncertainty_ns}

  set input_delay_per  0.0200
  set output_delay_per 0.0200

  set core_input_delay_ns  [expr ${core_clk_period_ns}*(${input_delay_per}/100.0)]
  set core_output_delay_ns [expr ${core_clk_period_ns}*(${output_delay_per}/100.0)]

  set coh_input_delay_ns  [expr ${coh_clk_period_ns}*(${input_delay_per}/100.0)]
  set coh_output_delay_ns [expr ${coh_clk_period_ns}*(${output_delay_per}/100.0)]

  set mem_input_delay_ns  [expr ${mem_clk_period_ns}*(${input_delay_per}/100.0)]
  set mem_output_delay_ns [expr ${mem_clk_period_ns}*(${output_delay_per}/100.0)]

  set driving_lib_cell "INV_X2"
  set load_lib_pin     "INV_X8/A"

  # Reg2Reg
  #create_clock -period ${core_clk_period_ns} -name ${core_clk_name} [get_ports core_clk_i]
  #create_clock -period ${coh_clk_period_ns} -name ${coh_clk_name} [get_ports coh_clk_i]
  create_clock -period ${core_clk_period_ns} -name ${core_clk_name} [get_ports "core_clk_i coh_clk_i"]
  create_clock -period ${mem_clk_period_ns} -name ${mem_clk_name} [get_ports mem_clk_i]
  set_clock_uncertainty ${core_clk_uncertainty_ns} [get_clocks ${core_clk_name}]
  #set_clock_uncertainty ${coh_clk_uncertainty_ns} [get_clocks ${coh_clk_name}]
  set_clock_uncertainty ${mem_clk_uncertainty_ns} [get_clocks ${mem_clk_name}]

  # In2Reg
  set coh_input_pins [filter_collection [all_inputs] "name=~coh*"]
  set mem_input_pins [filter_collection [all_inputs] "name=~mem*"]
  set core_input_pins [remove_from_collection [all_inputs] [concat $coh_input_pins $mem_input_pins]]

  set coh_input_pins [filter_collection $coh_input_pins "name!~*clk*"]
  set mem_input_pins [filter_collection $mem_input_pins "name!~*clk*"]
  set core_input_pins [filter_collection $core_input_pins "name!~*clk*"]

  set_driving_cell -no_design_rule -lib_cell ${driving_lib_cell} [remove_from_collection [all_inputs] [get_ports *clk*]]
  if { [sizeof $core_input_pins] > 0 } { set_input_delay ${core_input_delay_ns} -clock ${core_clk_name} ${core_input_pins} }
  #if { [sizeof $coh_input_pins] > 0 }  { set_input_delay ${coh_input_delay_ns} -clock ${coh_clk_name} ${coh_input_pins} }
  if { [sizeof $coh_input_pins] > 0 }  { set_input_delay ${core_input_delay_ns} -clock ${core_clk_name} ${coh_input_pins} }
  if { [sizeof $mem_input_pins] > 0 }  { set_input_delay ${mem_input_delay_ns} -clock ${mem_clk_name} ${mem_input_pins} }

  # Reg2Out
  set coh_output_pins [filter_collection [all_outputs] "name=~coh*"]
  set mem_output_pins [filter_collection [all_outputs] "name=~mem*"]
  set core_output_pins [remove_from_collection [all_outputs] [concat ${coh_output_pins} ${mem_output_pins}]]

  set_load [load_of [get_lib_pin */${load_lib_pin}]] [all_outputs]
  if { [sizeof $core_output_pins] > 0 } { set_output_delay ${core_output_delay_ns} -clock ${core_clk_name} ${core_output_pins} }
  #if { [sizeof $coh_output_pins] > 0 }  { set_output_delay ${coh_output_delay_ns} -clock ${coh_clk_name} ${coh_output_pins} }
  if { [sizeof $coh_output_pins] > 0 } { set_output_delay ${core_output_delay_ns} -clock ${core_clk_name} ${coh_output_pins} }
  if { [sizeof $mem_output_pins] > 0 }  { set_output_delay ${mem_output_delay_ns} -clock ${mem_clk_name} ${mem_output_pins} }

  # This timing assertion for the RF is only valid in designs that do not do simultaneous read and write, or do not use the read value when it writes
  # Check your ram generator to see what it permits
  foreach_in_collection cell [filter_collection [all_macro_cells] "full_name=~*int_regfile*rf*"] {
    set_disable_timing $cell -from CLKA -to CLKB
    set_disable_timing $cell -from CLKB -to CLKA
  }

  set_false_path -from [get_ports *cord*]

  # Derate
  set cells_to_derate [list]
  append_to_collection cells_to_derate [get_cells -quiet -hier -filter "ref_name=~free45_*"]
  append_to_collection cells_to_derate [get_cells -quiet -hier -filter "ref_name=~IN12LP_*"]
  if { [sizeof $cells_to_derate] > 0 } {
    foreach_in_collection cell $cells_to_derate {
      set_timing_derate -cell_delay -early 0.97 $cell
      set_timing_derate -cell_delay -late  1.03 $cell
      set_timing_derate -cell_check -early 0.97 $cell
      set_timing_derate -cell_check -late  1.03 $cell
    }
  }
  #report_timing_derate

  # CDC Paths
  #=================
  update_timing
  set clocks [all_clocks]
  foreach_in_collection launch_clk $clocks {
    if { [get_attribute $launch_clk is_generated] } {
      set launch_group [get_generated_clocks -filter "master_clock_name==[get_attribute $launch_clk master_clock_name]"]
      append_to_collection launch_group [get_attribute $launch_clk master_clock]
    } else {
      set launch_group [get_generated_clocks -filter "master_clock_name==[get_attribute $launch_clk name]"]
      append_to_collection launch_group $launch_clk
    }
    foreach_in_collection latch_clk [remove_from_collection $clocks $launch_group] {
      set launch_period [get_attribute $launch_clk period]
      set latch_period [get_attribute $latch_clk period]
      set max_delay_ns [expr min($launch_period,$latch_period)/2]
      set_max_delay $max_delay_ns -from $launch_clk -to $latch_clk -ignore_clock_latency
      set_min_delay 0             -from $launch_clk -to $latch_clk -ignore_clock_latency
    }
  }



########################################
##
## Top-level Constraints
##

} elseif { ${DESIGN_NAME} == "bsg_chip" } {

  set_app_var timing_enable_multiple_clocks_per_reg true

  #set_register_merging [get_cells -of [get_nets bp_complex/vc_reset_r]]   false
  #set_register_merging [get_cells -of [get_nets bp_complex/mc/reset_i_r]] false

  bsg_tag_clock_create ${tag_clk_name} bsg_tag_clk_i/Y bsg_tag_data_i/Y bsg_tag_en_i/Y ${tag_clk_period_ns} ${tag_clk_uncertainty_ns}

  bsg_clk_gen_clock_create clk_gen_pd/clk_gen[0].clk_gen_inst/ ${bp_clk_name}        ${oscillator_period_ns} ${bp_clk_period_ns}        ${oscillator_uncertainty_ns} ${ds_uncertainty_ns} ${bp_clk_uncertainty_ns}
  bsg_clk_gen_clock_create clk_gen_pd/clk_gen[1].clk_gen_inst/ ${io_master_clk_name} ${oscillator_period_ns} ${io_master_clk_period_ns} ${oscillator_uncertainty_ns} ${ds_uncertainty_ns} ${io_master_clk_uncertainty_ns}
  bsg_clk_gen_clock_create clk_gen_pd/clk_gen[2].clk_gen_inst/ ${router_clk_name}    ${oscillator_period_ns} ${router_clk_period_ns}    ${oscillator_uncertainty_ns} ${ds_uncertainty_ns} ${router_clk_uncertainty_ns}

  create_clock -period ${oscillator_period_ns} -name bp_clk_ext [get_ports p_clk_A_i]
  set_clock_uncertainty $oscillator_uncertainty_ns [get_clocks bp_clk_ext]

  create_clock -period ${oscillator_period_ns} -name io_master_clk_ext [get_ports p_clk_B_i]
  set_clock_uncertainty $oscillator_uncertainty_ns [get_clocks io_master_clk_ext]

  create_clock -period ${oscillator_period_ns} -name router_clk_ext [get_ports p_clk_C_i]
  set_clock_uncertainty $oscillator_uncertainty_ns [get_clocks router_clk_ext]

  # Comm Link CH0
  #=================
  set ch0_in_clk_port                          [get_pins -of_objects [get_cells -of_objects [get_ports p_ci_clk_i]] -filter "name==Y"]
  set ch0_in_dv_port   [remove_from_collection [get_pins -of_objects [get_cells -of_objects [get_ports p_ci_*_i]] -filter "name==Y"] $ch0_in_clk_port]
  set ch0_in_tkn_port                          [get_pins -of_objects [get_cells -of_objects [get_ports p_ci_tkn_o]] -filter "name==DATA"]
  set ch0_out_clk_port                         [get_pins -of_objects [get_cells -of_objects [get_ports p_ci2_clk_o]] -filter "name==DATA"]
  set ch0_out_dv_port  [remove_from_collection [get_pins -of_objects [get_cells -of_objects [get_ports p_ci2_*_o]] -filter "name==DATA"] $ch0_out_clk_port]
  set ch0_out_tkn_port                         [get_pins -of_objects [get_cells -of_objects [get_ports p_ci2_tkn_i]] -filter "name==Y"]
  
  bsg_comm_link_timing_constraints \
    ${io_master_clk_name}          \
    "a"                            \
    $ch0_in_clk_port               \
    $ch0_in_dv_port                \
    $ch0_in_tkn_port               \
    $ch0_out_clk_port              \
    $ch0_out_dv_port               \
    $ch0_out_tkn_port              \
    100                            \
    100                            \
    $io_clk_uncertainty_ns

  # Comm Link CH1
  #=================
  set ch1_in_clk_port                          [get_pins -of_objects [get_cells -of_objects [get_ports p_co_clk_i]] -filter "name==Y"]
  set ch1_in_dv_port   [remove_from_collection [get_pins -of_objects [get_cells -of_objects [get_ports p_co_*_i]] -filter "name==Y"] $ch1_in_clk_port]
  set ch1_in_tkn_port                          [get_pins -of_objects [get_cells -of_objects [get_ports p_co_tkn_o]] -filter "name==DATA"]
  set ch1_out_clk_port                         [get_pins -of_objects [get_cells -of_objects [get_ports p_co2_clk_o]] -filter "name==DATA"]
  set ch1_out_dv_port  [remove_from_collection [get_pins -of_objects [get_cells -of_objects [get_ports p_co2_*_o]] -filter "name==DATA"] $ch1_out_clk_port]
  set ch1_out_tkn_port                         [get_pins -of_objects [get_cells -of_objects [get_ports p_co2_tkn_i]] -filter "name==Y"]
  
  bsg_comm_link_timing_constraints \
    ${io_master_clk_name}          \
    "b"                            \
    $ch1_in_clk_port               \
    $ch1_in_dv_port                \
    $ch1_in_tkn_port               \
    $ch1_out_clk_port              \
    $ch1_out_dv_port               \
    $ch1_out_tkn_port              \
    100                            \
    100                           \
    $io_clk_uncertainty_ns

  # CDC Paths
  #=================
  update_timing
  set clocks [all_clocks]
  foreach_in_collection launch_clk $clocks {
    if { [get_attribute $launch_clk is_generated] } {
      set launch_group [get_generated_clocks -filter "master_clock_name==[get_attribute $launch_clk master_clock_name]"]
      append_to_collection launch_group [get_attribute $launch_clk master_clock]
    } else {
      set launch_group [get_generated_clocks -filter "master_clock_name==[get_attribute $launch_clk name]"]
      append_to_collection launch_group $launch_clk
    }
    foreach_in_collection latch_clk [remove_from_collection $clocks $launch_group] {
      set launch_period [get_attribute $launch_clk period]
      set latch_period [get_attribute $latch_clk period]
      set max_delay_ns [expr min($launch_period,$latch_period)/2]
      set_max_delay $max_delay_ns -from $launch_clk -to $latch_clk -ignore_clock_latency
      set_min_delay 0             -from $launch_clk -to $latch_clk -ignore_clock_latency
    }
  }

  # Ungrouping
  #=================
  set_ungroup [get_cells swizzle]

  set cells_to_derate [list]
  append_to_collection cells_to_derate [get_cells -quiet -hier -filter "ref_name=~gf14_*"]
  #append_to_collection cells_to_derate [get_cells -quiet -hier -filter "ref_name=~IN12LP_*"]
  if { [sizeof $cells_to_derate] > 0 } {
    foreach_in_collection cell $cells_to_derate {
      set_timing_derate -cell_delay -early 0.97 $cell
      set_timing_derate -cell_delay -late  1.03 $cell
      set_timing_derate -cell_check -early 0.97 $cell
      set_timing_derate -cell_check -late  1.03 $cell
    }
  }
  #report_timing_derate

  set_dont_touch [get_nets pwrok_lo*]
  set_dont_touch [get_nets iopwrok_lo*]
  set_dont_touch [get_nets retc_lo*]

########################################
##
## Unknown design...
##
} else {

  puts "BSG-error: No constraints found for design (${DESIGN_NAME})!"

}

