`default_nettype none

module tthbif_comb_path #(
  parameter int NUM_TAP
) (
  input  wire [$clog2(NUM_TAP)-1:0] tap_sel_i,

  input  wire                       sig_i,
  output wire                       sig_o
);

  wire [NUM_TAP-1:0] tap;

  assign tap[0] = sig_i;

  for (genvar gi=1; gi<NUM_TAP; gi++) begin: g_tap

    tthbif_comb_delay u_delay (
      .a_i ( tap[gi-1] ),
      .z_o ( tap[gi]   )
    );

  end: g_tap

  assign sig_o = tap[tap_sel_i];

endmodule
