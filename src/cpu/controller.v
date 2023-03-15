`default_nettype none
`include "./cpu_definitions/cpu_definitions.vh"

module controller (
	input wire [2:0] command_group,
	input wire [2:0] command,
	output reg [3:0] alu_op,
	output reg branch_select,
	output reg write_enable,
	output reg is_atc
);

	always @(*)
		case (command_group)
			`NOP : begin
				write_enable = 1'b0;
				branch_select = 1'b0;
				is_atc = 1'b0;
				alu_op = `ALU_PUR;
			end
			
			`MOV : begin
				write_enable = 1'b1;
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`PUR: alu_op = `ALU_PUR;
					`SHL: alu_op = `ALU_SHL;
					`SHR: alu_op = `ALU_SHR;
					default: alu_op = `ALU_PUR;
				endcase
				
			end
			
			`JMP : begin
				write_enable = 1'b0;
				branch_select = 1'b1;
				is_atc = 1'b0;
				case (command)
					`UNC: alu_op = `ALU_UNC;
					`EQ : alu_op = `ALU_EQ ;
					`ULT: alu_op = `ALU_ULT;
					`SLT: alu_op = `ALU_SLT;
					`ULE: alu_op = `ALU_ULE;
					`SLE: alu_op = `ALU_SLE;
					default: alu_op = `ALU_PUR;
				endcase
			end
			
			`ACC : begin
				write_enable = 1'b1;
				branch_select = 1'b0;
				is_atc = 1'b0;
				case (command)
					`UAD: alu_op = `ALU_UAD;
					`SAD: alu_op = `ALU_SAD;
					`UMT: alu_op = `ALU_UMT;
					`SMT: alu_op = `ALU_SMT;
					`AND: alu_op = `ALU_AND;
					`OR : alu_op = `ALU_OR ;
					`XOR: alu_op = `ALU_XOR;
					default: alu_op = `ALU_PUR;
				endcase
			end
			
			`ATC : begin
				write_enable = 1'b0;
				branch_select = 1'b0;
				alu_op = `ALU_PUR;
				is_atc = 1'b1;
			end
			
			default: begin
				write_enable = 1'b0;
				branch_select = 1'b0;
				is_atc = 1'b0;
				alu_op = `ALU_PUR;
			end
		endcase
		
endmodule 



