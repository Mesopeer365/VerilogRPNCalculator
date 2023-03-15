`include "./cpu/cpu_definitions/cpu_definitions.vh"
`default_nettype none
module instruction_memory (
	input wire [7:0] 	address,
	input 				non_signed,
	output reg [31:0] instruction
);

	always @(*)
		case (address)
			// Initialisation/reset
			0  : instruction = set(`GOUT, 0);
			1  : instruction = set(`SIZE, 0);
			2  : instruction = set(`FLAG, 0);
			3  : instruction = set(`DOUT, 0);
			4  : instruction = set(`DINP, 0);
			5  : instruction = jmp(`IP_WAIT_STRT);
			
			// Wait start
			6  : instruction = set(`GOUT, 128);
			7  : instruction = acc(`UAD, `REG, `SIZE, `GOUT);
			8  : instruction = 32'd0; // NOP
			9  : instruction = jmp(`IP_WAIT_PRSS);
			
			// Push
			10 : instruction = set(`GOUT, 0);
			11 : instruction = mov(`PUR, `REG, `DINP, `DOUT);
			12 : instruction = mov(`PUR, `REG, 8'd2, 8'd3);
			13 : instruction = mov(`PUR, `REG, 8'd1, 8'd2);
			14 : instruction = mov(`PUR, `REG, 8'd0, 8'd1);
			15 : instruction = mov(`PUR, `REG, `DOUT, 8'd0);
			16 : instruction = atc(`SHFT, 8'd17);
			17 : instruction = {`JMP, `EQ, `REG, `SIZE, `NUM, 8'd8, 8'd23};
			18 : instruction = {`JMP, `EQ, `REG, `SIZE, `NUM, 8'd0, 8'd21};
			19 : instruction = mov(`SHL, `REG, `SIZE, `SIZE);
			20 : instruction = jmp(`IP_WAIT_STRT);
			21 : instruction = set(`SIZE, 8'b0000_0001);
			22 : instruction = jmp(`IP_WAIT_STRT);
			23 : instruction = acc(`UAD, `NUM, 8'b0010_0000, `FLAG);
			24 : instruction = jmp(`IP_WAIT_STRT);
			
			// Pop
			25 : instruction = set(`GOUT, 0);
			26 : instruction = atc(`SHFT, 8'd27);
			
			// Semi pop
			27 : instruction = mov(`PUR, `REG,  8'd1, 8'd0);
			28 : instruction = mov(`PUR, `REG,  8'd2, 8'd1);
			29 : instruction = mov(`PUR, `REG,  8'd3, 8'd2);
			30 : instruction = mov(`PUR, `REG,  8'd0, `DOUT);
			31 : instruction = mov(`SHR, `REG, `SIZE, `SIZE);
			32 : instruction = {`JMP, `EQ, `REG, `SIZE, `NUM, 8'd0, 8'd34};
			33 : instruction = jmp(`IP_WAIT_STRT);
			34 : instruction = set(`DOUT, 0);
			35 : instruction = jmp(`IP_WAIT_STRT);
			
			// Signed addition
			36 : instruction = set(`GOUT, 0);
			37 : instruction = {`JMP, `ULE, `REG, `SIZE, `NUM, 8'd1, `IP_WAIT_STRT};
			38 : instruction = set(`FLAG, 0);
			39 : instruction = acc(`SAD, `REG, 8'd0, 8'd1);
			40 : instruction = jmp(`IP_SEMI_POP);
			
			// Signed multiplication
			41 : instruction = set(`GOUT, 0);
			42 : instruction = set(`FLAG, 0);
			43 : instruction = {`JMP, `ULE, `REG, `SIZE, `NUM, 8'd1, 8'd46};
			44 : instruction = acc(`SMT, `REG, 8'd0, 8'd1);
			45 : instruction = jmp(`IP_SEMI_POP);
			46 : instruction = set(8'd0, 0);
			47 : instruction = set(`DOUT, 0);
			48 : instruction = jmp(`IP_WAIT_STRT);
			
			// Unsigned addition
			49 : instruction = set(`GOUT, 0);
			50 : instruction = {`JMP, `ULE, `REG, `SIZE, `NUM, 8'd1, `IP_WAIT_STRT};
			51 : instruction = set(`FLAG, 0);
			52 : instruction = acc(`UAD, `REG, 8'd0, 8'd1);
			53 : instruction = jmp(`IP_SEMI_POP);
			
			// Unsigned multiplication
			54 : instruction = set(`GOUT, 0);
			55 : instruction = set(`FLAG, 0);
			56 : instruction = {`JMP, `ULE, `REG, `SIZE, `NUM, 8'd1, 8'd59};
			57 : instruction = acc(`UMT, `REG, 8'd0, 8'd1);
			58 : instruction = jmp(`IP_SEMI_POP);
			59 : instruction = set(8'd0, 0);
			60 : instruction = set(`DOUT, 0);
			61 : instruction = jmp(`IP_WAIT_STRT);
			
			// Push random value
			62 : instruction = set(`GOUT, 0);
			63 : instruction = mov(`PUR, `REG, `RAND, `DOUT);
			64 : instruction = jmp(`IP_KEY_PUSH + 8'd2);
			
			// Change the order
			65 : instruction = set(`GOUT, 0);
			66 : instruction = {`JMP, `ULE, `REG, `SIZE, `NUM, 8'd1, `IP_WAIT_STRT};
			67 : instruction = mov(`PUR, `REG, 8'd0, `DOUT);
			68 : instruction = mov(`PUR, `REG, 8'd1, 8'd0);
			69 : instruction = mov(`PUR, `REG, 8'd2, 8'd1);
			70 : instruction = mov(`PUR, `REG, 8'd3, 8'd2);
			71 : instruction = {`JMP, `EQ, `NUM, 8'b0000_0100, `REG, `SIZE, 8'd75};
			72 : instruction = {`JMP, `EQ, `NUM, 8'b0000_1000, `REG, `SIZE, 8'd77};
			73 : instruction = mov(`PUR, `REG, `DOUT, 8'd1);
			74 : instruction = jmp(8'd78);
			75 : instruction = mov(`PUR, `REG, `DOUT, 8'd2);
			76 : instruction = jmp(8'd78);
			77 : instruction = mov(`PUR, `REG, `DOUT, 8'd3);
			78 : instruction = mov(`PUR, `REG, 8'd0, `DOUT);
			79 : instruction = atc(`SHFT, 8'd80);
			80 : instruction = jmp(`IP_WAIT_STRT);
			
			// Turn off Shift and Arithmetic Overflow LEDs
			81 : instruction = set(`GOUT, 0);
			82 : instruction = set(`FLAG, 0);
			83 : instruction = jmp(`IP_WAIT_STRT);
			
			// Wait press loop
			84 : instruction = 32'd0;
			85 : instruction = atc(3'd3, `IP_KEY_PUSH);
			86 : instruction = atc(3'd2, `IP_KEY_POP );
			87 : 	if (!non_signed)		instruction = atc(3'd1, `IP_KEY_SADD);
					else if (non_signed)	instruction = atc(3'd1, `IP_KEY_UADD);
			88 : 	if (!non_signed)		instruction = atc(3'd0, `IP_KEY_SMLT);
					else if (non_signed)	instruction = atc(3'd0, `IP_KEY_UMLT);
			89 : instruction = jmp(`IP_WAIT_PRSS);
			
			// Wait hold loop
			90 : instruction = 32'd0;
			91 : instruction = atc(3'd3, `IP_KEY_RAND);
			92 : instruction = atc(3'd2, `IP_KEY_ORDR);
			93 : instruction = atc(3'd1, `IP_WAIT_PRSS);
			94 : instruction = atc(3'd0, `IP_KEY_CLOF);
			95 : instruction = jmp(`IP_WAIT_HOLD);
			
			default : instruction = jmp(`IP_WAIT_STRT);
		endcase
		
		// Move a value to a register
		function [31:0] mov;
			input [2:0] op;
			input arg1_type;
			input [7:0] arg1;
			input [7:0] reg_num;
			mov = {`MOV, op, arg1_type, arg1, `REG, reg_num, `N8};
		endfunction
		
		// Set a register to a value
		function [31:0] set;
			input [7:0] reg_num;
			input [7:0] value;
			set = {`MOV, `PUR, `NUM, value, `REG, reg_num, `N8};
		endfunction
		
		// Jump to an instruction pointer
		function [31:0] jmp;
			input [7:0] addr;
			jmp = {`JMP, `UNC, `N9, `N9, addr};
		endfunction
		
		// Atomic test and clear command
		function [31:0] atc;
			input [2:0] atc_bit;
			input [7:0] addr;
			atc = {`ATC, atc_bit, `N9, `N9, addr};
		endfunction
		
		// Perform an arithmetic operation
		function [31:0] acc;
			input [2:0] op;
			input num_type;
			input [7:0] num;
			input [7:0] reg_num;
			acc = {`ACC, op, num_type, num, `REG, reg_num, `N8};
		endfunction
		
endmodule 
