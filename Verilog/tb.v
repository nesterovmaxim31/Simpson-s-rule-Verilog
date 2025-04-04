`timescale 1ns / 1ps

module tb;
   reg clk, btn;
   reg [15:0] sw;
   wire [15:0] result;

   fsm uut(clk, btn, sw, result);

   always #5 clk <= ~clk;

   // task for click button
   task click (input [15:0] a_0, a_1, a_2, a_3, a, b);
	  begin
		 // First value
		 #50 sw = a_0;	  
		 #10 btn = 1;
		 #55 btn = 0;

		 // Second value
		 #25 sw = a_1;
		 #10 btn = 1;
		 #55 btn = 0;

		 // Third value
		 #25 sw = a_2;
		 #10 btn = 1;
		 #55 btn = 0;

		 // Fourth value
		 #25 sw = a_3;
		 #10 btn = 1;
		 #55 btn = 0;

		 // a
		 #25 sw = a;
		 #10 btn = 1;
		 #55 btn = 0;
		 
		 // b
		 #25 sw = b;
		 #10 btn = 1;
		 #55 btn = 0;

		 // Result
		 #200 $display("Result = %d\n", result);
		 
		 #45;		 
	  end
   endtask
	  
   initial begin
	  $dumpfile("test.vcd");
	  $dumpvars(0, tb);
	  clk = 0;
      sw = 0;
	  btn = 0;
	  
	  click(7, 0, 0, 0, 7, 16);
	  click(1, 3, 0, 0, 2, 8);	  
	  click(4, 2, 1, 0, 1, 6);
	  click(1, 1, 2, 1, 2, 5); 
	  click(4, 10, 0, 2, 5, 12); // 10678.5	  

	  #50
	  $finish;
	  
   end
   
endmodule
   
