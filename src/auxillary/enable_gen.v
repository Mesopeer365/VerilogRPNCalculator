module enable_gen #(
	parameter ENABLE_CNT = 10
)
(
	input wire clk,
	input wire reset,
	input wire mode,
	output wire enable_out
);

	localparam size = $clog2(ENABLE_CNT) + 1; //number of bits needed
	
	wire [size-1:0] num_count;
	wire out_slow = (num_count == ENABLE_CNT);
	wire reset_counter = out_slow || !(reset);
	
	counter #(.n(size)) count(.clk(clk), .reset_counter(reset_counter), .in(1'b1), .out(num_count));
	
	assign enable_out = mode ? 1'b1 : out_slow;
	
endmodule 
	
	