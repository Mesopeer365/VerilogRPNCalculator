`timescale  1ns/1ps
module test_cpu_early_stage;
	reg clk, resetn;
	reg [7:0] din;
	reg [3:0] gpi;
	wire [7:0] dout, ip;
	
	soc #(.DEBOUNCE_TIME_ns(0)) 
	run(.clk(clk), .resetn(!resetn), .turbo_mode(1), .din(din), .gpi(gpi), .dout(dout), .ip(ip));
	
	initial begin
		clk = 0;
		repeat (200) #10 clk = !clk;
	end
	
	initial begin
		resetn = 0; din = 8'd255;
		#160
		repeat(40) #20 $strobe("instruction pointer is %2h, displayed number is %4d", ip, $signed(dout));
	end
	
	initial begin
		gpi = 4'b1000;
		#200 gpi = 4'b0000;
	end
	
endmodule 