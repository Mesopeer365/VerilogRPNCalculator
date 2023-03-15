`timescale  1ns/1ps

module test_disp_decimal;
	reg non_signed;
	reg signed [7:0] value;
	reg enable;
	wire [6:0] disp_dec0, disp_dec1, disp_dec2, disp_dec3;

	disp_decimal run(
		.value(value), .enable(enable), .non_signed(non_signed),
		.disp_dec0(disp_dec0), 
		.disp_dec1(disp_dec1), 
		.disp_dec2(disp_dec2), 
		.disp_dec3(disp_dec3)
	);
	
	initial begin 
	non_signed=0;
	enable=1;
	value=0;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=127;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=-128;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=43;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=-12;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=6;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=-1;
	$strobe("%4d =",value,,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 non_signed=1;
	
	#5 value=255;
	$strobe("%4d =",$unsigned(value),,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=-128;
	$strobe("%4d =",$unsigned(value),,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	#5 value=256;
	$strobe("%4d =",$unsigned(value),,"%b",disp_dec3,,"%b",disp_dec2,,"%b",disp_dec1,,"%b",disp_dec0);
	
	end
	
endmodule 