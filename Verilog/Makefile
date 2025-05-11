exe: tb.v fsm.v func_value.v debouncer.v clk_div.v seven_seg_display.v	
	iverilog tb.v func_value.v fsm.v clk_div.v seven_seg_display.v debouncer.v -o exe

exe_db: debouncer.v debouncer_tb.v
	iverilog debouncer.v debouncer_tb.v -o exe_db

.PHONY:
clean:
	rm -rf exe test.vcd exe_db

run: exe
	vvp exe 

debug_fsm: exe
	vvp exe
	gtkwave test.vcd

debug_debouncer: exe_db
	vvp exe_db
	gtkwave test.vcd
