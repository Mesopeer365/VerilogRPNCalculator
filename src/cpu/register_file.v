`default_nettype none
`include "./cpu_definitions/cpu_definitions.vh"

module register_file (
	input wire clk,
	input wire enable,
	input wire resetn,
	input wire non_signed,
	
	// Port a (read only)
	input  wire [4:0] a_addr,
	output wire [7:0] a_data_out,
	
	// Port b (read / write)
	input  wire [4:0] b_addr,
	input  wire [7:0] b_data_in,
	input  wire       b_wr_enable,
	output wire [7:0] b_data_out,
	
	// Flag Register Input Signals
	input  wire [7:0] flag_inputs,
	
	//ATC commands
	input  wire is_atc,
	input  wire [2:0] atc_bit,
	output wire atc_out,
	
	// Special Registers
	input  wire [7:0] reg_din,
	output wire [7:0] reg_gout,
	output wire [7:0] reg_dout,
	output wire [7:0] reg_flag
);

	reg [7:0] reg_arr [0:31];
	
	// Reads
	assign a_data_out = reg_arr[a_addr];
	assign b_data_out = reg_arr[b_addr];
	assign atc_out = is_atc ? reg_arr[`FLAG][atc_bit] : 1'b0;
	
	// Write Functionality
	always @(posedge clk or negedge resetn) begin : write_block
		integer i;
		if (!resetn)
			for (i = 0; i < 32; i = i + 1)
				reg_arr[i] <= 0;
			
		else begin
			if (enable && b_wr_enable)
				reg_arr[b_addr] <= b_data_in;
				
			// If ATC command, clear the atc bit
			if (enable && is_atc)
				reg_arr[`FLAG][atc_bit] <= 1'b0;
			
			// Set FLAG bits. This must be after any register write to not miss a flag
			for (i = 0; i < 7; i = i + 1)
				if (flag_inputs[i])
					reg_arr[`FLAG][i] <= 1'b1;
			
			// Always want the dinput register to be written by dinput
			reg_arr[`DINP] <= reg_din;
			
			// Display whether display is signed or unsigned
			if (reg_arr[`GOUT][7])
				reg_arr[`GOUT][5] <= non_signed;
			
			// Increment the random number address
			if 		(reg_arr[`RAND] != 8'b1111_1111) reg_arr[`RAND] <= reg_arr[`RAND] + 1'b1;
			else if 	(reg_arr[`RAND] == 8'b1111_1111)	reg_arr[`RAND] <= 8'b0;

		end
	end
	
	assign reg_gout = reg_arr[`GOUT];
	assign reg_dout = reg_arr[`DOUT];
	assign reg_flag = reg_arr[`FLAG];
	
endmodule
