//Main module
module Calculator(
    input clock,
    input reset,
    input newkey,			// High for one cycle during each new keypress
    input [4:0] keycode 	// Key pressed
    ); 

wire newkey,newhex,newop,eq;
wire [3:0] hexcode;
wire [1:0] opcode;
wire [15:0] ans,V1,V2;

keypad_interpreter keypad_interpreter(.newkey(newkey),.keycode(keycode),.newhex(newhex),.hexcode(hexcode),.newop(newop),.opcode(opcode),.eq(eq));
Regisers registers(.clock(clock),.reset(reset),.newhex(newhex),.hexcode(hexcode),.newop(newop),.opcode(opcode),.eq(eq),.ans(ans),.V1_reg(V1),.V2_reg(V2));
  Arth_module arethmeic(.clock(clock),.reset(reset),.V1(V1),.V2(V2),.opcode(opcode),.newop(newop),.ans(ans));
endmodule