`timescale 1ns / 1ps

module fsm (
	    input		   clk, btn, 
	    input [15:0]	   sw, 
	    output reg [15:0] ans,
            output  [7:0] anodes,
            output  [6:0] segments
	    );
   
   reg  [3:0]  next_state, state = 0;
   reg [15:0]  a_0, a_1, a_2, a_3, a, b, x_1, x_2, x_3, result;
   reg		   sw_;
   reg [7:0]       anodes_mask = 7'b1111111;   
   
   wire [15:0] value_1, value_2, value_3;
   wire		   enable, seven_seg_display_ce;   

   func_value fv_1(a_0, a_1, a_2, a_3, x_1, value_1);
   func_value fv_2(a_0, a_1, a_2, a_3, x_2, value_2);
   func_value fv_3(a_0, a_1, a_2, a_3, x_3, value_3);

   debouncer db(clk, btn, enable);

   clk_div clk_div_1 (clk, seven_seg_display_ce);

   seven_seg_display seven_seg_display_1 (clk, seven_seg_display_ce, {16'b0000000000000000,ans}, anodes_mask, anodes, segments);
   
   
   always @(posedge clk) begin
	  // $display("%d", state);

	  case (state)
		// 0 - Initial state
		4'b0000: begin
		   a_0 <= 0;
		   a_1 <= 0;
		   a_2 <= 0;
		   a_3 <= 0;		   
		   result <= 0;
		   state = state + 1;		   
		end

		// 1 - Input a_0 (coefficients)
		4'b0001: begin
		   if (enable) begin
			  a_0 <= sw;
			  state <= state + 1;
		   end			 
		end

		// 2 - Input a_1 (coefficients)
		4'b0010: begin
		   if (enable) begin
			  a_1 <= sw;
			  state <= state + 1;
		   end
		end

		// 3 - Input a_2 (coefficients)
		4'b0011: begin
		   if (enable) begin
			  a_2 <= sw;
			  state <= state + 1;
		   end
		end

		// 4 - Input a_3 (coefficients)
		4'b0100: begin
		   if (enable) begin
			  a_3 <= sw;
			  state <= state + 1;
		   end
		end

		// 5 - Input a (left limit of integration)
		4'b0101: begin
		   if (enable) begin
			  a <= sw;
			  state <= state + 1;
		   end
		end

		// 6 - Input b (right limit of integration)
		4'b0110: begin
		   if (enable) begin
			  b <= sw;
			  state <= state + 1;
		   end
		end

		// 7 - Check if left limit is more than right one
		4'b0111: begin
		   if (a >= b) begin
			  // Go to error state 
			  state <= 14;
		   end
		   
		   else begin
			  state <= state + 1;
		   end
		end

		// 8 - Check the number of intervals for parity 
		4'b1000: begin
		   state <= ((b - a) % 2 != 0) ? 9 : 10;		   
		   x_1 <= b - 1;
		   x_2 <= b;			  
		end

		// 9 - In case of uneven amount of intervals  
		4'b1001: begin
		   b <= b - 1;  
		   result <= result + (value_1 + value_2) / 2;
		   state <= state + 1;
		end

		// 10 - While 
		4'b1010: begin
		   // $display("Result(uneven) = %d\n", result);
		   state <= (b > a) ? 11 : 13;
		   x_1 <= a;
		   x_2 <= a + 1;
		   x_3 <= a + 2;		   
		end

		// 11 - Add  
		4'b1011: begin
		   result <= result + (value_1 + 4 * value_2 + value_3) / 3;
		   // $display("Result = %d\n", result);
		   state <= state + 1;		   
		end

		// 12 - Increase 'a' and repeat  
		4'b1100: begin
		   a <= a + 2;
		   state <= 10;
		end

		// 13 - Output result
		4'b1101: begin
		   // $display("Result = %d\n", result);
		   state <= 0;
		   ans <= result;  
		end

		// 14 - Error state
		4'b1110: begin
		   $display("Error state. \n");
		   state <= 0;
		   $finish;		   
		end		
	  endcase
   end   
endmodule
