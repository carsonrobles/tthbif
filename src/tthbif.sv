module tthbif #(
  parameter int NUM_LANES            = 1,

  parameter int NUM_FLOP_TAP         = 4,
  parameter int NUM_COMB_TAP         = 4,
  parameter int NUM_BUF_PER_COMB_TAP = 4
) (
  input                                            clk_i,
  input                                            rst_ni,

  input                                            en_i,

  input  [NUM_LANES-1:0]                           rx_lane_en_i,
  input  [NUM_LANES-1:0]                           tx_lane_en_i,

  input  [NUM_LANES-1:0][$clog2(NUM_FLOP_TAP)-1:0] rx_flop_tap_sel_i,
  input  [NUM_LANES-1:0][$clog2(NUM_COMB_TAP)-1:0] rx_comb_tap_sel_i,
  input  [NUM_LANES-1:0][$clog2(NUM_FLOP_TAP)-1:0] tx_flop_tap_sel_i,
  input  [NUM_LANES-1:0][$clog2(NUM_COMB_TAP)-1:0] tx_comb_tap_sel_i,

  input  [NUM_LANES-1:0]                           rx_i,
  output [NUM_LANES-1:0]                           tx_o,

  output [NUM_LANES-1:0]                           rx_o,
  input  [NUM_LANES-1:0]                           tx_i
);

  wire rst_n = rst_ni & en_i;

  wire [NUM_LANES-1:0] rx_lane_rst_n;
  wire [NUM_LANES-1:0] tx_lane_rst_n;

  wire [NUM_LANES-1:0] rx;
  wire [NUM_LANES-1:0] tx;

  for (genvar gi=0; gi<NUM_LANES; gi++) begin: g_lanes

    assign rx_lane_rst_n[gi] = rst_n & rx_lane_en_i[gi];
    assign tx_lane_rst_n[gi] = rst_n & tx_lane_en_i[gi];

    tthbif_rx_lane #(
      .NUM_FLOP_TAP         ( NUM_FLOP_TAP         ),
      .NUM_COMB_TAP         ( NUM_COMB_TAP         ),
      .NUM_BUF_PER_COMB_TAP ( NUM_BUF_PER_COMB_TAP )
    ) u_rx_lane (
      .clk_i          ( clk_i                 ),
      .rst_ni         ( rx_lane_rst_n[gi]     ),
    
      .comb_tap_sel_i ( rx_comb_tap_sel_i[gi] ),
      .flop_tap_sel_i ( rx_flop_tap_sel_i[gi] ),
    
      .rx_i           ( rx_i[gi]              ),
      .rx_o           ( rx[gi]                )
    );

    tthbif_tx_lane #(
      .NUM_FLOP_TAP         ( NUM_FLOP_TAP         ),
      .NUM_COMB_TAP         ( NUM_COMB_TAP         ),
      .NUM_BUF_PER_COMB_TAP ( NUM_BUF_PER_COMB_TAP )
    ) u_tx_lane (
      .clk_i          ( clk_i                 ),
      .rst_ni         ( tx_lane_rst_i[gi]     ),
    
      .comb_tap_sel_i ( tx_comb_tap_sel_i[gi] ),
      .flop_tap_sel_i ( tx_flop_tap_sel_i[gi] ),
    
      .tx_i           ( tx[gi]                ),
      .tx_o           ( tx_o[gi]              )
    );

    assign rx_o[gi] = rx[gi];
    assign tx[gi]   = tx_i[gi];

  end: g_lanes

endmodule
