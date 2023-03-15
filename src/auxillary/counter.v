module counter #(parameter n=1)
	(input clk, reset_counter, in, output reg [n-1:0] out = 0);
	
	always @(posedge clk) begin
		if (reset_counter) out <= 0;
		else if (in) out <= out + 1'b1;
	end
endmodule 