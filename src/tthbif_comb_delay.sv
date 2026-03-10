module tthbif_comb_delay (
  input  a_i,
  output z_o
);

`ifdef SIMULATION
      // give some delay per "buffer"
      assign #1 z_o = a_i;
`else
      wire inv;

      sky130_fd_sc_hd__inv_1 u_inv0_dont_touch (
        .A ( a_i ),
        .Y ( inv )
      );

      sky130_fd_sc_hd__inv_1 u_inv1_dont_touch (
        .A ( inv ),
        .Y ( z_o )
      );
`endif

endmodule
