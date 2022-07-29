module UART_ReceiveTransmit_Top (input i_Clk, input i_UART_RX, 
output o_Segment1_A,
output o_Segment1_B,
output o_Segment1_C,
output o_Segment1_D,
output o_Segment1_E,
output o_Segment1_F,
output o_Segment1_G,
output o_Segment2_A,
output o_Segment2_B,
output o_Segment2_C,
output o_Segment2_D,
output o_Segment2_E,
output o_Segment2_F,
output o_Segment2_G,
output o_UART_TX);

wire [7:0] w_byte;
wire w_StopBitCheck;

// Run this module to interpret the byte sent on UART and output it as w_byte

UART_Receive UART_Receive_init(.i_Clk(i_Clk), .i_UART_RX(i_UART_RX), .o_byte(w_byte), .o_StopBitCheck(w_StopBitCheck));

// Run this module to send the byte back as output UART

UART_Transmit UART_Transmit_init(.i_Clk(i_Clk), .i_TX_byte(w_byte), .o_UART_TX(o_UART_TX));

//Convert our byte into two 4'binary values to be evaluated by the binary to seven segment display converter
wire [3:0] w_byte_firstDigit;
wire [3:0] w_byte_secondDigit;
assign w_byte_firstDigit = w_byte[7:4];
assign w_byte_secondDigit = w_byte[3:0];

//Send byte digits to the seven segment display converter then sling em to the segment outputs
wire [6:0] w_segments_firstDigit;
wire [6:0] w_segments_secondDigit;

binary_to_7seg binary_to_7seg_init(.i_clk(i_Clk), .i_binary(w_byte_secondDigit), .o_segments(w_segments_secondDigit));

binary_to_7seg binary_to_7seg_init2(.i_clk(i_Clk), .i_binary(w_byte_firstDigit), .o_segments(w_segments_firstDigit));

assign o_Segment1_A = ~w_segments_firstDigit[0];
assign o_Segment1_B = ~w_segments_firstDigit[1];
assign o_Segment1_C = ~w_segments_firstDigit[2];
assign o_Segment1_D = ~w_segments_firstDigit[3];
assign o_Segment1_E = ~w_segments_firstDigit[4];
assign o_Segment1_F = ~w_segments_firstDigit[5];
assign o_Segment1_G = ~w_segments_firstDigit[6];

assign o_Segment2_A = ~w_segments_secondDigit[0];
assign o_Segment2_B = ~w_segments_secondDigit[1];
assign o_Segment2_C = ~w_segments_secondDigit[2];
assign o_Segment2_D = ~w_segments_secondDigit[3];
assign o_Segment2_E = ~w_segments_secondDigit[4];
assign o_Segment2_F = ~w_segments_secondDigit[5];
assign o_Segment2_G = ~w_segments_secondDigit[6];

endmodule

