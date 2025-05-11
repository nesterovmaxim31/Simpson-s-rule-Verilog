module clk_div (
    input clk,
    output ce_out
);

parameter WIDTH = 8;
   
reg [WIDTH-1:0] counter = 0;

assign ce_out = counter == {WIDTH{1'b0}};

always @(posedge clk) begin
    counter <= counter + 1;
end

endmodule
