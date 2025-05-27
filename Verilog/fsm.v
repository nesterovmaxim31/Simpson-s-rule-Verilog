`timescale 1ns / 1ps

module fsm (
	    input		      clk, 
	    input             reset,
	    input             R_I, 
	    input      [15:0] dataIn,
	     
	    output reg [15:0] dataOut,
	    output reg        R_O,
        output reg        Error
);
   reg  [4:0]       state;
   reg  [15:0]      a_0, a_1, a_2, a_3, a, b, x_1, x_2, x_3, 
                    result,  value_4, value_1_, value_2_, value_3_, value_6,
                    value_1_1, value_1_2, value_1_3, 
                    value_2_1, value_2_2, value_2_3,
                    value_3_1, value_3_2, value_3_3;
   
   reg  [7:0]       anodes_mask;   
   
   wire [15:0]      value_1_1_1, value_1_1_2, value_1_2_1, value_1_2_2, value_1_3_1, value_1_3_2,
                    value_2_1_1, value_2_1_2, value_2_2_1, value_2_2_2, value_2_3_1, value_2_3_2, 
                    value_3_1_1, value_3_1_2, value_3_2_1, value_3_2_2, value_3_3_1, value_3_3_2, 
                    value_5;   
   
   initial begin
        state <= 0;
   end

   assign value_5 = (b - a) % 2;
   
   assign value_1_1_1 = a_0;
   assign value_1_1_2 = a_1 * x_1;
   assign value_1_2_1 = a_2 * x_1;
   assign value_1_2_2 = x_1;
   assign value_1_3_1 = a_3 * x_1; 
   assign value_1_3_2 = x_1 * x_1;
   
   assign value_2_1_1 = a_0;
   assign value_2_1_2 = a_1 * x_2;
   assign value_2_2_1 = a_2 * x_2;
   assign value_2_2_2 = x_2;
   assign value_2_3_1 = a_3 * x_2; 
   assign value_2_3_2 = x_2 * x_2;
   
   assign value_3_1_1 = a_0;
   assign value_3_1_2 = a_1 * x_3;
   assign value_3_2_1 = a_2 * x_3;
   assign value_3_2_2 = x_3;
   assign value_3_3_1 = a_3 * x_3; 
   assign value_3_3_2 = x_3 * x_3;

  
   always @(posedge clk) begin
      if (reset) begin
        state <= 0;
      end 
      
      else begin 
      
	  case (state)
		// 0 - Initial state
		5'd0: begin		   
		   result <= 0;
		   value_1_ <= 0;
		   value_2_ <= 0;
		   value_3_ <= 0;
		   value_4 <= 0;
		   value_6 <= 0;
		   value_1_1 <= 0;
		   value_1_2 <= 0;
		   value_1_3 <= 0;
		   value_2_1 <= 0;
		   value_2_2 <= 0;
		   value_2_3 <= 0;
		   value_3_1 <= 0;
		   value_3_2 <= 0;
		   value_3_3 <= 0;
		   dataOut <= 0;
		   state <= 1;		   
		end

		// 1 - Input a_0 (coefficients)
		5'd1: begin
		   if (R_I) begin
			  a_0 <= dataIn;
			  dataOut <= state;
			  state <= 2;
		   end			 
		end

		// 2 - Input a_1 (coefficients)
		5'd2: begin
		   if (R_I) begin
			  a_1 <= dataIn;
			  dataOut <= state;
			  state <= 3;
		   end
		end

		// 3 - Input a_2 (coefficients)
		5'd3: begin
		   if (R_I) begin
			  a_2 <= dataIn;
			  dataOut <= state;
			  state <= 4;
		   end
		end

		// 4 - Input a_3 (coefficients)
		5'd4: begin
		   if (R_I) begin
			  a_3 <= dataIn;
			  dataOut <= state;
			  state <= 5;
		   end
		end

		// 5 - Input a (left limit of integration)
		5'd5: begin
		   if (R_I) begin
			  a <= dataIn;
			  dataOut <= state;
			  state <= 6;
		   end
		end

		// 6 - Input b (right limit of integration)
		5'd6: begin
		   if (R_I) begin
			  b <= dataIn;
			  dataOut <= state;
			  state <= 7;
		   end
		end

		// 7 - Check if left limit is more than right one
		5'd7: begin
		  state <= (a >= b) ? 20 : 8;
		end

		// 8 - Check the number of intervals for parity 
		5'd8: begin
		   state <= (value_5 != 0) ? 9 : 10;		   
		   x_1 <= b - 1;
		   x_2 <= b;		  
		end

        // Multiplication step
        5'd9: begin
		   value_1_1 <= (value_1_1_1 + value_1_1_2);
		   value_1_2 <= value_1_2_1 * value_1_2_2;
		   value_1_3 <= value_1_3_1 * value_1_3_2;	
		   
		   value_2_1 <= (value_2_1_1 + value_2_1_2);
		   value_2_2 <= value_2_2_1 * value_2_2_2;
		   value_2_3 <= value_2_3_1 * value_2_3_2;	
		   
		   state <= 10;	  
		end
        
        // 10
        5'd10: begin
		   value_1_ <= (value_1_1 + value_1_2 + value_1_3);
		   value_2_ <= (value_2_1 + value_2_2 + value_2_3);		
		   state <= 11;	  
		end
		
		// 11
		5'd11: begin
		   value_6 <= (value_1_ + value_2_) >> 1;
		   state <= 12;	  
		end
		
		// 12 - In case of uneven amount of intervals  
		5'd12: begin
		   b <= b - 1;  
		   result <= result + value_6;
		   state <= 13;
		end

		// 13 - While 
		5'd13: begin
		   state <= (b > a) ? 14 : 19;
		   x_1 <= a;
		   x_2 <= a + 1;
		   x_3 <= a + 2;		   
		end

        // Multiplication step
        5'd14: begin
		   value_1_1 <= (value_1_1_1 + value_1_1_2);
		   value_1_2 <= value_1_2_1 * value_1_2_2;
		   value_1_3 <= value_1_3_1 * value_1_3_2;
		   
		   value_2_1 <= (value_2_1_1 + value_2_1_2);
		   value_2_2 <= value_2_2_1 * value_2_2_2;
		   value_2_3 <= value_2_3_1 * value_2_3_2;
		   
		   value_3_1 <= (value_3_1_1 + value_3_1_2);
		   value_3_2 <= value_3_2_1 * value_3_2_2;
		   value_3_3 <= value_3_3_1 * value_3_3_2;
		   state <= 15;		   
		end
		
		// 15 - Add  
		5'd15: begin
		   value_1_ <= (value_1_1 + value_1_2 + value_1_3);
		   value_2_ <= (value_2_1 + value_2_2 + value_2_3);
		   value_3_ <= (value_3_1 + value_3_2 + value_3_3);
		   state <= 16;		   
		end
		
		5'd16: begin
		   value_4 <= ((value_1_ + 4 * value_2_ + value_3_) * 341) >> 10;
		   state <= 17;		   
		end
		
		// 17 - Add 2
		5'd17: begin
		   result <= result + value_4;
		   state <= 18;		   
		end
		

		// 18 - Increase 'a' and repeat  
		5'd18: begin
		   a <= a + 2;
		   state <= 13;
		end

		// 19 - Output result
		5'd19: begin
		   dataOut <= result;  
		end

		// 20 - Error state
		5'd20: begin
		   $display("Error state. \n");
		end	
	   	
	   endcase
	  end
   end 
   
   // Ready output reg
   always@(posedge clk) begin
        case(state)
            5'd0:  R_O <= 0;
            5'd19: R_O <= 1;    
            5'd20: R_O <= 1;
        endcase
    end
    
    // Error state reg
    always@(posedge clk) begin
        case(state)
            5'd0:  Error <= 0;    
            5'd20: Error <= 1;
        endcase
    end
      
endmodule
