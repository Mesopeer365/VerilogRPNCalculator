module disp_decimal (
	input signed [7:0] value,
	input enable,
	input non_signed,
	output [6:0] disp_dec0,
	output [6:0] disp_dec1,
	output [6:0] disp_dec2,
	output [6:0] disp_dec3
);
	
	wire [7:0] x_val = non_signed ? value : $signed(value);
	
	wire neg = x_val[7] && !non_signed;
	wire [7:0] x0 = neg ? -x_val : x_val;
	
	wire [7:0] x1, x2, x3; // Signals with 1 less digit
	wire en1, en2, en3; // Signals that enable the next digit
	
	snum_to_sseg digit0 (
		.x(x0),
		.neg(neg), .enable_in(enable),
		.xo(x1),
		.eno(en1),
		.segs(disp_dec0)
	);
	
	snum_to_sseg digit1 (
		.x(x1),
		.neg(neg), .enable_in(en1),
		.xo(x2),
		.eno(en2),
		.segs(disp_dec1)
	);
	
	snum_to_sseg digit2 (
		.x(x2),
		.neg(neg), .enable_in(en2),
		.xo(x3),
		.eno(en3),
		.segs(disp_dec2)
	);
	
	snum_to_sseg digit3 (
		.x(x3),
		.neg(neg), .enable_in(en3),
		.xo(),
		.eno(),
		.segs(disp_dec3)
	);
	
endmodule 