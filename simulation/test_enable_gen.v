`timescale  1ns/1ps

module test_enable_gen;
	reg clk, mode;
	wire enable_out;
	
	enable_gen #(.ENABLE_CNT(5)) enable(.clk(clk), .reset(1'b1), .mode(mode), .enable_out(enable_out));
	
	initial begin
		clk=0;
		repeat (50) #10 clk=!clk;
	end
	
	initial begin
		mode=0; 
		repeat(15) #20 $display("enable is %b", enable_out);
		
		#10 mode=1; $display("turbo mode on");
		
		repeat(6) #20 $display("enable is %b", enable_out);
		
	end
	
endmodule 