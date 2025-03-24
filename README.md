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
