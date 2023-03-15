`default_nettype none

module instruction_splitter (
	input  wire [31:0] insruction,
	output wire [2:0]  command_group,
	output wire [2:0]  command,
	output wire        arg_type_1,
	output wire [7:0]  arg_1,
	output wire        arg_type_2,
	output wire [7:0]  arg_2,
	output wire [7:0]  address
);

	assign command_group	= insruction [31:29];
	assign command			= insruction [28:26];
	assign arg_type_1		= insruction    [25];
	assign arg_1			= insruction [24:17];
	assign arg_type_2		= insruction    [16];
	assign arg_2			= insruction  [15:8]; 
	assign address			= insruction   [7:0];

endmodule 