`timescale 1ns / 1ps


module main(
    input		      clk, btn, cpu_reset, 
	input   [15:0]	  sw, 
    output  [7:0]     anodes,
    output  [6:0]     segments,
    output            LED, ERR 
);
    wire              enable, reset;
    wire    [15:0]    result;
    
    fsm fsm_1(.clk(clk), .reset(reset), .dataIn(sw), .R_I(enable), .dataOut(result), .R_O(LED), .Error(ERR));
    
   debouncer db_1(.clk(clk), .btn(btn), .ce(1'b1), .btn_click(enable));
   
   debouncer db_2(.clk(clk), .btn(cpu_reset), .ce(1'b1), .btn_click(reset));    

   clk_div clk_div_1 (.clk(clk), .ce_out(seven_seg_display_ce));

   seven_seg seven_seg_1 (.clk(clk), .ce(seven_seg_display_ce), .digits({16'b0000000000000000, result}),
   .anodes_mask(8'b11111111), .anodes(anodes), .segments(segments));
 
    
endmodule
