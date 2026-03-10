module tthbif_comb_delay (
  input  a_i,
  output z_o
);

`ifdef SIMULATION
      // give some delay per "buffer"
      assign #1 z_o = a_i;
`else
  `ifdef SKY130_INV
      wire inv;

      sky130_fd_sc_hd__inv_1 u_inv0_dont_touch (
        .A ( a_i ),
        .Y ( inv )
      );

      sky130_fd_sc_hd__inv_1 u_inv1_dont_touch (
        .A ( inv ),
        .Y ( z_o )
      );
  `else
      sky130_fd_sc_hd__dlygate4sd2 u_dlygate_dont_touch (
        .A ( a_i ),
        .X ( z_o )
      );
  `endif
`endif

endmodule
