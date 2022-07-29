module UART_Transmit(input i_Clk, input [7:0] i_TX_byte, output o_UART_TX);

parameter ClksPerBit = 8'b11011001;
parameter IDLE = 2'b00;
parameter STARTBIT = 2'b01;
parameter DATABIT = 2'b10;
parameter STOPBIT = 2'b11;
reg [1:0] StateMachine = IDLE;
reg r_UART_TX = 1'b1;
reg [7:0] r_byte;
reg [7:0] r_clk_counter = 0;
reg [3:0] r_bit_counter = 0;

always @ (posedge i_Clk) 
	begin
	
	r_byte <= i_TX_byte;	// Put the current byte into a register, r_byte is the previous i_byte
	case(StateMachine)
	IDLE:	begin
			// When the byte has changed, go to the startbit state
			if (r_byte != i_TX_byte)
				begin
				StateMachine <= STARTBIT;
				end
			// If the byte isn't changing, stay in idle, keep sending 1's
			else
				begin
				StateMachine <= IDLE;
				r_UART_TX <= 1'b1;
				end;
			end //END IDLE STATE
	
	STARTBIT:	begin
				// For the first 217 clocks, send 0, stay in startbit, increment counter
				if (r_clk_counter < ClksPerBit)
					begin
					StateMachine <= STARTBIT;
					r_clk_counter <= r_clk_counter + 1;
					r_UART_TX <= 0;
					end
				// upon reaching 217th clock, reset counter, move state machine to databit
				else
					begin
					r_clk_counter <= 0;
					StateMachine <= DATABIT;
					end
				end //END START BIT STATE
				
	DATABIT:	begin
				// For data bits 0 to 7...
				if (r_bit_counter < 4'b1000)
					begin
					// for 217 clocks send the current bit of the byte
					if (r_clk_counter < ClksPerBit)
						begin
						r_UART_TX <= i_TX_byte[r_bit_counter];
						r_clk_counter <= r_clk_counter + 1;
						StateMachine <= DATABIT;
						end
					// Then increment which bit of the byte we're looking at and reset clk counter	
					else
						begin
						r_bit_counter <= r_bit_counter + 1;
						r_clk_counter <= 0;
						StateMachine <= DATABIT;
						end
					
					end
				// After last data bit is transmitted
				else
					begin
					// Reset counter and advance to the stopbit state
					r_bit_counter <= 0;
					StateMachine <= STOPBIT;
					end
				end // END DATABIT STATE
				
	STOPBIT:	begin
				//for 217 clocks send 1
				if (r_clk_counter < ClksPerBit)
					begin
					r_UART_TX <= 1;
					StateMachine <= STOPBIT;
					r_clk_counter <= r_clk_counter + 1;
					end
				// Then go back to idle! reset clk counter	
				else
					begin
					r_clk_counter <= 0;
					StateMachine <= IDLE;
					end
				end // END STOPBIT STATE
	endcase
	end	// END ALWAYS BLOCK
assign o_UART_TX = r_UART_TX;

endmodule