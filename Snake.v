`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    Snake 
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
module Snake(
    input [3:0] PUSH_BUTTONS,
    input CLOCK,
    input RESET,
    output [7:0] COLOUR_OUT,
    output HS,
    output VS,
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT,
	 output [7:0] LEDS // for debugging
	 );

	// the wires for connecting the modules
	wire [1:0] MasterState;
	wire [1:0] NavState;
	wire [7:0] RandomAddrH;
	wire [6:0] RandomAddrV;	
	wire [9:0] AddrH;
	wire [8:0] AddrV;
	wire [7:0] Colour;
	wire [7:0] Colour2;
	wire ReachedTarget;		
	wire [3:0] Score; // the score we get from the score counter
	wire Gameclock;
	wire Suicide;
		
	// initialize the modules
	MasterStateMachine MasterSTM (
					.RESET(RESET),
					.CLOCK(CLOCK),
					.PUSH_BUTTONS(PUSH_BUTTONS),
					.SCORE_IN(Score),
					.STATE_OUT(MasterState),
					.SUICIDE_IN(Suicide)
					);
					
	NavigationStateMachine NavSTM (
					.RESET(RESET),
					.CLOCK(Gameclock),
					.PUSH_BUTTONS(PUSH_BUTTONS),
					.STATE_OUT(NavState)
					);
					
  RandomWrapper RNDMWrp (
					.CLK(CLOCK),
					.RESET(RESET),
					.NEXT(ReachedTarget),
					.MASTER_STATE(MasterState),
					.HORIZONTAL(RandomAddrH),
					.VERTICAL(RandomAddrV)
					);
					
// Change this to adjust the snake's speed	
GenericCounter  #(
		.COUNTER_WIDTH(22), 
		.COUNTER_MAX(4166667))
	GameSpeed(
		.CLK(CLOCK),
		.RESET(1'b0),
 		.ENABLE_IN(1),
		.TRIGG_OUT(Gameclock)
);						
	
  SnakeControl SnakeCtl (
    				.CLK(CLOCK),
					.GAMECLOCK(Gameclock),
					.ADDRH(AddrH),
					.ADDRV(AddrV),
					.COLOUR(Colour),
					.REACHED_TARGET(ReachedTarget),
					.MASTER_STATE(MasterState),
					.NAVIGATION_STATE(NavState),
					.RAND_ADDRH(RandomAddrH),
					.RAND_ADDRV(RandomAddrV),
					.DEBUG_OUT(LEDS),
					.SCORE(Score),
					.SUICIDE(Suicide)
					);

  VGAWrapper VGAWrp (
					.CLK(CLOCK),
					.MASTER_STATE(MasterState),
					.ADDRH(AddrH),
					.ADDRV(AddrV),
					.CIN(Colour),
					.COUT(COLOUR_OUT),
					.HS(HS),
					.VS(VS), 
					.COLOUR(Colour2)
					);
					
  ScoreCounter ScoreCnt(
					.RESET(RESET),
					.GAMECLOCK(Gameclock),
					.REACHED_TARGET(ReachedTarget),
					.CURRENT_SCORE(Score)
					);

 Seg7Decoder Seg7Dec(
					.SEG_SELECT_IN(0),
					.SEG_SELECT_OUT(SEG_SELECT),
					.BIN_IN(Score),
					.HEX_OUT(HEX_OUT),
					.DOT_IN(0)
    );

endmodule
