`timescale 1ns / 1ps
module TB_Registers;
	// Inputs to module being verified
	reg clock, reset, newhex, newop, eq;
	reg [3:0] hexcode;
	reg [15:0] answer;
	// Outputs from module being verified
	wire [15:0] V1_reg, V2_reg;
	// Instantiate module
	Registers uut (
		.clock(clock),
		.reset(reset),
		.newhex(newhex),
		.hexcode(hexcode),
		.newop(newop),
		.opcode(opcode),
		.eq(eq),
		.ans(ans),
		.V1_reg(V1_reg),
		.V2_reg(V2_reg)
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
			opcode = 2'h0;
			eq = 1'b0;
			ans = 16'h0;
			#250
			reset = 1'b1;
			#200
			reset = 1'b0;
			#400
			newhex = 1'b1;
			hexcode = 4'h5;
			#1900
			newhex = 1'b0;
			#100
			hexcode = 4'h0;
			#1200
			newhex = 1'b1;
			hexcode = 4'h4;
			#1700
			newhex = 1'b0;
			hexcode = 4'h0;
			#400
			newop = 1'b1;
			#800
			newop = 1'b0;
			#700
			hexcode = 4'h3;
			#100
			newhex = 1'b1;
			#1100
			newhex = 1'b0;
			#1000
			newhex = 1'b1;
			#1400
			newhex = 1'b0;
			#1200
			eq = 1'b1;
			#2800
			eq = 1'b0;
			#384750
			$stop;
		end
endmodule
