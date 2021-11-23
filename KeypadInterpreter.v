module keypad_interpreter(
    input newkey,			// High for one cycle during each new keypress
    input [4:0] keycode, 	// Key pressed
    output newhex,          // High when a hexidecimal number is pressed
    output [3:0] hexcode,   // The hexidecimal number currently pressed
    output newop,            // High when an operator is pressed
    output[1:0] opcode, 	// Operator currently being pressed
    output eq);             // Equals is currently being pressed

    //Keypad Values
    localparam [4:0] EQUALS = 5'b00100;
    localparam [4:0] ADDKEY= 5'b01010;
    localparam [4:0] MULTKEY = 5'b00010;
    localparam [4:0] SUBKEY = 5'b00011;

    //Output Values
    localparam ADD =2'b00;
    localparam MULTIPLY = 2'b01 ;
    localparam SUBTRACT = 2'b10;

    always @ (newkey)
    begin
        //Start as zero
        // ====== Binary 1 bit Outputs ======
        eq <= 1'b0;
        newhex <= 1'b0;
        newop <= 1'b0;

        if (kecode == EQUALS)
            eq <= 1'b1;
        else if (keycode[4]) // all keycodes begin with a 1
            newhex <= 1'b1;
        else
            newop <= 1'b1;

        // ====== Opcode Output Control ======
        
        case (keycode[4:0])
            ADDKEY:     opcode <= ADD;
            MULTKEY:    opcode <= MULTIPLY;
            SUBKEY:     opcode <= SUBTRACT;
            default:    opcode <= 2'b00; // addition is default
        endcase
        
        // ====== Hexidecimal Output Control ======
        
        if (keycode[4])
            hexcode <= keycode[3:0];
        else    
            hexcode <= 4'b0000
            
    end
endmodule
