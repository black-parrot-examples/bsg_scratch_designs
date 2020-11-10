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

if { ${DESIGN_NAME} == "bp_tile_node" || ${DESIGN_NAME} == "bp_multicore"} {

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
## Unknown design...
##
} else {

  puts "BSG-error: No constraints found for design (${DESIGN_NAME})!"

}

