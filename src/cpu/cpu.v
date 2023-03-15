`default_nettype none
`include "./cpu_definitions/cpu_definitions.vh"
module cpu (
	// System
	input wire clk,
	input wire enable,
	input wire resetn,
	
	// Intructions
	input  wire [31:0] instruction,
	output wire [7:0] instruction_pointer,
	
	// Inputs
	input wire [7:0] din,
	input wire [3:0] gpi,
	input wire 		  gpi_hold,
	
	// Outputs
	output wire [7:0] reg_dout,
	output wire [7:0] reg_gout,
	output wire [7:0] reg_flag,
	output reg  		non_signed
);
	
	//Instruction_splitter instantiation and outputs
	wire [2:0] command_group;
	wire [2:0] command;
	wire       arg_type_1;
	wire [7:0] arg_1;
	wire       arg_type_2;
	wire [7:0] arg_2;
	wire [7:0] address;
	
	instruction_splitter split(
		.insruction(instruction),
		.command_group(command_group),
		.command(command),
		.arg_type_1(arg_type_1),
		.arg_1(arg_1),
		.arg_type_2(arg_type_2),
		.arg_2(arg_2),
		.address(address)
	);
	
	
	//Controller outputs
	wire [3:0] alu_op;
	wire branch_select;
	wire write_enable;
	wire is_atc;
	
	
	//Register_file ports
	wire write_reg_enable = write_enable && (arg_type_2 == `REG);
	wire atc_out;
	wire [7:0] a_data_out;
	wire [7:0] b_data_out;	
	
	
	//Alu ports
	wire [7:0] operand_a = (arg_type_1 == `REG) ? a_data_out : arg_1;
	wire [7:0] operand_b = (arg_type_2 == `REG) ? b_data_out : arg_2;
	wire [7:0] alu_result;
	wire shift_overflow;
	wire arithmetic_overflow;	
		
		
	//Flag input
	reg [7:0] flag_inputs;
	always @(*)
		flag_inputs = {2'b0, (shift_overflow), (arithmetic_overflow), gpi};
	
	
	//Display signed or unsigned output number
	always @(posedge clk) 
		if (!resetn) non_signed <= 1'b0;
		else if (gpi_hold && gpi[1])
			non_signed <= !non_signed;

			
			
	//Module instantiations
	
	controller control(
		.command_group(command_group),
		.command(command),
		.alu_op(alu_op),
		.branch_select(branch_select),
		.write_enable(write_enable),
		.is_atc(is_atc)
	);
	
	
	alu logic_calc(
		.operand_a(operand_a),
		.operand_b(operand_b),
		.alu_op(alu_op),
		.result(alu_result),
		.shift_overflow(shift_overflow),
		.arithmetic_overflow(arithmetic_overflow)
	);

	
	register_file register(
		.clk(clk), .enable(enable), .resetn(resetn), 
		.non_signed(non_signed),
		
		.a_addr(arg_1), 
		.a_data_out(a_data_out),
		
		.b_addr(arg_2),
		.b_data_in(alu_result),
		.b_wr_enable(write_reg_enable),
		.b_data_out(b_data_out),
		
		.flag_inputs(flag_inputs),
		
		.is_atc(is_atc),
		.atc_bit(command),
		.atc_out(atc_out),
		
		.reg_din(din),
		.reg_gout(reg_gout),
		.reg_dout(reg_dout),
		.reg_flag(reg_flag)
	);
	
	
	instruction_pointer instruct(
		.clk(clk), .enable(enable), .resetn(resetn), 
		.alu_result(alu_result), 
		.branch_select(branch_select), 
		.atc_out(atc_out),
		.non_signed(non_signed),
		.dval(reg_gout[7]),
		.gpi(gpi),
		.gpi_hold(gpi_hold),
		.address(address),
		.instruction_pointer(instruction_pointer)
	);
	
endmodule 

