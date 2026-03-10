`default_nettype none

module tthbif_rx_lane #(
  parameter int NUM_FLOP_TAP,
  parameter int NUM_COMB_TAP,
) (
  input  wire       clk_i,
  input  wire       rst_ni,

  input  wire [$clog2(NUM_COMB_TAP)-1:0] comb_tap_sel_i,
  input  wire [$clog2(NUM_FLOP_TAP)-1:0] flop_tap_sel_i,

  input  wire       rx_i,
  output wire       rx_o
);

  wire rx_comb;

  tthbif_comb_path #(
    .NUM_TAP         ( NUM_COMB_TAP )
  ) u_tthbif_comb_path (
    .tap_sel_i ( comb_tap_sel_i ),
  
    .sig_i     ( rx_i           ),
    .sig_o     ( rx_comb        )
  );

  tthbif_flop_path #(
    .NUM_TAP ( NUM_FLOP_TAP )
  ) u_tthbif_flop_path (
    .clk_i     ( clk_i          ),
    .rst_ni    ( rst_ni         ),
  
    .tap_sel_i ( flop_tap_sel_i ),
  
    .sig_i     ( rx_comb        ),
    .sig_o     ( rx_o           )
  );

endmodule
