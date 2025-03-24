`default_nettype none

module frameTb;

  /* verilator lint_off UNDRIVEN */
  logic clk;
  logic arst_n;

  logic validIn;
  logic sopIn;
  logic eopIn;
  /* verilator lint_on UNDRIVEN */

  logic validOut;
  logic sopOut;
  logic eopOut;

  frame u_frame
  ( .i_clk     (clk)
  ,	.i_arst_n  (arst_n)

  ,	.i_valid (validIn)
  ,	.i_sop   (sopIn)
  ,	.i_eop   (eopIn)

  ,	.o_valid (validOut)
  ,	.o_sop   (sopOut)
  ,	.o_eop   (eopOut)
  );

  frameAssertions u_frameAssertions
  ( .i_clk  (clk)
  , .i_arst (arst_n)

  , .i_validIn (validIn)
  , .i_sopIn   (sopIn)
  , .i_eopIn   (eopIn)

  , .i_validOut (validOut)
  , .i_sopOut   (sopOut)
  , .i_eopOut   (eopOut)
  );

endmodule

`resetall
