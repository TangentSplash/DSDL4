//Main module

module Calculator(
    input newkey,			// High for one cycle during each new keypress
    input [4:0] keycode 	// Key pressed
    ); 

keypad_interpreter keypad_interpreter(.newkey(newkey),.keycode(keycode),.newhex(newhex),.hexcode(hexcode),.newop(newop),.opcode(opcode),.eq(eq));      )


endmodule