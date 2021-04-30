puts "BSG-info: Running script [info script]\n"
set HB_LINK_WIDTH_P       154
set HB_RUCHE_LINK_WIDTH_P 140
#set_app_var sh_continue_on_error false
#error
# core clk
set clk_name            "manycore_clk"
set clk_period_ns       3.75
set clk_uncertainty_ns  0
create_clock -period ${clk_period_ns} -name ${clk_name} [get_ports clk_i]
set_clock_uncertainty ${clk_uncertainty_ns} [get_clocks ${clk_name}]
# Grouping ports...
set reset_in_port  [get_ports reset_i]
set reset_out_port [get_ports reset_o]
set ruche_input_ports         [list]
set ruche_output_ports        [list]
set local_input_ports         [list]
set local_output_ports        [list]
for {set i 1} {$i < 5} {incr i} {
  for {set j 0} {$j < $HB_LINK_WIDTH_P} {incr j} {
    append_to_collection local_input_ports [get_ports "link_i[$i][$j]"]
    append_to_collection local_output_ports [get_ports "link_o[$i][$j]"]
  }
}
for {set i 0} {$i < 3} {incr i} {
  for {set j 1} {$j < 3} {incr j} {
    for {set k 0} {$k < $HB_RUCHE_LINK_WIDTH_P} {incr k} {
      append_to_collection ruche_input_ports [get_ports "ruche_link_i[$i][$j][$k]"]
      append_to_collection ruche_output_ports [get_ports "ruche_link_o[$i][$j][$k]"]
    }
  }
}
# W = 0
# E = 1
# N = 2
# S = 3
# RW = 4
# RE = 5
for {set i 0} {$i < 4} {incr i} {
  set rev_data_out_ports($i)       [index_collection $local_output_ports [expr 0+($HB_LINK_WIDTH_P*$i)] [expr 52+($HB_LINK_WIDTH_P*$i)]]
  set rev_ready_out_ports($i)      [index_collection $local_output_ports [expr 53+($HB_LINK_WIDTH_P*$i)]]
  set rev_valid_out_ports($i)      [index_collection $local_output_ports [expr 54+($HB_LINK_WIDTH_P*$i)]]
  set fwd_data_out_ports($i)       [index_collection $local_output_ports [expr 55+($HB_LINK_WIDTH_P*$i)] [expr 151+($HB_LINK_WIDTH_P*$i)]]
  set fwd_ready_out_ports($i)      [index_collection $local_output_ports [expr 152+($HB_LINK_WIDTH_P*$i)]]
  set fwd_valid_out_ports($i)      [index_collection $local_output_ports [expr 153+($HB_LINK_WIDTH_P*$i)]]
  set rev_data_in_ports($i)       [index_collection $local_input_ports [expr 0+($HB_LINK_WIDTH_P*$i)] [expr 52+($HB_LINK_WIDTH_P*$i)]]
  set rev_ready_in_ports($i)      [index_collection $local_input_ports [expr 53+($HB_LINK_WIDTH_P*$i)]]
  set rev_valid_in_ports($i)      [index_collection $local_input_ports [expr 54+($HB_LINK_WIDTH_P*$i)]]
  set fwd_data_in_ports($i)       [index_collection $local_input_ports [expr 55+($HB_LINK_WIDTH_P*$i)] [expr 151+($HB_LINK_WIDTH_P*$i)]]
  set fwd_ready_in_ports($i)      [index_collection $local_input_ports [expr 152+($HB_LINK_WIDTH_P*$i)]]
  set fwd_valid_in_ports($i)      [index_collection $local_input_ports [expr 153+($HB_LINK_WIDTH_P*$i)]]
}
for {set i 0} {$i < 2} {incr i} {
  set dir [expr $i+4]
  set rev_data_out_ports($dir)        [index_collection $ruche_output_ports [expr 0+($HB_RUCHE_LINK_WIDTH_P*$i)] [expr 45+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set rev_ready_out_ports($dir)       [index_collection $ruche_output_ports [expr 46+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set rev_valid_out_ports($dir)       [index_collection $ruche_output_ports [expr 47+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set fwd_data_out_ports($dir)        [index_collection $ruche_output_ports [expr 48+($HB_RUCHE_LINK_WIDTH_P*$i)] [expr 137+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set fwd_ready_out_ports($dir)       [index_collection $ruche_output_ports [expr 138+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set fwd_valid_out_ports($dir)       [index_collection $ruche_output_ports [expr 139+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set rev_data_in_ports($dir)        [index_collection $ruche_input_ports [expr 0+($HB_RUCHE_LINK_WIDTH_P*$i)] [expr 45+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set rev_ready_in_ports($dir)       [index_collection $ruche_input_ports [expr 46+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set rev_valid_in_ports($dir)       [index_collection $ruche_input_ports [expr 47+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set fwd_data_in_ports($dir)        [index_collection $ruche_input_ports [expr 48+($HB_RUCHE_LINK_WIDTH_P*$i)] [expr 137+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set fwd_ready_in_ports($dir)       [index_collection $ruche_input_ports [expr 138+($HB_RUCHE_LINK_WIDTH_P*$i)]]
  set fwd_valid_in_ports($dir)       [index_collection $ruche_input_ports [expr 139+($HB_RUCHE_LINK_WIDTH_P*$i)]]
}
proc constraint_input_ports {clk_name ports max_delay min_delay} {
  set_input_delay -max $max_delay -clock $clk_name $ports
  set_input_delay -min $min_delay -clock $clk_name $ports
  set_driving_cell -min -no_design_rule -lib_cell "INV_X8" $ports
  set_driving_cell -max -no_design_rule -lib_cell "INV_X2" $ports
}
proc constraint_output_ports {clk_name ports max_delay min_delay} {
  set_output_delay -max $max_delay -clock $clk_name $ports
  set_output_delay -min $min_delay -clock $clk_name $ports
  set_load -max [load_of [get_lib_pin "*/INV_X8/A"]] $ports
  set_load -min [load_of [get_lib_pin "*/INV_X2/A"]] $ports
}
# FIFO input constraints
for {set i 0} {$i < 6} {incr i} {
  constraint_input_ports $clk_name $rev_data_in_ports($i)    3.50625 0
  constraint_input_ports $clk_name $rev_valid_in_ports($i)   3.18750 0
  constraint_output_ports $clk_name $rev_ready_out_ports($i) 3.41250 0
  constraint_input_ports $clk_name $fwd_data_in_ports($i)    3.50625 0
  constraint_input_ports $clk_name $fwd_valid_in_ports($i)   3.16875 0
  constraint_output_ports $clk_name $fwd_ready_out_ports($i) 3.33750 0
}
# FIFO output constraints
# W/E
for {set i 0} {$i < 2} {incr i} {
  constraint_output_ports $clk_name $rev_data_out_ports($i)   2.28750 0
  constraint_output_ports $clk_name $rev_valid_out_ports($i)  2.45625 0
  constraint_input_ports  $clk_name $rev_ready_in_ports($i)   3.31875 0
  constraint_output_ports $clk_name $fwd_data_out_ports($i)   2.13750 0
  constraint_output_ports $clk_name $fwd_valid_out_ports($i)  2.56875 0
  constraint_input_ports  $clk_name $fwd_ready_in_ports($i)   3.18750 0
}
# N/S
for {set i 2} {$i < 4} {incr i} {
  constraint_output_ports $clk_name $rev_data_out_ports($i)  2.49375 0
  constraint_output_ports $clk_name $rev_valid_out_ports($i) 2.77500 0
  constraint_input_ports  $clk_name $rev_ready_in_ports($i)  3.33750 0
  constraint_output_ports $clk_name $fwd_data_out_ports($i)  2.13750 0
  constraint_output_ports $clk_name $fwd_valid_out_ports($i) 2.66250 0
  constraint_input_ports  $clk_name $fwd_ready_in_ports($i)  3.22500 0
}
# RW/RE
for {set i 4} {$i < 6} {incr i} {
  constraint_output_ports $clk_name $rev_data_out_ports($i)  2.26875 0
  constraint_output_ports $clk_name $rev_valid_out_ports($i) 2.47500 0
  constraint_input_ports  $clk_name $rev_ready_in_ports($i)  3.20625 0
  constraint_output_ports $clk_name $fwd_data_out_ports($i)  2.26875 0
  constraint_output_ports $clk_name $fwd_valid_out_ports($i) 2.62500 0
  constraint_input_ports  $clk_name $fwd_ready_in_ports($i)  3.22500 0
}
# feedthrough input pins
set feedthrough_input_pins [index_collection $ruche_input_ports [expr 2*$HB_RUCHE_LINK_WIDTH_P] [expr (6*$HB_RUCHE_LINK_WIDTH_P)-1]]
set_input_delay -min 0.07 ${feedthrough_input_pins} -clock ${clk_name}
set_input_delay -max 0.07 ${feedthrough_input_pins} -clock ${clk_name}
set_driving_cell -min -no_design_rule -lib_cell "INV_X8" $feedthrough_input_pins
set_driving_cell -max -no_design_rule -lib_cell "INV_X8" $feedthrough_input_pins
set_dont_touch [get_nets -of_objects $feedthrough_input_pins] true
# feedthrough output pins
set feedthrough_output_pins [index_collection $ruche_output_ports [expr 2*$HB_RUCHE_LINK_WIDTH_P] [expr (6*$HB_RUCHE_LINK_WIDTH_P)-1]]
set_output_delay -min 0.07 ${feedthrough_output_pins} -clock ${clk_name}
set_output_delay -max 0.07 ${feedthrough_output_pins} -clock ${clk_name}
set_load -max [load_of [get_lib_pin "*/INV_X8/A"]] $feedthrough_output_pins
set_load -min [load_of [get_lib_pin "*/INV_X8/A"]] $feedthrough_output_pins
# reset ports
constraint_input_ports $clk_name $reset_in_port 1.875 0.15
constraint_output_ports $clk_name $reset_out_port 1.875 0.15
# cord in
set cord_in_ports [list]
append_to_collection cord_in_ports [get_ports global_*_i*]
constraint_input_ports $clk_name $cord_in_ports 1.875 0.15
# cord out
set cord_out_ports [list]
append_to_collection cord_out_ports [get_ports global_*_o*]
constraint_output_ports $clk_name $cord_out_ports 1.875 0.15
# Ungroup
set_ungroup [get_designs -filter "hdl_template==bsg_mux"] true
set_ungroup [get_designs -filter "hdl_template==bsg_manycore_reg_id_decode"] true
set_ungroup [get_designs -filter "hdl_template==bsg_manycore_endpoint"] true
set_ungroup [get_designs -filter "hdl_template==network_tx"] true
set_ungroup [get_designs -filter "hdl_template==network_rx"] true
set_ungroup [get_designs -filter "hdl_template==bsg_scan"] true
set_ungroup [get_designs -filter "hdl_template==reverse"] true
set_ungroup [get_designs -filter "hdl_template==recFNToRawFN"] true
set_ungroup [get_designs -filter "hdl_template==bsg_manycore_dram_hash_function"] true
set_ungroup [get_designs -filter "hdl_template==bsg_manycore_eva_to_npa"] true
set_ungroup [get_designs -filter "hdl_template==bsg_transpose"] true
set_ungroup [get_designs -filter "hdl_template==bsg_concentrate_static"] true
set_ungroup [get_designs -filter "hdl_template==bsg_array_concentrate_static"] true
set_ungroup [get_designs -filter "hdl_template==bsg_unconcentrate_static"] true
set_ungroup [get_designs fpu_float_fma] false
set_ungroup [get_designs fpu_float_fma_round] false
ungroup [get_cells proc/*] -flatten
ungroup [get_cells proc/h.z/vcore/fpu_int0/*] -flatten
ungroup [get_cells proc/h.z/vcore/fpu_float0/fma1/*] -flatten
ungroup [get_cells proc/h.z/vcore/fpu_float0/fma2/*] -flatten
ungroup [get_cells proc/h.z/vcore/fpu_float0/aux0/*] -flatten
ungroup [get_cells proc/h.z/vcore/fpu_fdiv_fsqrt0/*] -flatten
ungroup [get_cells proc/h.z/vcore/idiv0/*] -flatten
# Retiming
set_optimize_registers true -designs [get_designs fpu_float_fma] -check_design -verbose
set_optimize_registers true -designs [get_designs fpu_float_fma_round] -check_design -verbose
puts "BSG-info: Completed script [info script]\n"
