`timescale 1ns / 1ps
module GenericCounter(	CLK,
						RESET,
						ENABLE_IN,
						TRIGG_OUT,
						COUNT
						);
	
	parameter COUNTER_WIDTH = 4;
	parameter COUNTER_MAX = 9;
	
	input CLK;
	input RESET;
	input ENABLE_IN;
	output reg TRIGG_OUT;
	output [COUNTER_WIDTH - 1 : 0] COUNT;

	reg [COUNTER_WIDTH - 1 : 0] Counter;
	
	
	
	always@ (posedge CLK) begin
		if (RESET)
			Counter <= 0;
		else begin
			if(ENABLE_IN) begin
				if (Counter == COUNTER_MAX)
					Counter <= 0;
				else
					Counter <= Counter +1;
			end
		end
	end
	
	always@ (posedge CLK) begin
		if (RESET)
			TRIGG_OUT <= 0;
		else begin
			if (ENABLE_IN && (Counter == COUNTER_MAX))
				TRIGG_OUT <= 1;
			else
				TRIGG_OUT <= 0;
		end
	end
	
	assign COUNT = Counter;


endmodule
