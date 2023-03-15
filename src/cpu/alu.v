`default_nettype none
`include "./cpu_definitions/cpu_definitions.vh"

module alu (
	input wire [7:0] operand_a,
	input wire [7:0] operand_b,
	input wire [3:0] alu_op,
	
	output reg [7:0] result,
	output reg arithmetic_overflow,
	output reg shift_overflow
);

	wire [8:0] shift_left = {operand_a, 1'b0};
	wire [8:0] shift_right = {1'b0, operand_a};
	
	wire [8:0] unsigned_add = operand_a + operand_b;
	wire signed [8:0] signed_add = $signed(operand_a) + $signed(operand_b);
	wire [15:0] unsigned_mul = operand_a * operand_b;
	wire signed [15:0] signed_mul = $signed(operand_a) * $signed(operand_b);	
	
	always @(*)
		case (alu_op)
			`ALU_PUR : result = operand_a; 										  	// Pure Move
			`ALU_SHL : result = shift_left[7:0]; 								  	// Move and Shift Left
			`ALU_SHR : result = shift_right[8:1]; 								  	// Move and Shift Right
			
			`ALU_UNC	: result = 1'd1; 												  	// Unconditional Jump
			`ALU_EQ 	: result = operand_a == operand_b; 						  	// Jump On Equality
			`ALU_ULT	: result = operand_a <  operand_b; 						  	// Jump On Unsigned Less Than
			`ALU_SLT	: result = $signed(operand_a) <  $signed(operand_b); 	// Jump On Signed Less Than
			`ALU_ULE	: result = operand_a <=  operand_b; 					  	// Jump On Unsigned Less Than Or Equal To
			`ALU_SLE	: result = $signed(operand_a) <= $signed(operand_b);	// Jump On Signed Less Than Or Equal To
			
			`ALU_UAD : result = unsigned_add[7:0]; 								// Unsigned Addition
			`ALU_SAD : result = signed_add[7:0]; 									// Signed Addition
			`ALU_UMT : result = unsigned_mul[7:0]; 								// Unsigned Multiplication
			`ALU_SMT : result = signed_mul[7:0];  									// Signed Multiplication
			`ALU_AND : result = operand_a & operand_b;							// Bitwise AND
			`ALU_OR  : result = operand_a | operand_b; 							// Bitwise OR
			`ALU_XOR : result = operand_a ^ operand_b; 							// Bitwise XOR
			
			default  : result = operand_a; 											// Pure move
		endcase
	
	always @(*) begin
		case (alu_op)
			`ALU_SHL : shift_overflow = shift_left[8];
			`ALU_SHR : shift_overflow = shift_right[0];
			default  : shift_overflow = 1'b0;
		endcase
	end
	
	always @(*) begin
		case (alu_op)
			`ALU_UAD : arithmetic_overflow = unsigned_add > 255;
			`ALU_SAD : arithmetic_overflow = signed_add > 127 || signed_add < -128;
			`ALU_UMT : arithmetic_overflow = unsigned_mul > 255;
			`ALU_SMT : arithmetic_overflow = signed_mul > 127 || signed_mul < -128;
			default  : arithmetic_overflow = 1'b0;
		endcase
	end
		
endmodule



