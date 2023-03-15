`default_nettype none
`include "./cpu/cpu_definitions/cpu_definitions.vh"

module soc #(
	parameter DEBOUNCE_TIME_ns = 30_000_000 //for testing purposes
)
(
    input   wire        clk,
    input   wire        resetn,  
    input   wire        turbo_mode,
    
    // GPIO
    input   wire [3:0]  gpi,
    output  wire [5:0]  gpo,
    
    // Data Bus
    input   wire [7:0]  din,
    output  wire [7:0]  dout,
    output  wire        dval, 
    
    output  wire [3:0]  debug,
    output  wire [7:0]  ip,
	 output  wire        non_signed
);

	wire [31:0] instruction;
	wire [7:0] gout;
	wire [7:0] flag;

	
	//Synchronise, debounce and detect falling edge of inputs
	
	//Switches
	wire [7:0] dsync;
	genvar i_SW;
	generate
		for (i_SW=0; i_SW<8; i_SW=i_SW+1) begin:SW_loop
			synchroniser sync_SW(.clk(clk), .in_data(din[i_SW]), .sync_data(dsync[i_SW]));
		end
	endgenerate
	
	wire deb_resetn;
	debounce #(.DEBOUNCE_TIME_ns(DEBOUNCE_TIME_ns)) 
		deb_reset(.clk(clk), .enable(1), .resetn(1), .sig_i(resetn), .sig_o(deb_resetn));
	
	wire deb_turbo_mode;
	debounce #(.DEBOUNCE_TIME_ns(DEBOUNCE_TIME_ns)) 
		deb_turb(.clk(clk), .enable(1), .resetn(deb_resetn), .sig_i(turbo_mode), .sig_o(deb_turbo_mode));
	
	
	//Keys
	wire [3:0] gpi_sync;
	wire [3:0] gpi_fall;
	wire [3:0] hold_indicator;
	wire		  gpi_hold = (hold_indicator != 4'd0);
	
	genvar i_KEY;
	generate
		for (i_KEY=0; i_KEY<4; i_KEY=i_KEY+1) begin:KEY_loop
			synchroniser sync_KEY(.clk(clk), .in_data(gpi[i_KEY]), .sync_data(gpi_sync[i_KEY]));
			
			falling_edge_detector #(.DEBOUNCE_TIME_ns(DEBOUNCE_TIME_ns))
				fall(.clk(clk), 
					.in(gpi_sync[i_KEY]), 
					.out_press(gpi_fall[i_KEY]), 
					.hold_indicator(hold_indicator[i_KEY])
				);
		end
	endgenerate
	
	//Enable signal
	wire enabler;
	enable_gen #(2**23) 
	enable(.clk(clk), .reset(deb_resetn), .mode(deb_turbo_mode), .enable_out(enabler));	
	
	
	//Input values
	reg [7:0] din_reg;
	always @(posedge clk or negedge deb_resetn)
		if (!deb_resetn)
			din_reg <= 8'd0;
		else if (gpi_fall[3] && gout[7])
			din_reg <= dsync;
	
	
	
	//Instantiation of cpu and rom
	
	instruction_memory rom (
		.address(ip), 
		.instruction(instruction),
		.non_signed(non_signed)
	);
	
	cpu core (
		.clk(clk),
		.enable(enabler),
		.resetn(deb_resetn),
		.instruction(instruction),
		.din(din_reg),
		.gpi(gpi_fall),
		.gpi_hold(gpi_hold),
		.reg_flag(flag),
		.instruction_pointer(ip),
		.reg_dout(dout),
		.reg_gout(gout),
		.non_signed(non_signed)
	);
	
	
	
	//Assign outputs
	assign dval = gout[7];
	assign debug[3] = enabler;
	assign debug[2] = flag[`SHFT];
	assign debug[1] = flag[`OFLW];
	assign debug[0] = gpi_hold;
	assign gpo[5:0] = gout[5:0];
	
	
endmodule 