module seven_seg (
    input clk, ce, 
    
    input [31:0] digits,
    input [7:0] anodes_mask,
    
    output reg [7:0] anodes,
    output reg [6:0] segments
);

reg [2:0] current_digit_index;

reg [6:0] next_segments;

initial begin
    current_digit_index = 3'd0;
end

always @(*) begin
    case (digits[current_digit_index*4+:4])
        4'h0: next_segments = 7'b1000000;
        4'h1: next_segments = 7'b1111001;
        4'h2: next_segments = 7'b0100100;
        4'h3: next_segments = 7'b0110000;
        4'h4: next_segments = 7'b0011001;
        4'h5: next_segments = 7'b0010010;
        4'h6: next_segments = 7'b0000010;
        4'h7: next_segments = 7'b1111000;
        4'h8: next_segments = 7'b0000000;
        4'h9: next_segments = 7'b0010000;
        4'ha: next_segments = 7'b0001000;
        4'hb: next_segments = 7'b0000011;
        4'hc: next_segments = 7'b1000110;
        4'hd: next_segments = 7'b0100001;
        4'he: next_segments = 7'b0000110;
        4'hf: next_segments = 7'b0001110;
    endcase
end

always @(posedge clk) begin
    if (ce) begin
        current_digit_index <= current_digit_index + 1;
        segments            <= next_segments;
        
        if (anodes_mask[current_digit_index]) begin
            anodes <= ~(8'b1 << current_digit_index);
        end else begin
            anodes <= {8{1'b1}};
        end
    end
end

endmodule
