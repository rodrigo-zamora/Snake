`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:     
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SnakeControl(
	 input CLK,
	 input GAMECLOCK,
    input [9:0] ADDRH,
    input [8:0] ADDRV,
	 output reg [7:0] COLOUR,
	 output reg REACHED_TARGET,
	 input [1:0] MASTER_STATE,
	 input [1:0] NAVIGATION_STATE,
	 input [7:0] RAND_ADDRH,
	 input [6:0] RAND_ADDRV,
	 input [3:0] SCORE,
	 // this is true when the snake hits itself
	 output reg SUICIDE,
	 output [7:0] DEBUG_OUT
    );
	 
	 
	 // initial position in horizontal and vertical
	 // first 7 bits Horizontal, then 6 bits Vertical
	 
	 reg [6:0] ApplePositionH;
	 reg [5:0] ApplePositionV;
	 
	 reg [12:0] SnakePosition14 = {7'b0010000, 6'b010000};
	 reg [12:0] SnakePosition13 = {7'b0010000, 6'b010001};
	 reg [12:0] SnakePosition12 = {7'b0010000, 6'b010010};
	 reg [12:0] SnakePosition11 = {7'b0010000, 6'b010011};
	 reg [12:0] SnakePosition10 = {7'b0010000, 6'b010100};
	 reg [12:0] SnakePosition9 = {7'b0010000, 6'b010101};
	 reg [12:0] SnakePosition8 = {7'b0010000, 6'b010110};
	 reg [12:0] SnakePosition7 = {7'b0010000, 6'b010111};
	 reg [12:0] SnakePosition6 = {7'b0010000, 6'b011000};
	 reg [12:0] SnakePosition5 = {7'b0010000, 6'b011001};
	 reg [12:0] SnakePosition4 = {7'b0010000, 6'b011010};
	 reg [12:0] SnakePosition3 = {7'b0010000, 6'b011011};
	 reg [12:0] SnakePosition2 = {7'b0010000, 6'b011100};
	 reg [12:0] SnakePosition1 = {7'b0010000, 6'b011101};
	 reg [12:0] SnakePosition = {7'b0010000, 6'b011110};

	 wire [3:0] SNAKE_LEN;
	 assign SNAKE_LEN = SCORE +3'd5;
	  
	 assign DEBUG_OUT = {RAND_ADDRH[0], RAND_ADDRV[0], 2'b00, SNAKE_LEN};	
		
	 always@(posedge CLK) begin
	 if (MASTER_STATE == 1) begin
		//check if the apple would be outside the screen 
		if({RAND_ADDRH[7:1], 3'b111} <= 640)
			ApplePositionH <= RAND_ADDRH[7:1];
		else 
			ApplePositionH <= ~RAND_ADDRH[7:1];
		if({RAND_ADDRV[6:1], 3'b111} <= 480)
			ApplePositionV <= RAND_ADDRV[6:1];
		else 
			ApplePositionV <= ~RAND_ADDRV[6:1];
		// change the apples position if it would be on the head of the snake
		// but we just collected an apple on just this position:
		// change just a bit that causes the apple to go far away form the snake
		if(REACHED_TARGET && 
			SnakePosition[6:0] == ApplePositionH && 
			SnakePosition[12:7] == ApplePositionV) begin
				ApplePositionH[6] <= ~ApplePositionH[6];
				ApplePositionV[5] <= ~ApplePositionV[5];
		end
		// drawing the apple
		if(ADDRH > {ApplePositionH, 3'b000} && ADDRV > {ApplePositionV, 3'b000}
			&& ADDRH <= {ApplePositionH, 3'b111} &&  ADDRV <= {ApplePositionV, 3'b111})
				COLOUR <= 8'b00000111;
		// draw the snake's head
		else if (ADDRH > {SnakePosition[6:0], 3'b000} && ADDRV > {SnakePosition[12:7], 3'b000}
			&& ADDRH <= {SnakePosition[6:0], 3'b111} &&  ADDRV <= {SnakePosition[12:7], 3'b111})
			COLOUR <= 8'b11111111;
			
		// and its tail
		else if (SNAKE_LEN >1 && ADDRH > {SnakePosition1[6:0], 3'b000} && ADDRV > {SnakePosition1[12:7], 3'b000}
			&& ADDRH <= {SnakePosition1[6:0], 3'b111} &&  ADDRV <= {SnakePosition1[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >2 && ADDRH > {SnakePosition2[6:0], 3'b000} && ADDRV > {SnakePosition2[12:7], 3'b000}
			&& ADDRH <= {SnakePosition2[6:0], 3'b111} &&  ADDRV <= {SnakePosition2[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >3 && ADDRH > {SnakePosition3[6:0], 3'b000} && ADDRV > {SnakePosition3[12:7], 3'b000}
			&& ADDRH <= {SnakePosition3[6:0], 3'b111} &&  ADDRV <= {SnakePosition3[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >4 && ADDRH > {SnakePosition4[6:0], 3'b000} && ADDRV > {SnakePosition4[12:7], 3'b000}
			&& ADDRH <= {SnakePosition4[6:0], 3'b111} &&  ADDRV <= {SnakePosition4[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >5 && ADDRH > {SnakePosition5[6:0], 3'b000} && ADDRV > {SnakePosition5[12:7], 3'b000}
			&& ADDRH <= {SnakePosition5[6:0], 3'b111} &&  ADDRV <= {SnakePosition5[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >6 && ADDRH > {SnakePosition6[6:0], 3'b000} && ADDRV > {SnakePosition6[12:7], 3'b000}
			&& ADDRH <= {SnakePosition6[6:0], 3'b111} &&  ADDRV <= {SnakePosition6[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >7 && ADDRH > {SnakePosition7[6:0], 3'b000} && ADDRV > {SnakePosition7[12:7], 3'b000}
			&& ADDRH <= {SnakePosition7[6:0], 3'b111} &&  ADDRV <= {SnakePosition7[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >8 && ADDRH > {SnakePosition8[6:0], 3'b000} && ADDRV > {SnakePosition8[12:7], 3'b000}
			&& ADDRH <= {SnakePosition8[6:0], 3'b111} &&  ADDRV <= {SnakePosition8[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >9 && ADDRH > {SnakePosition9[6:0], 3'b000} && ADDRV > {SnakePosition9[12:7], 3'b000}
			&& ADDRH <= {SnakePosition9[6:0], 3'b111} &&  ADDRV <= {SnakePosition9[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >10 && ADDRH > {SnakePosition10[6:0], 3'b000} && ADDRV > {SnakePosition10[12:7], 3'b000}
			&& ADDRH <= {SnakePosition10[6:0], 3'b111} &&  ADDRV <= {SnakePosition10[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >11 && ADDRH > {SnakePosition11[6:0], 3'b000} && ADDRV > {SnakePosition11[12:7], 3'b000}
			&& ADDRH <= {SnakePosition11[6:0], 3'b111} &&  ADDRV <= {SnakePosition11[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >12 && ADDRH > {SnakePosition12[6:0], 3'b000} && ADDRV > {SnakePosition12[12:7], 3'b000}
			&& ADDRH <= {SnakePosition12[6:0], 3'b111} &&  ADDRV <= {SnakePosition12[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >13 && ADDRH > {SnakePosition13[6:0], 3'b000} && ADDRV > {SnakePosition13[12:7], 3'b000}
			&& ADDRH <= {SnakePosition13[6:0], 3'b111} &&  ADDRV <= {SnakePosition13[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else if (SNAKE_LEN >14 && ADDRH > {SnakePosition14[6:0], 3'b000} && ADDRV > {SnakePosition14[12:7], 3'b000}
			&& ADDRH <= {SnakePosition14[6:0], 3'b111} &&  ADDRV <= {SnakePosition14[12:7], 3'b111})
			COLOUR <= 8'b11111111;
		else
			COLOUR <= 8'b01000000;
			
		// checking if we hit an apple
		if(SnakePosition[6:0] == ApplePositionH && SnakePosition[12:7] == ApplePositionV)
			REACHED_TARGET <= 1;
		else
			REACHED_TARGET <= 0;
	  end
	  // check if the Snake hits itself
	  if(SNAKE_LEN > 1 && SnakePosition == SnakePosition1   || 
			SNAKE_LEN > 2 && SnakePosition == SnakePosition2   || 
			SNAKE_LEN > 3 && SnakePosition == SnakePosition3   || 
			SNAKE_LEN > 4 && SnakePosition == SnakePosition4   || 
			SNAKE_LEN > 5 && SnakePosition == SnakePosition5   ||
			SNAKE_LEN > 6 && SnakePosition == SnakePosition6   || 
			SNAKE_LEN > 7 && SnakePosition == SnakePosition7   ||
			SNAKE_LEN > 8 && SnakePosition == SnakePosition8   || 
			SNAKE_LEN > 9 && SnakePosition == SnakePosition9   ||
			SNAKE_LEN > 10 && SnakePosition == SnakePosition10 || 
			SNAKE_LEN > 11 && SnakePosition == SnakePosition11 ||
			SNAKE_LEN > 12 && SnakePosition == SnakePosition12 || 
			SNAKE_LEN > 13 && SnakePosition == SnakePosition13 ||
			SNAKE_LEN > 14 && SnakePosition == SnakePosition14)
			SUICIDE <= 1;
	  else
			SUICIDE <= 0;
	end
		
	always@(posedge GAMECLOCK) begin
		if(MASTER_STATE == 0) begin
			SnakePosition14 <= {7'b0010000, 6'b010000};
			SnakePosition13 <= {7'b0010000, 6'b010001};
			SnakePosition12 <= {7'b0010000, 6'b010010};
			SnakePosition11 <= {7'b0010000, 6'b010011};
			SnakePosition10 <= {7'b0010000, 6'b010100};
			SnakePosition9 <= {7'b0010000, 6'b010101};
			SnakePosition8 <= {7'b0010000, 6'b010110};
			SnakePosition7 <= {7'b0010000, 6'b010111};
			SnakePosition6 <= {7'b0010000, 6'b011000};
			SnakePosition5 <= {7'b0010000, 6'b011001};
			SnakePosition4 <= {7'b0010000, 6'b011010};
			SnakePosition3 <= {7'b0010000, 6'b011011};
			SnakePosition2 <= {7'b0010000, 6'b011100};
			SnakePosition1 <= {7'b0010000, 6'b011101};
			SnakePosition <= {7'b0010000, 6'b011110};
		end else if(MASTER_STATE == 1) begin
			//shift the snake register
			SnakePosition1 <= SnakePosition;
			SnakePosition2 <= SnakePosition1;
			SnakePosition3 <= SnakePosition2;
			SnakePosition4 <= SnakePosition3;
			SnakePosition5 <= SnakePosition4;
			SnakePosition6 <= SnakePosition5;
			SnakePosition7 <= SnakePosition6;
			SnakePosition8 <= SnakePosition7;
			SnakePosition9 <= SnakePosition8;
			SnakePosition10 <= SnakePosition9;
			SnakePosition11 <= SnakePosition10;
			SnakePosition12 <= SnakePosition11;
			SnakePosition13 <= SnakePosition12;
			SnakePosition14 <= SnakePosition13;
			
			// moving the snake
			case(NAVIGATION_STATE)
			2'b00: begin // the right direction
				SnakePosition[6:0] <= SnakePosition[6:0] + 1; // Plus in H
			end
			3'b01: begin // the down state
				SnakePosition[12:7] <= SnakePosition[12:7] + 1; // Plus in V
			end
			2'b10: begin // the up direction
				if(SnakePosition[12:7] == 0)
					SnakePosition[12:7] <= 58;
				else
					SnakePosition[12:7] <= SnakePosition[12:7] - 1; // Minus in V
			end
			2'b11: begin // the left state
				if(SnakePosition[6:0] == 0)
					SnakePosition[6:0] <= 78;
				else
					SnakePosition[6:0] <= SnakePosition[6:0] - 1; // Minus in H
			end
			endcase
			// prevent the snake from leaving the screen
			if(SnakePosition[6:0] > 78)
				SnakePosition[6:0] <= 0;
			if(SnakePosition[12:7] > 58)
				SnakePosition[12:7] <= 0;
		end
	 end
	 


endmodule
