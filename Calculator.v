//Main module
module Calculator(
    input clock,
    input reset,
    input newkey,			    // High for one cycle during each new keypress
    input [4:0] keycode, 	// Key pressed
    output [15:0] value,
    output ovw,
    output sign 
    ); 

wire newhex,newop,eq;
wire [3:0] hexcode;
wire [1:0] opcode;
wire [16:0] ans,V1,V2;  //17 bit sign and magnitude integers with 17th bit representing sign
wire BS;

assign value = V1[15:0];  //Magnitude of V1 given in first 16 bits
assign sign = V1[16];     //Sign is the 17th bit of V1

keypad_interpreter keypad_interpreter(.newkey(newkey),.keycode(keycode),.newhex(newhex),.hexcode(hexcode),.newop(newop),.opcode(opcode),.eq(eq),.BS(BS));
Registers registers(.clock(clock),.reset(reset),.newhex(newhex),.hexcode(hexcode),.newop(newop),.eq(eq),.answer(ans),.V1curr(V1),.V2curr(V2),.BS(BS));
Arth_module arethmeic(.clock(clock),.reset(reset),.V1(V1),.V2(V2),.opcode(opcode),.newop(newop),.answer(ans),.ovw(ovw));

endmodule
