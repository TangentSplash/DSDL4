`timescale 1ns / 1ns
module TB_Arth_module;
	// Inputs to module being verified
	reg clock, reset, newop;
	reg [15:0] V1, V2;
	reg [1:0] opcode;
	// Outputs from module being verified
	wire ovw;
	wire [15:0] answer;
	// Instantiate module
	Arth_module uut (
		.clock(clock),
		.reset(reset),
		.V1(V1),
		.V2(V2),
		.opcode(opcode),
		.newop(newop),
		.answer(answer),
		.ovw(ovw)
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
			reset = 1'b1;
			V1 = 16'd0;
			V2 = 16'd0;
			opcode = 2'b0;
			newop = 1'b0;
			#100
			reset = 1'b0;
			newop=1'b1;
			V1 = 16'd0;
			#100
			V2 = 16'd170;
			newop=1'b0;
			#100
			V1 = -16'd15;
			#200
			opcode = 2'b01;
			newop=1'b1;
			#400
			newop = 1'b0;
			#100
			V1 = 16'd14;
			#1300
			newop = 1'b0;
			#800
			V2 = 16'd13;
			#3300
			V1 = 16'd17;
			#1600
			V2 = -16'd20;
			#9700
			newop = 1'b1;
			#1300
			newop = 1'b0;
			#2100
			V1 = 16'd30;
			#500
			$stop;
		end
endmodule
