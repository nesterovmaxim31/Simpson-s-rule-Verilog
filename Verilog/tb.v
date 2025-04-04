`timescale 1ns / 1ps

module tb;
   reg clk, btn;
   reg [15:0] sw;
   wire [15:0] result;

   fsm uut(clk, btn, sw, result);

   always #5 clk <= ~clk;
   
   initial begin
	  $dumpfile("test.vcd");
	  $dumpvars(0, tb);
	  clk = 0;
      sw = 0;
	  btn = 0;

	  // First value
	  #50 sw = 4;	  
	  #10 btn = 1;
	  #55 btn = 0;

	  // Second value
	  #25 sw = 2;
	  #10 btn = 1;
	  #55 btn = 0;

	  // Third value
	  #25 sw = 1;
	  #10 btn = 1;
	  #55 btn = 0;

	  // Fourth value
	  #25 sw = 0;
	  #10 btn = 1;
	  #55 btn = 0;

	  // a
	  #25 sw = 1;
	  #10 btn = 1;
	  #55 btn = 0;
	  
	  // b
	  #25 sw = 6;
	  #10 btn = 1;
	  #55 btn = 0;

	  // Result
	  #200
	  $finish;
	  
   end
   
endmodule
   
