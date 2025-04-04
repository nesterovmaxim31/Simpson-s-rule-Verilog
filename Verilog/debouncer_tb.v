`timescale 1ns / 1ps

module debouncer_tb;
   reg clk, btn;
   wire out;
   
   initial begin
	  $dumpfile("test.vcd");
	  $dumpvars(0, debouncer_tb);
	  clk <= 0;
	  btn <= 0;

	  #20 btn = 1;

	  #5 btn = 0;
	  
	  #7 btn = 1;
	  
	  #50 btn = 0;

	  #20 btn = 1;
	  
	  #10 btn = 0;

	  #20;
	  

	  #5 btn = 1;
	  #2 btn = 0;
	  #5 btn = 1;
	  #12 btn = 0;
	  #100;
	  
	  
	  $finish;
	  
   end

   always #2 clk <= ~clk;
   
   debouncer db (clk, btn, out);  

endmodule
   
