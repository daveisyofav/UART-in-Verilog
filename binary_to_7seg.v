module binary_to_7seg(input i_clk, input [3:0] i_binary, output [6:0] o_segments);

// takes binary number, outputs 7 bit bus of [GFEDCBA]

reg [6:0] r_segments;

always @ (posedge i_clk)
	begin
	
	case (i_binary)
		4'b0000: r_segments <= 7'b0111111;
		4'b0001: r_segments <= 7'b0000110;
		4'b0010: r_segments <= 7'b1011011;
		4'b0011: r_segments <= 7'b1001111;
		4'b0100: r_segments <= 7'b1100110;
		4'b0101: r_segments <= 7'b1101101;
		4'b0110: r_segments <= 7'b1111101;
		4'b0111: r_segments <= 7'b0000111; 
		4'b1000: r_segments <= 7'b1111111;
		4'b1001: r_segments <= 7'b1100111;
		4'b1010: r_segments <= 7'b1110111;
		4'b1011: r_segments <= 7'b1111100;
		4'b1100: r_segments <= 7'b0111001;
		4'b1101: r_segments <= 7'b1011110;
		4'b1110: r_segments <= 7'b1111001;
		4'b1111: r_segments <= 7'b1110001;
	endcase
	
	end
	
assign o_segments = r_segments;

endmodule