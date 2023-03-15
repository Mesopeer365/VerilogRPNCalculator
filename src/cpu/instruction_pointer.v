`default_nettype none
`include "./cpu_definitions/cpu_definitions.vh"
module instruction_pointer (
	input wire clk, resetn, enable, 
	input wire alu_result, branch_select, atc_out,
	input wire non_signed,
	input wire dval,
	input wire [3:0] gpi,
	input wire 		  gpi_hold,
	input wire [7:0] address,
	output reg [7:0] instruction_pointer
);
	
	always @(posedge clk or negedge resetn)
		if (!resetn)
			instruction_pointer <= 8'd0;
			
		else if (enable && alu_result && branch_select)
			instruction_pointer <= address;
			
		else if (enable && atc_out)
			instruction_pointer <= address;
			
		else if (dval && gpi_hold)
			instruction_pointer <= `IP_WAIT_HOLD;
			
		else if (enable)
			instruction_pointer <= instruction_pointer + 1'b1;
			
		else
			instruction_pointer <= instruction_pointer;
	
endmodule 