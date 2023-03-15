module disp_hex
(
	input wire [7:0] instruct_pointer,
	output wire [6:0] disp_hex0,
	output wire [6:0] disp_hex1
);

	SSeg hex_dig0(.bin(instruct_pointer[3:0]), .neg(1'b0), .enable(1'b1), .segs(disp_hex0));
	SSeg hex_dig1(.bin(instruct_pointer[7:4]), .neg(1'b0), .enable(1'b1), .segs(disp_hex1));

endmodule 