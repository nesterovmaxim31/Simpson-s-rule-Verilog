`timescale 1ns / 1ps

module debouncer (
				  input clk, btn, 
				  output reg out
				  );
   reg enable, clicked;
   reg [7:0] counter;
   

   initial begin
	  enable <= 0;
	  counter <= 0;
	  clicked <= 0;	  
   end

   always @(posedge clk) begin
	  if (btn) begin
		 counter <= (counter + 1) % 4;
	  end
	  else begin
		 clicked <= 0;		 
		 counter <= 0;
		 out <= 0;		 
	  end	  
   end

   always @(counter) begin
	  if (counter == 3 && !clicked) begin
		 // $display("Button is clicked");
		 counter <= 0;
		 clicked <= 1;
		 out <= 1;		 
	  end

	  if (counter != 0 && clicked) begin
		 out <= 0;
	  end
   end
	  
   
endmodule
