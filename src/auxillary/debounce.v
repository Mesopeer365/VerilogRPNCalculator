module debounce #(
	parameter CLK_PERIOD_ns = 20,
	parameter DEBOUNCE_TIME_ns = 30_000_000
)
(
	input wire clk,
	input wire enable,
	input wire resetn,
	input wire sig_i,
	output wire sig_o
);

	localparam TIMER_ADJUST = DEBOUNCE_TIME_ns + CLK_PERIOD_ns; // Account for clock delays in FSM
	localparam ZERO_OFF = 2'b00, ZERO_ON = 2'b10; 
	localparam ONE_OFF = 2'b01, ONE_ON = 2'b11;
	
	wire sync_i;
	synchroniser sync(.clk(clk), .in_data(sig_i), .sync_data(sync_i));
	
	reg [1:0] state = ZERO_ON;
	reg [1:0] next_state;
	
	wire timer_resetn;
	wire timer_start;
	wire done;
	
	
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= ZERO_ON;
		end 
		
		else begin
		
			if (enable) begin
				case(state) //FSM
					ZERO_OFF : next_state = done ? ZERO_ON : (sync_i ? ONE_ON : ZERO_OFF);
					ZERO_ON  : next_state = sync_i ? ONE_OFF : ZERO_ON;
					ONE_OFF  : next_state = done ? ONE_ON : (sync_i ? ONE_OFF : ZERO_ON);
					ONE_ON   : next_state = sync_i ? ONE_ON : ZERO_OFF;
					default  : next_state = ZERO_ON;
				endcase
				
				state <= next_state;
			end
			
		end
	end
	
	
	// Control the timer by checking current state of FSM
	assign timer_resetn = !((state == ZERO_ON) || (state == ONE_ON));
	assign timer_start = !done && ((state == ZERO_OFF) || (state == ONE_OFF));
	assign sig_o = (state == ZERO_OFF) || (state == ONE_ON); // output depends on current state
	
	timer #(
		.CLK_PERIOD_ns(CLK_PERIOD_ns),
		.TIMER_PERIOD_TYPE("ns"),
		.TIMER_PERIOD_ns(TIMER_ADJUST)
	)
	
	timer_inst (
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.sync_resetn(timer_resetn),
		.start(timer_start),
		.done(done)
	);
	
endmodule 