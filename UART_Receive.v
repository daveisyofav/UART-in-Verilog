module UART_Receive(input i_Clk, input i_UART_RX, output [7:0] o_byte, output o_StopBitCheck);

parameter IDLE = 2'b00;
//parameter START_BIT = 2'b01;
parameter DATA_BIT = 2'b10;
parameter STOP_BIT = 2'b11;

reg [1:0] r_StateMachine = IDLE;
reg [7:0] r_clk_counter = 8'b00000000;
reg [2:0] r_bit_counter = 3'b000;
reg [7:0] r_UART_RX = 8'b00000000;
reg r_StopBitCheck = 1'b0;
//wire w_UART_RX;

always @ (posedge i_Clk)
	begin
	
	// When in the IDLE State of our state machine , probably should have done a case statement:
	if (r_StateMachine == IDLE)
		begin
		
		r_StopBitCheck <= 1'b0; //initialize our stop bit checker to zero
		
		// Probably should have done a nested if statement instead , when input recently becomes zero (start bit)
		if (i_UART_RX == 0 && r_clk_counter < 8'b01101100)
			begin
			r_clk_counter <= r_clk_counter + 1; // increment counter and stay in IDLE
			r_StateMachine <= IDLE;
			end
		
		// When input has been at zero for half a BAUD Rate (middle of start bit)
		else if (i_UART_RX == 0 && r_clk_counter == 8'b01101100)
			begin
			r_StateMachine <= DATA_BIT; //Go to DATABIT for state machine
			r_clk_counter <= 0; // Reset clk counter
			end
		// If input is still 1, just stay in idle, do nothing, keep clk counter at zero
		else
			begin
			r_StateMachine <= IDLE; 
			r_clk_counter <= 0;
			end
			
		end
	
	// When in DATABIT State of State Machine
	else if (r_StateMachine == DATA_BIT)
		begin
		
		// Wait until middle of databit
		if (r_clk_counter < 8'b11011001)
			begin
			r_clk_counter <= r_clk_counter + 1;
			r_StateMachine <= DATA_BIT;
			end
		
		// at middle of databit, give the bit to our register UART lsb first
		else if (r_clk_counter == 8'b11011001)
			begin
			r_UART_RX[r_bit_counter] <= i_UART_RX;
			r_clk_counter <= 0;
			
			// if we ain't at our last databit yet, increment and stay in databit state
			if (r_bit_counter < 3'b111)
				begin
				
				r_bit_counter <= r_bit_counter + 1;
				r_StateMachine <= DATA_BIT;
				end
			
			// or if were done ripping bits, restart the counter, go to the stop bit state
			else if (r_bit_counter == 3'b111)
				begin
				
				
				r_bit_counter <= 0;
				r_StateMachine <= STOP_BIT;
				end
			end
		end
	
	// in the stop bit state , make sure it's a valid stop bit and go to idle
	else if (r_StateMachine == STOP_BIT)
		begin
			
		if (r_clk_counter < 8'b11011001)
			begin
			r_clk_counter <= r_clk_counter + 1;
			end
			
		else if (r_clk_counter == 8'b11011001)
			begin
			r_clk_counter <= 0;
			r_StateMachine <= STOP_BIT;
			if (i_UART_RX == 1'b1)
				begin
				r_StopBitCheck <= 1'b1;
				r_StateMachine <= IDLE;
				end
			end
			
		end
	end
	
assign o_byte = r_UART_RX;
assign o_StopBitCheck = r_StopBitCheck;

endmodule	
					