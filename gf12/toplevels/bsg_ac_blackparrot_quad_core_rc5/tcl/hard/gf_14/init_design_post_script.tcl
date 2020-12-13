if { $DESIGN_NAME == "bsg_chip" } {
proc bsg_dont_touch_regexp {arg1} {
    set pattern "full_name=~$arg1";
    set mycells [get_cells -hier -filter $pattern]
    puts [concat "BSG: set dont_touch'ing " $pattern "=" [collection_to_list $mycells]]
    set_dont_touch $mycells
}

proc bsg_dont_touch_regexp_type {arg1} {
    set pattern "ref_name=~$arg1";
    set mycells [get_cells -hier -filter $pattern]
    puts [concat "BSG: set dont_touch'ing " $pattern "=" [collection_to_list $mycells]]
    set_dont_touch $mycells
}

bsg_dont_touch_regexp */adt/*
bsg_dont_touch_regexp */cdt/*
bsg_dont_touch_regexp */fdt/*
bsg_dont_touch_regexp *BSG_BAL41MUX*
bsg_dont_touch_regexp_type *SYNC*SDFF*
} elseif { $DESIGN_NAME == "bp_tile_node" } {
  # TODO: These constraints are only needed because they get dropped by the hierarchical SDC reading the top-level only
  # This timing assertion for the RF is only valid in designs that do not do simultaneous read and write to the same address,
  # or do not use the read value when it writes
  # Check your ram generator to see what it permits
  foreach_in_collection cell [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*regfile*rf*"] {
    set_disable_timing $cell -from CLKA -to CLKB
    set_disable_timing $cell -from CLKB -to CLKA
  }

  foreach_in_collection cell [get_cells -hier -filter "ref_name=~gf14_* && full_name=~*btb*tag_mem*"] {
    set_disable_timing $cell -from CLKA -to CLKB
    set_disable_timing $cell -from CLKB -to CLKA
  }
}
