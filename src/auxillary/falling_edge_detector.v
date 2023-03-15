module falling_edge_detector #(
	parameter DEBOUNCE_TIME_ns = 30_000_000,
	parameter HOLD_TIME_ns = 1_500_000_000
) 
(input clk, in, output out_press, hold_indicator);
	
	// Detect button presses
	wire deb_in;
	debounce #(.DEBOUNCE_TIME_ns(DEBOUNCE_TIME_ns))
		deb(.clk(clk), .enable(1'b1), .resetn(1'b1), .sig_i(in), .sig_o(deb_in));

	reg prev_press; // Press state
	always @(posedge clk)
		prev_press <= deb_in;
	
	
	// Detect button holds
	wire done_hold;
	timer #(
		.TIMER_PERIOD_TYPE("ns"),
		.TIMER_PERIOD_ns(HOLD_TIME_ns)
	)
	timer_hold(
		.clk(clk),
		.enable(1'b1),
		.resetn(1'b1),
		.sync_resetn(deb_in),
		.start(deb_in),
		.done(done_hold)
	);

	reg hold_sig; // Hold state
	always @(posedge clk) begin
		if (done_hold) hold_sig <= done_hold;
		if (out_press) hold_sig <= 1'b0;
	end
	
	// Output logic (Mealy)
	assign hold_indicator = hold_sig;
	assign out_press = (prev_press && !deb_in);
	
endmodule 