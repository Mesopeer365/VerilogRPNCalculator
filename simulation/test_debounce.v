`timescale  1ns/1ps

module test_debounce;
	reg in, clk, resetn;
	wire out;
	
	reg enable = 1;
	
	debounce deb(.clk(clk), .enable(enable), .resetn(resetn), .sig_i(in), .sig_o(out));
	
	initial begin
		clk=0;
		repeat(3_200_000) #10 clk=!clk;
	end
	
	initial begin
		resetn = 0; in = 0;
		#30 resetn = 1;
			$strobe("After not pressing       , out is %b", out);
		
		#50 in = 1;
			$strobe("After pressing for   0 ns, out is %b", out);
		
		#1_000 in = 0;
			$strobe("After pressing for   1 us, out is %b", out);
			
		#50 in = 1;
		
		#30_000_000
			$strobe("After pressing for  30 ms, out is %b", out);
		
		#0_000_041 in = 0;
			$strobe("After pressing for  30 ms + 41 ns, out is %b", out);
			
		#0_000_059 
			$strobe("After releasing button for 59 ns, out is %b", out);

			
	end
	
endmodule
	
	