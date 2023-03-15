module synchroniser (
	input clk,
	input in_data,
	output reg sync_data
);

	reg half_sync_data = 0;

	always @(posedge clk) begin
		half_sync_data <= in_data;
		sync_data <= half_sync_data;
	end
		
endmodule 