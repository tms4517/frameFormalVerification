# Formal verification of a data frame protocol

# HDL

The purpose of the frame module is to output packets with the correct framing.

The module may receive packets with framing errors (corrupt packets), but it
should not output those errors. Instead, it needs to output corrected
packets and ignore all input conditions that do not adhere to the framing
protocol.

## Framing protocol
