`timescale 1ns / 1ps
module TB_Registers;
	// Inputs to module being verified
	reg clock, reset, newhex, newop, eq, BS;
	reg [3:0] hexcode;
	reg [16:0] answer;
	// Outputs from module being verified
	wire [16:0] V1curr, V2curr;
	// Instantiate module
	Registers uut (
		.clock(clock),
		.reset(reset),
		.newhex(newhex),
		.hexcode(hexcode),
		.newop(newop),
		.eq(eq),
		.BS(BS),
		.answer(answer),
		.V1curr(V1curr),
		.V2curr(V2curr)
		);
	// Generate clock signal
	initial
		begin
			clock  = 1'b1;
			forever
				#100 clock  = ~clock ;
		end
	// Generate other input signals
	initial
		begin
			reset = 1'b0;
			newhex = 1'b0;
			hexcode = 4'h0;
			newop = 1'b0;
			eq = 1'b0;
			BS = 1'b0;
			answer = 17'h0;
			#200
			reset = 1'b1;
			#200
			reset = 1'b0;
			#200
			newhex = 1'b1;
			hexcode = 4'h3;
			#200
			newhex = 1'b0;
			#400
			newhex = 1'b1;
			hexcode = 4'h2;
			#200
			newhex = 1'b0;
			hexcode = 4'h0;
			#400
			newop = 1'b1;
			#200
			newop = 1'b0;
			#400
			newhex = 1'b1;
			hexcode = 4'h1;
			#200
			newhex = 1'b0;
			#600
			newhex = 1'b1;
			#200
			newhex = 1'b0;
			hexcode = 4'h0;
			#400
			eq = 1'b1;
			answer = 17'h1A;
			#200
			eq = 1'b0;
			#1000
			newhex = 1'b1;
			hexcode = 4'h5;
			#200
			newhex = 1'b0;
			hexcode = 4'h0;
			#400
			newhex = 1'b1;
			#200
			newhex = 1'b0;
			hexcode = 4'h0;
			#400
			BS = 1'b1;
			#200
			BS = 1'b0;
			#435
			newop = 1'b1;
			#200
			$stop;
		end
endmodule