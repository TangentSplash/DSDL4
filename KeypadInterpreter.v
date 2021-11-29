module keypad_interpreter(
    input newkey,			// High for one cycle during each new keypress
    input [4:0] keycode, 	// Key pressed
    output newhex,          // High when a hexidecimal number is pressed
    output [3:0] hexcode,   // The hexidecimal number currently pressed
    output newop,            // High when an operator is pressed
    output [1:0] opcode, 	// Operator currently being pressed
    output eq,
    output BS
    );             // Equals is currently being pressed

    //Keypad Values
    localparam [4:0] ADDKEY = 5'b01001;
    localparam [4:0] SUBKEY = 5'b00001;
    localparam [4:0] MULTKEY = 5'b01010;
    localparam [4:0] BACKKEY = 5'b01011;
    localparam [4:0] CAKEY = 5'b00011;
    localparam [4:0] EQUALS = 5'b00100;
    
    //Opcode output Values
    localparam ADD =2'b00;
    localparam MULTIPLY = 2'b01 ;
    localparam SUBTRACT = 2'b10;

    assign eq = ((keycode==5'b00100) && newkey);
    assign newhex =  (newkey && keycode[4]);
    assign newop = newkey && !keycode[4] && (keycode[1:0]<3'b11) ;
    assign hexcode = keycode[3:0];
    assign BS = (keycode==BACKKEY);
    assign CA = (keycode==CAKEY);
    /*always @ (*) begin
        //Start as zero
        // ====== Binary 1 bit Outputs ======
         
         if ((keycode == 5'b00100) && newkey)
             eq = 1'b1;
         else
             eq = 1'b0;
         
        if ((keycode == 5'b00001) && newkey)
             BS = 1'b1;
         else
             BS = 1'b0;
        
         if(newkey)
         begin 
            if (keycode[4])
              begin
                   newhex = 1'b1;
                   newop = 1'b0;
                end
            else
              begin
                  newhex = 1'b0;
                  newop = 1'b1;
              end
         end
         else
         begin
            newhex = 1'b0;
            newop = 1'b0;
         end*/
 
        
    always @ (keycode)
    begin
        // ====== Opcode Output Control ======
        
        case (keycode[4:0])
            ADDKEY:     opcode = ADD;
            MULTKEY:    opcode = MULTIPLY;
            SUBKEY:     opcode = SUBTRACT;
            default:     opcode = 2'b00; // addition is default
        endcase
        
        // ====== Hexidecimal Output Control ======
        
        if (keycode[4])
             hexcode = keycode[3:0];
        else    
             hexcode = 4'b0000;
            
end
           
endmodule
