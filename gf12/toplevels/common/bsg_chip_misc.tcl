puts "Info: Start script [info script]\n"

proc bsg_chip_derate_cells {} {
  set cells_to_derate [get_cells -quiet -hier -filter "ref_name=~IN12LP_*"]
  if { [sizeof $cells_to_derate] > 0 } {
    foreach_in_collection cell $cells_to_derate {
      set_timing_derate -cell_delay -early 0.97 $cell
      set_timing_derate -cell_delay -late  1.03 $cell
      set_timing_derate -cell_check -early 0.97 $cell
      set_timing_derate -cell_check -late  1.03 $cell
    }
  }
}

proc bsg_chip_derate_mems {} {
  set cells_to_derate [get_cells -quiet -hier -filter "ref_name=~gf14_*"]
  if { [sizeof $cells_to_derate] > 0 } {
    foreach_in_collection cell $cells_to_derate {
      set_timing_derate -cell_delay -early 0.97 $cell
      set_timing_derate -cell_delay -late  1.03 $cell
      set_timing_derate -cell_check -early 0.97 $cell
      set_timing_derate -cell_check -late  1.03 $cell
    }
  }
}

# This timing assertion for is only valid in designs that do not do simultaneous
#   read and write to the same address, or do not use the read value when it writes.
# Check your ram generator to see what it permits
proc bsg_chip_disable_1r1w_paths {macro_name} {
  foreach_in_collection cell [filter_collection [all_macro_cells] "full_name=~${macro_name}"] {
    set_disable_timing $cell -from CLKA -to CLKB
    set_disable_timing $cell -from CLKB -to CLKA
  }
}

puts "Info: Completed script [info script]\n"
