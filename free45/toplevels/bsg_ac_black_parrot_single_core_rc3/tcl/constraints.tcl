source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_tag.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_chip_cdc.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_comm_link.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_clk_gen.constraints.tcl

########################################
##
## Clock Setup
##

set bp_clk_name        "bp_clk"         ;# main clock running block parrot

set bp_clk_period_ps       1000
set bp_clk_uncertainty_per 3.0
#set bp_clk_uncertainty_ns  [expr min([expr ${bp_clk_period_ns}*(${bp_clk_uncertainty_per}/100.0)], 50)]
set bp_clk_uncertainty_ps 20

set core_clk_name           ${bp_clk_name}
set core_clk_period_ps      ${bp_clk_period_ps}
set core_clk_uncertainty_ps ${bp_clk_uncertainty_ps}

set input_delay_per  5.0
set output_delay_per 5.0

set core_input_delay_ps  [expr ${core_clk_period_ps}*(${input_delay_per}/100.0)]
set core_output_delay_ps [expr ${core_clk_period_ps}*(${output_delay_per}/100.0)]

set driving_lib_cell "INV_X2"
set load_lib_pin     "INV_X8/A"

# Reg2Reg
create_clock -period ${core_clk_period_ps} -name ${core_clk_name} [get_ports "clk_i"]
set_clock_uncertainty ${core_clk_uncertainty_ps} [get_clocks ${core_clk_name}]

# In2Reg
set core_input_pins [filter_collection [all_inputs] "name!~*clk*"]
set_driving_cell -no_design_rule -lib_cell ${driving_lib_cell} [remove_from_collection [all_inputs] [get_ports *clk*]]
set_input_delay ${core_input_delay_ps} -clock ${core_clk_name} ${core_input_pins}

# Reg2Out
set core_output_pins [all_outputs]
set_load [load_of [get_lib_pin */${load_lib_pin}]] ${core_output_pins}
set_output_delay ${core_output_delay_ps} -clock ${core_clk_name} ${core_output_pins}

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

# Ungrouping
#=================
# set_ungroup [get_cells swizzle]

set_app_var compile_keep_original_for_external_references true

# current_design *pipe_mem*
# create_clock -period ${core_clk_period_ps} [get_ports "clk_i"]
# set_optimize_registers true -check_design
# uniquify -force
# ungroup -flatten [get_cells -hier]

current_design bsg_chip
