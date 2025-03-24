// This module consist of properties of the frame protocol design
// 'frame.sv'. Each property has an associated assertion that is formally
// verified.

`default_nettype none

module frameAssertions
( input var logic i_clk
, input var logic i_arst

, input var logic i_validIn
, input var logic i_sopIn
, input var logic i_eopIn

, input var logic i_validOut
, input var logic i_sopOut
, input var logic i_eopOut
);

  // {{{ Valid signal is unchanged
  logic assert_validNotChanged;
  
  always_comb
  assert_validNotChanged = (i_validOut == i_validIn);
  
  assert property (@(posedge i_clk) assert_validNotChanged);
  // }}} Valid signal is unchanged
  
  // {{{ No delay between a valid SOP in and SOP out
  logic assert_noDelaySopInToSopOut;
  
  always_comb
  assert_noDelaySopInToSopOut = (i_sopOut && !i_sopIn) ? '0 : '1;
  
  assert property (@(posedge i_clk) assert_noDelaySopInToSopOut);
  // }}} No delay between a valid SOP in and SOP out

  // {{{ No delay between a valid EOP in and EOP out
  logic assert_noDelayEopInToEopOut;

  always_comb
    assert_noDelayEopInToEopOut = (i_eopOut && !i_eopIn) ? '0 : '1;

  assert property (@(posedge i_clk) assert_noDelayEopInToEopOut);
  // }}} No delay between a valid EOP in and EOP out

  // {{{ No SOP out when reset is asserted
  logic assert_noSopOutWhenReset;

  always_comb
    assert_noSopOutWhenReset = (i_sopOut && !i_arst) ? '0 : '1;

  assert property (@(posedge i_clk) assert_noSopOutWhenReset);
  // }}} No SOP out when reset is asserted

  // {{{ No EOP out when reset is asserted
  logic assert_noEopOutWhenReset;

  always_comb
    assert_noEopOutWhenReset = (i_eopOut && !i_arst) ? '0 : '1;

  assert property (@(posedge i_clk) assert_noEopOutWhenReset);
  // }}} No EOP out when reset is asserted

  // {{{ No EOP without a corresponding SOP
  logic sopReceived_d, sopReceived_q;

  always_ff @(posedge i_clk, negedge i_arst)
    if (!i_arst)
      sopReceived_q <= '0;
    else
      sopReceived_q <= sopReceived_d;

  always_comb
    if (i_sopOut)
      sopReceived_d = '1;
    else if (i_eopOut && sopReceived_q)
      sopReceived_d = '0;
    else
      sopReceived_d = sopReceived_q;

  logic assert_noEopWithoutSop;

  always_comb
    assert_noEopWithoutSop = |{!i_arst
                             , !i_eopOut
                             , i_eopOut && sopReceived_q
                             , i_eopOut && i_sopOut
                             };

  assert property (@(posedge i_clk) assert_noEopWithoutSop);
  // }}} NO EOP without a corresponding SOP

  // {{{ No 2 SOP without an EOP
  logic assert_no2SopWithoutEop;

  logic sopWithoutEop_q, sopWithoutEop_d;

  always_ff @(posedge i_clk, negedge i_arst)
    if (!i_arst)
      sopWithoutEop_q <= '0;
    else
      sopWithoutEop_q <= sopWithoutEop_d;

  always_comb
    if (i_sopOut && !i_eopOut)
      sopWithoutEop_d = '1;
    else if (i_eopOut)
      sopWithoutEop_d = '0;
    else
      sopWithoutEop_d = sopWithoutEop_q;

  always_comb
    assert_no2SopWithoutEop = |{!i_arst
                              , !i_sopOut
                              , (i_sopOut && !sopWithoutEop_q)
                              };

  assert property (@(posedge i_clk) assert_no2SopWithoutEop);
    // }}} No 2 SOP without an EOP

  // {{{ No inital EOP without a SOP after reset.
  logic assert_noEopWithoutSopAfterReset;

  // Delay arst by 1 clock cycle
  logic resetAsserted;

  /* verilator lint_off SYNCASYNCNET */
  always_ff @(posedge i_clk)
    if (!i_arst)
      resetAsserted <= '1;
    else
      resetAsserted <= '0;
  /* verilator lint_on SYNCASYNCNET */

  always_comb
    assert_noEopWithoutSopAfterReset = |{!i_arst
                                       , !resetAsserted
                                       , !(resetAsserted && i_eopOut && !i_sopOut)
                                      };

  assert property (@(posedge i_clk) assert_noEopWithoutSopAfterReset);
  // }}} No inital EOP without a SOP after reset

endmodule

`resetall
