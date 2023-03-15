`default_nettype none
`include "top_level_definitions.vh"
module top (
	// Clock 50MHz
	input	wire		CLOCK_50,             // DE-series 50 MHz clock signal
	
	// Inputs
    input 	wire [9:0] 	SW,        // DE-series switches
	
    input 	wire [3:0] 	KEY,       // DE-series pushbuttons
	
	// Outputs
    output 	wire [9:0] 	LEDR,     // DE-series LEDs   
	
    output 	wire [6:0] 	HEX0,     // DE-series HEX displays
    output 	wire [6:0] 	HEX1,
    output 	wire [6:0] 	HEX2,
    output 	wire [6:0] 	HEX3,
    output 	wire [6:0] 	HEX4,
    output 	wire [6:0] 	HEX5
);

	wire [7:0] soc_d_out;
	wire 		  soc_d_val;
	wire [7:0] soc_ip;
	wire 		  non_signed;
	
	soc system_on_chip (
		.clk(CLOCK_50), 
		.resetn(~SW[9]), 
		.turbo_mode(SW[8]), 
		.gpi(~KEY[3:0]), 
		.gpo(LEDR[5:0]), 
		.din(SW[7:0]), 
		.debug(LEDR[9:6]),
		.dout(soc_d_out),
		.dval(soc_d_val),
		.ip(soc_ip),
		.non_signed(non_signed)
	);
	
	
	//Display modules
	disp_decimal dec (
		.value(soc_d_out),
		.enable(soc_d_val),
		.non_signed(non_signed),
		.disp_dec0(HEX0),
		.disp_dec1(HEX1),
		.disp_dec2(HEX2),
		.disp_dec3(HEX3)
	);
	
	disp_hex hex (
		.instruct_pointer(soc_ip),
		.disp_hex0(HEX4),
		.disp_hex1(HEX5)
	);

endmodule 
