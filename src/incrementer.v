module incrementer (
	input clk,
	input enabler,
	input reset,
	output [7:0] dout,
	output [5:0] gpo,
	output [7:0] ip
);

	reg [7:0] reg_dout;
	reg [5:0] reg_gpo;
	reg [7:0] reg_ip;
	
	initial begin
		reg_dout = 0;
		reg_gpo = 0;
		reg_ip = 0;
	end
	
	always @(posedge clk) begin
		if (enabler) begin
			reg_dout [7:0] = reg_dout [7:0] + 1'd1;
			reg_gpo [5:0] = reg_gpo [5:0] + 1'b1;
			reg_ip [7:0] = reg_ip [7:0] + 1'd1;
		end
	end
	
	assign dout = reg_dout;
	assign gpo  = (!reset) ? 7'b1111_111 : reg_gpo;
	assign ip   = reg_ip;
	
endmodule 