
module bsg_guts #(parameter num_channels_p=4
                  ,parameter channel_width_p=8
                  ,parameter enabled_at_start_vec_p=0
                  ,parameter master_p=0
                  ,parameter master_to_client_speedup_p=100
                  ,parameter master_bypass_test_p=5'b00000
                  ,parameter nodes_p=1
                  ,parameter uniqueness_p=0
                  )
   (
    input core_clk_i
    , input async_reset_i
    , input io_master_clk_i

    // input from i/o
    , input  [num_channels_p-1:0] io_clk_tline_i       // clk
    , input  [num_channels_p-1:0] io_valid_tline_i
    , input  [channel_width_p-1:0] io_data_tline_i [num_channels_p-1:0]
    , output [num_channels_p-1:0] io_token_clk_tline_o // clk

    // out to i/o
    , output [num_channels_p-1:0] im_clk_tline_o       // clk
    , output [num_channels_p-1:0] im_valid_tline_o
    , output [channel_width_p-1:0] im_data_tline_o [num_channels_p-1:0]
    , input  [num_channels_p-1:0] token_clk_tline_i    // clk

    // note: generate by the master (FPGA) and sent to the slave (ASIC)
    // not used by slave (ASIC).
    , output reg                   im_slave_reset_tline_r_o

    // this signal is the post-calibration reset signal
    // synchronous to the core clock
    , output                       core_reset_o
    );

   localparam ring_bytes_lp = 10;
   localparam ring_width_lp = ring_bytes_lp*channel_width_p;

   // into nodes (fsb interface)
   wire [nodes_p-1:0]       core_node_v_A;
   wire [ring_width_lp-1:0] core_node_data_A [nodes_p-1:0];
   wire [nodes_p-1:0]       core_node_ready_A;

    // into nodes (control)
   wire [nodes_p-1:0] core_node_en_r_lo;
   wire [nodes_p-1:0] core_node_reset_r_lo;

    // out of nodes (fsb interface)
   wire [nodes_p-1:0]       core_node_v_B;
   wire [ring_width_lp-1:0] core_node_data_B [nodes_p-1:0];
   wire [nodes_p-1:0]       core_node_yumi_B;


   // instantiate murn nodes here

   genvar                           i;

   for (i = 0; i < nodes_p; i=i+1)
     begin : n
        if (master_p)
          begin: mstr
             bsg_test_node_master
               #(.ring_width_p(ring_width_lp)
                 ,.master_id_p(i)
                 ,.client_id_p(i)
                 ) mstr
                 (.clk_i   (core_clk_i                )
                  ,.reset_i(core_node_reset_r_lo [i])

                  ,.v_i    (core_node_v_A      [i])
                  ,.data_i (core_node_data_A   [i])
                  ,.ready_o(core_node_ready_A  [i])

                  ,.v_o    (core_node_v_B      [i])
                  ,.data_o (core_node_data_B   [i])
                  ,.yumi_i (core_node_yumi_B   [i])

                  ,.en_i   (core_node_en_r_lo  [i])
                  );
          end
        else
          begin: clnt
             bsg_test_node_client
               #(.ring_width_p(ring_width_lp)
                 ,.master_id_p(i)
                 ,.client_id_p(i)
                 ) clnt
                 (.clk_i   (core_clk_i                )
                  ,.reset_i(core_node_reset_r_lo [i])

                  ,.v_i    (core_node_v_A      [i])
                  ,.data_i (core_node_data_A   [i])
                  ,.ready_o(core_node_ready_A  [i])

                  ,.v_o    (core_node_v_B      [i])
                  ,.data_o (core_node_data_B   [i])
                  ,.yumi_i (core_node_yumi_B   [i])

                  ,.en_i   (core_node_en_r_lo  [i])
                  );
          end
     end

   // should not need to modify

   // fsb reset
   wire core_calib_done_r_lo;

   // fsb in
   wire                     core_cl_valid_lo;
   wire [ring_width_lp-1:0] core_cl_data_lo;
   wire                     core_fsb_yumi_lo;

   // fsb out
   wire                     core_fsb_valid_lo;
   wire [ring_width_lp-1:0] core_fsb_data_lo;
   wire                     core_cl_ready_lo;

  bsg_fsb #
    (.width_p(ring_width_lp)
    ,.nodes_p(nodes_p)
    ,.snoop_vec_p( { nodes_p { 1'b0 } })
    // if master, enable at startup so that it can drive things
    ,.enabled_at_start_vec_p(enabled_at_start_vec_p))
  fsb
    (.clk_i(core_clk_i)
    ,.reset_i(~core_calib_done_r_lo)

    // -------- fsb node --------

    // node ctrl
    ,.node_reset_r_o(core_node_reset_r_lo)
    ,.node_en_r_o(core_node_en_r_lo)

    // node in
    ,.node_v_i(core_node_v_B)
    ,.node_data_i(core_node_data_B)
    ,.node_yumi_o(core_node_yumi_B)

    // node out
    ,.node_v_o(core_node_v_A)
    ,.node_data_o(core_node_data_A)
    ,.node_ready_i(core_node_ready_A)

    // -------- bsg comm link --------

    // asm in
    ,.asm_v_i(core_cl_valid_lo)
    ,.asm_data_i(core_cl_data_lo)
    ,.asm_yumi_o(core_fsb_yumi_lo)

    // asm out
    ,.asm_v_o(core_fsb_valid_lo)
    ,.asm_data_o(core_fsb_data_lo)
    ,.asm_ready_i(core_cl_ready_lo));

  bsg_comm_link #
    (.channel_width_p(channel_width_p)
    ,.core_channels_p(ring_bytes_lp)
    ,.link_channels_p(num_channels_p)
    ,.master_p(master_p)
    ,.master_to_slave_speedup_p(master_to_client_speedup_p)
    ,.master_bypass_test_p(master_bypass_test_p))
  comm_link
    (.core_clk_i(core_clk_i)
    ,.io_master_clk_i(io_master_clk_i)

    // reset
    ,.async_reset_i(async_reset_i)

    // core ctrl
    ,.core_calib_done_r_o(core_calib_done_r_lo)

    // core in
    ,.core_valid_i(core_fsb_valid_lo)
    ,.core_data_i(core_fsb_data_lo)
    ,.core_ready_o(core_cl_ready_lo)

    // core out
    ,.core_valid_o(core_cl_valid_lo)
    ,.core_data_o(core_cl_data_lo)
    ,.core_yumi_i(core_fsb_yumi_lo)

    // in from i/o
    ,.io_valid_tline_i(io_valid_tline_i)
    ,.io_data_tline_i(io_data_tline_i)
    ,.io_clk_tline_i(io_clk_tline_i)              // clk
    ,.io_token_clk_tline_o(io_token_clk_tline_o)  // clk

    // out to i/o
    ,.im_valid_tline_o(im_valid_tline_o)
    ,.im_data_tline_o(im_data_tline_o)
    ,.im_clk_tline_o(im_clk_tline_o)       // clk
    ,.token_clk_tline_i(token_clk_tline_i) // clk

    ,.im_slave_reset_tline_r_o(im_slave_reset_tline_r_o));

  assign core_reset_o = ~core_calib_done_r_lo;

endmodule
