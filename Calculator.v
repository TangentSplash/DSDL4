//Main module
module Calculator(
    input clock,
    input reset,
    input newkey,			// High for one cycle during each new keypress
    input [4:0] keycode 	// Key pressed
    ); 

wire newhex,newop,eq;
wire [3:0] hexcode;
wire [1:0] opcode;
wire [16:0] ans,V1,V2;  //16 bit numbers with 16th bit representing sign
wire ovw;

keypad_interpreter keypad_interpreter(.newkey(newkey),.keycode(keycode),.newhex(newhex),.hexcode(hexcode),.newop(newop),.opcode(opcode),.eq(eq));
Registers registers(.clock(clock),.reset(reset),.newhex(newhex),.hexcode(hexcode),.newop(newop),.eq(eq),.answer(ans),.V1curr(V1),.V2curr(V2));
  Arth_module arethmeic(.clock(clock),.reset(reset),.V1(V1),.V2(V2),.opcode(opcode),.newop(newop),.answer(ans),.ovw(ovw));
endmodule