// This module implements the framing protocol to output packets with the
// correct framing.

`default_nettype none

module frame
( input var logic  i_clk
,	input var logic  i_arst_n

,	input var logic  i_valid
,	input var logic  i_sop
,	input var logic  i_eop

,	output var logic o_valid
,	output var logic o_sop
,	output var logic o_eop
);

  logic frameComplete_d, frameComplete_q;

  always_ff @(posedge i_clk, negedge i_arst_n)
    if (!i_arst_n)
      frameComplete_q <= '1;
    else
      frameComplete_q <= frameComplete_d;

  always_comb
    if (i_valid)
      frameComplete_d = |{(!frameComplete_q && !i_sop && !i_eop)
                         ,(!frameComplete_q && i_sop  && !i_eop)
                         ,(frameComplete_q  && i_sop  && !i_eop)
                         } ? '0 : '1;
    else
      frameComplete_d = frameComplete_q;

  // {{{ SOP
  logic sopGate;

  always_comb
    sopGate = &{i_valid
              , i_arst_n
              , frameComplete_q
              };

  always_comb
    o_sop = i_sop && sopGate;
  // }}} SOP

  // {{{ EOP
  logic eopGate;

  always_comb
    eopGate = &{i_valid
              , i_arst_n
              , !frameComplete_q || (frameComplete_q && i_sop)
              };

  always_comb
    o_eop = i_eop && eopGate;
  // {{{ EOP

  // Valid Out is directly connected to Valid In.
  always_comb
    o_valid = i_valid;

endmodule

`resetall
