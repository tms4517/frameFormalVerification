lint:
	verilator --lint-only -Wall tb/frameTb.sv -Ihdl/ -Itb/

formal:
	jg jg/jg.tcl &

clean:
	rm -rf jgproject
