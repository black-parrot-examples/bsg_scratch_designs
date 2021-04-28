puts "BSG-info: Running script [info script]\n"

########################################
## Source common scripts
source -echo -verbose $::env(BSG_DESIGNS_TARGET_DIR)/../common/bsg_chip_cdc.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_TARGET_DIR)/../common/bsg_chip_misc.tcl

# TODO: Put names in common
set bp_clk_name "bp_clk" ;# main clock running black parrot
set bp_clk_period_ps [get_attribute [get_clocks ${bp_clk_name}] period]
set bp_clk_uncertainty_ps 5

remove_clocks -all

# Loosen constraint
set loosen_factor 1.10
create_clock -period [expr ${loosen_factor}*${bp_clk_period_ps}] -name ${bp_clk_name} [get_ports "clk_i"]
set_clock_uncertainty ${bp_clk_uncertainty_ps} [get_clocks ${bp_clk_name}]

puts "BSG-info: Completed script [info script]\n"
