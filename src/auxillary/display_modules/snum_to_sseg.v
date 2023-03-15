module snum_to_sseg
(
	input [7:0] x, 
	input neg, enable_in, 
	output reg [7:0] xo, 
	output eno, 
	output [6:0] segs
);

	wire [3:0] digit = x % 4'd10;
	wire n_sign = neg && !x;
	
	assign eno = !((!neg && x<10) || (neg && n_sign)) && enable_in; // Next digit display enabling signal
	
	always @(*)
		xo = x / 4'd10;
	
	SSeg converter(.bin(digit), .neg(n_sign), .enable(enable_in), .segs(segs));

endmodule 