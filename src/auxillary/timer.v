`default_nettype none
module timer #(
	parameter CLK_PERIOD_ns = 20, // nanoseconds.
	parameter TIMER_PERIOD_ms = 25, // milliseconds.
	parameter TIMER_PERIOD_us = 25_000, // microseconds.
	parameter TIMER_PERIOD_ns = 25_000_000, //nanoseconds
	parameter TIMER_PERIOD_TYPE = "ms"
)
(
	input wire clk,
	input wire enable,
	input wire resetn,
	input wire sync_resetn,
	input wire start,
	output wire done
);

	localparam TIMER_PERIOD = get_timer_period(TIMER_PERIOD_TYPE);
	localparam MULTIPLIER = get_multiplier(TIMER_PERIOD_TYPE);
	localparam MAX_COUNT = (TIMER_PERIOD * MULTIPLIER / CLK_PERIOD_ns); //Default type of 32-bits.
	
	localparam
	IDLE = 0,
	COUNTING_DOWN = 1,
	STOPPED = 2;
	
	timer_base #(
		.MAX_COUNT(MAX_COUNT)
	)
	timer_inst (
		.clk(clk),
		.enable(enable),
		.resetn(resetn),
		.sync_resetn(sync_resetn),
		.start(start),
		.done(done)
	);
	
	function [31:0] get_timer_period(
		input [15:0] type_str
		);
		case (type_str)
			"ms" : get_timer_period = TIMER_PERIOD_ms;
			"us" : get_timer_period = TIMER_PERIOD_us;
			"ns" : get_timer_period = TIMER_PERIOD_ns;
		default : get_timer_period = TIMER_PERIOD_ms;
		endcase
	endfunction
	
	function [31:0] get_multiplier(
		input [15:0] type_str
	);	
		case (type_str)
			"ms" : get_multiplier = 1_000_000;
			"us" : get_multiplier = 1_000;
			"ns" : get_multiplier = 1;
			default : get_multiplier = 1_000_000;
		endcase
	endfunction
	
endmodule


module timer_base #(
	parameter MAX_COUNT = 10
)
(
	input  wire clk,
	input  wire enable,
	input  wire resetn,
	input  wire sync_resetn,
	input  wire start,
	output reg done
);

	localparam COUNTER_BITS = $clog2(MAX_COUNT); // Calculate actual bit width needed.
	
	// States
	localparam
		IDLE          = 2'b00,
		COUNTING_DOWN = 2'b01,
		STOPPED       = 2'b10;
	
	reg [1:0] state = IDLE;
	reg [COUNTER_BITS : 0 ] count = MAX_COUNT-1'b1;
	
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= IDLE;
			count <= MAX_COUNT;
		end
		else if (enable) begin
			if (!sync_resetn) begin
				state <= IDLE;
				count <= MAX_COUNT - 1'b1;
			end else begin
				// FSM Logic
				case (state)
					IDLE:
						if (start)
							state <= COUNTING_DOWN;
						else
							state <= IDLE;
					
					COUNTING_DOWN:
						if (count == 0)
							state <= STOPPED;
						else
							state <= COUNTING_DOWN;
					
					STOPPED:
						if (start)
							state <= COUNTING_DOWN;
						else
							state <= IDLE;
					
					default:
						state <= IDLE;
				
				endcase
			
				// Counter Logic
				if (state == COUNTING_DOWN)
					count <= count - 1'b1;
				else if (state == STOPPED)
					count <= MAX_COUNT - 2'd2; // Account for loss of cycle if moving back to count down
				else
					count <= MAX_COUNT - 1'b1;
					
			end
		end
	end
	
	always@(*) done = (state == STOPPED);
	
endmodule

