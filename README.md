# Formal verification of a data frame protocol

In this repository a simple data frame protocol is formally verified.

Formal verification employs mathematical analysis to explore the entire space of
possible simulations. Properties are defined to specify the design behavior, and
assertions are used to instruct the formal tool to verify that these properties
always hold true.

# HDL

The purpose of the frame module is to output packets with the correct framing.

The module may receive packets with framing errors (corrupt packets), but it
should not output those errors. Instead, it needs to output corrected
packets and ignore all input conditions that do not adhere to the framing
protocol.

## Framing protocol

## TB

`frameTb.sv` is the top level Tb module. The module instances the DUT and
`frameAssertions.sv` which contains the properties and assertions. The top level
Tb drives the inputs of both submodules and connects the output of the DUT to
the respective inputs of `frameAssertions.sv`.

`frameAssertions.sv` contains ONLY synthesizable auxillary logic i.e does not
contain implication operators or time delays.

Note: Properties were written in this manner as Verilator has limited support
for the `property` keyword. However, they can be replaced to the widely used
method eg -

```
property <prop_propertyName>
  @(posedge i_clk) <assert_aseertionName>
endproperty

assert property(<prop_propertyName>);
```

# Makefile

Prerequisites: Verilator, JasperGold FPV

Lint TB and design: `make lint`

Formally verify assertions: `make formal` (all assertions should pass).
