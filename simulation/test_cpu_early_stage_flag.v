`timescale  1ns/1ps
module test_cpu_early_stage_flag;
	reg clk, resetn;
	wire [7:0] dout, ip;
	
	soc #(.DEBOUNCE_TIME_ns(0)) cpu(.clk(clk), .resetn(!resetn), .turbo_mode(1), .dout(dout), .ip(ip));
	
	initial begin
		clk = 0;
		repeat (200) #10 clk = !clk;
	end
	
	initial begin
		resetn = 0;
		#200
		repeat(40) #20 $strobe("instruction pointer is %2h, flag is %8b", ip, dout);
	end
	
endmodule 