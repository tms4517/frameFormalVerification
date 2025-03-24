clear -all

# Load and analyze the RTL & TB.
analyze -sv hdl/frame.sv tb/frameAssertions.sv tb/frameTb.sv
# Synthesize the RTL and read the netlist.
elaborate -top frameTb

clock clk
reset !arst_n

# Prove all properties.
prove -all
