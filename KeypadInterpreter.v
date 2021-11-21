module keypad_interpreter(
    input newkey,			// High for one cycle during each new keypress
    input [4:0] keycode, 	// Key pressed
    output newhex.          // High when a hexidecimal number is pressed
    output [3:0] hexcode,   // The hexidecimal number currently pressed
    output newop,            // High when an operator is pressed
    output[1:0] opcode, 	// Operator currently being pressed
    output eq);             // Equals is currently being pressed

    //Keypad Values
    localparam [4:0] EQUALS = 5'b00100;
    localparam [3:0] ADDKEY= 4'b1011;
    localparam [3:0] MULTKEY =4'b1011;

    //Output Values
    localparam ADD =2'b00;
    localparam MULTIPLY = 2'b01 ;

    always @ (newkey)
    begin
        //Start as zero
        eq <= 1'b0;
        newhex <= 1'b0;
        newop <= 1'b0;

        if (kecode == EQUALS)
            eq <= 1'b1;
        else if (keycode[3])
            newhex <= 1'b1;
        else
            newop <= 1'b1;

        case (keycode[3:0])
            ADDKEY:     opcode <= ADD;
            MULTKEY:    opcode <= MULTIPLY;
            default:    opcode <= 2'b11;
        endcase
    end
endmodule