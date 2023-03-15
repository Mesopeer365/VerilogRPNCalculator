//Definitions

// Command Groups
`define NOP 3'b000 // No Operation
`define JMP 3'b001 // Jump
`define ATC 3'b010 // Atomic Test and Clear
`define MOV 3'b011 // Move
`define ACC 3'b100 // Accumulate

//Jump Commands
`define UNC 3'b000 // Unconditional Jump
`define EQ  3'b010 // Jump On Equality
`define ULT 3'b100 // Jump On Unsigned Less Than
`define SLT 3'b101 // Jump On Signed Less Than
`define ULE 3'b110 // Jump On Unsigned Less Than Or Equal To
`define SLE 3'b111 // Jump On Signed Less Than Or Equal To

// Move Commands
`define PUR 3'b000 // Pure Move
`define SHL 3'b001 // Move and Shift Left
`define SHR 3'b010 // Move and Shift Right

//Accumulate Commands
`define UAD 3'b000 // Unsigned Addition
`define SAD 3'b001 // Signed Addition
`define UMT 3'b010 // Unsigned Multiplication
`define SMT 3'b011 // Signed Multiplication
`define AND 3'b100 // Bitwise AND
`define OR  3'b101 // Bitwise OR
`define XOR 3'b110 // Bitwise XOR

// Argument Types
`define NUM 1'b0 // Number Type
`define REG 1'b1 // Register Type

// Special Registers
`define SIZE 8'd4	 // Register Count Address
`define RAND 8'd5	 // Random Number Address
`define DINP 8'd28 // Data Input Register Address
`define GOUT 8'd29 // General Purpose Register Address
`define DOUT 8'd30 // Data Ouput Register Address
`define FLAG 8'd31 // Flag Register Address

//Flag Register Bits
`define SHFT 3'd5 // Shift
`define OFLW 3'd4 // Overflow
`define SMPL 3'd3 // Sample

// Other Useful Definitions
// Zeros
`define N8 8'd0
`define N9 9'd0


// Alu_op Commands
`define ALU_PUR 4'b0000 // Pure Move
`define ALU_SHL 4'b0001 // Move and Shift Left
`define ALU_SHR 4'b0010 // Move and Shift Right

`define ALU_UNC 4'b0011 // Unconditional Jump
`define ALU_EQ  4'b0100 // Jump On Equality
`define ALU_ULT 4'b0101 // Jump On Unsigned Less Than
`define ALU_SLT 4'b0110 // Jump On Signed Less Than
`define ALU_ULE 4'b0111 // Jump On Unsigned Less Than Or Equal To
`define ALU_SLE 4'b1000 // Jump On Signed Less Than Or Equal To

`define ALU_UAD 4'b1001 // Unsigned Addition
`define ALU_SAD 4'b1010 // Signed Addition
`define ALU_UMT 4'b1011 // Unsigned Multiplication
`define ALU_SMT 4'b1100 // Signed Multiplication
`define ALU_AND 4'b1101 // Bitwise AND
`define ALU_OR  4'b1110 // Bitwise OR
`define ALU_XOR 4'b1111 // Bitwise XOR


// Buttons
`define PUSH 2'd3 // Push key, key 3
`define POP  2'd2 // Pop key, key 2
`define ADD  2'd1 // Addition key, key 1
`define MULT 2'd0 // Multiplication key, key 0


// Instruction pointers
`define IP_WAIT_STRT 	8'd6	// Validate output and wait
`define IP_SEMI_POP  	8'd27	// Move stack down after operation
`define IP_KEY_PUSH		8'd10	// Move stack up and insert input
`define IP_KEY_POP		8'd25 //	Move stack down
`define IP_KEY_SADD		8'd36 //	Perform signed addition
`define IP_KEY_SMLT		8'd41 //	Perform signed multiplication
`define IP_KEY_UADD		8'd49 //	Perform unsigned addition
`define IP_KEY_UMLT		8'd54 //	Perform unsigned multiplication
`define IP_KEY_RAND		8'd62 //	Move stack up and insert a random value
`define IP_KEY_ORDR		8'd65 // Change order and move register 3 to the front
`define IP_KEY_CLOF		8'd81 // Clear overflow LEDs

`define IP_WAIT_PRSS 	8'd84	// Wait for button press
`define IP_WAIT_HOLD 	8'd90	// Wait for button hold
