`ifndef BSG_CHIP_PKG_V
`define BSG_CHIP_PKG_V

package bsg_chip_pkg;

  `include "bsg_defines.v"

  import bp_common_aviary_pkg::*;

  //////////////////////////////////////////////////
  //
  // BSG BLACKPARROT PARAMETERS
  //
  
  localparam bp_params_e bp_cfg_gp = e_bp_single_core_cfg;

endpackage // bsg_chip_pkg

`endif // BSG_CHIP_PKG_V

