`timescale 1ns / 1ps

module func_value (
				   input [15:0] a_0, a_1, a_2, a_3, x,
				   output [15:0] result
				   );
   
   assign result = a_0 + a_1 * x + a_2 * x * x + a_3 * x * x * x;
   
endmodule
				   
  
