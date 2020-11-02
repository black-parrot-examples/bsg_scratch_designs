# bsg_write_file
proc bsg_write_file {floc flist} {
  set f $floc
  set fid [open $f "w"]
  foreach item $flist {
    puts $fid $item
  }
  close $fid
}

# bsg_get_length
proc bsg_get_length {flist} {
  if {[info exists flist]} {
    return [llength $flist]
  }
}

# bsg_create_filelist
proc bsg_create_filelist {filelist source_files} {
  bsg_write_file $filelist $source_files
}

# bsg_create_library, include_paths arg is optional
proc bsg_create_library {library_name library_file source_files {include_paths ""}} {

  # header
  lappend library_list "library $library_name"

  # source files
  set len [bsg_get_length $source_files]
  set i 0
  foreach f $source_files {
    if {$i == [expr $len - 1]} {
      lappend library_list "$f"
    } else {
      lappend library_list "$f,"
    }
    incr i
  }

  # include paths
  set len [bsg_get_length $include_paths]
  if {$len > 0} {
    lappend library_list "-incdir"
  }
  set i 0
  foreach f $include_paths {
    if {$i == [expr $len - 1]} {
      lappend library_list "$f"
    } else {
      lappend library_list "$f,"
    }
    incr i
  }

  # footer
  lappend library_list ";"

  # write library
  bsg_write_file $library_file $library_list

}

# scripts for creating filelist and library
#source $::env(BSG_TESTING_COMMON_DIR)/bsg_vcs_create_filelist_library.tcl

source $::env(BSG_CHIP_DIR)/cad/setup/common_setup.tcl

# chip source (rtl) files and include paths list
source $::env(BSG_DESIGNS_TARGET_DIR)/tcl/filelist.tcl
source $::env(BSG_DESIGNS_TARGET_DIR)/tcl/include.tcl

# testing source (rtl) files and include paths list
source $::env(BSG_DESIGNS_TARGET_DIR)/testing/tcl/filelist.tcl
source $::env(BSG_DESIGNS_TARGET_DIR)/testing/tcl/include.tcl

# TODO: Hack the flow to get the correct standard cell models
set VERILOG_FILES(iv7p5_rvt_c14)  /gro/cad/pdk/gf_14/bsg/verilog/IN14LPP_SC7P5T_84CPP_BASE_SSC14R.v

# netlist source files
set NETLIST_SOURCE_FILES [glob $::env(BSG_CHIP_DIR)/current_build/pnr/*/results/*chip_finish.pt.v.gz]
foreach lib [array name VERILOG_FILES] {
  if { $VERILOG_FILES($lib) != "" } {
    set NETLIST_SOURCE_FILES [concat $NETLIST_SOURCE_FILES [join $VERILOG_FILES($lib)]]
  }
}

# testing filelist
bsg_create_filelist $::env(BSG_DESIGNS_TESTING_FILELIST) \
                    $TESTING_SOURCE_FILES

# testing library
bsg_create_library $::env(BSG_DESIGNS_TESTING_LIBRARY_NAME) \
                   $::env(BSG_DESIGNS_TESTING_LIBRARY)      \
                   [concat $SVERILOG_SOURCE_FILES $TESTING_SOURCE_FILES] \
                   [concat $SVERILOG_INCLUDE_PATHS $TESTING_INCLUDE_PATHS]

# netlist filelist
bsg_create_filelist $::env(NETLIST_FILELIST) \
                    $NETLIST_SOURCE_FILES

# netlist library
bsg_create_library $::env(NETLIST_LIBRARY_NAME) \
                   $::env(NETLIST_LIBRARY)      \
                   $NETLIST_SOURCE_FILES        \
                   [list]

