// modu1e to split keycode and newkey
// into useful outputs

module keypad_interpreter(
			  input		   newkey,  // High for one cycle during each new keypress
			  input [4:0]	   keycode, // Key pressed
			  output	   newhex,  // High when a hexidecimal number is pressed
			  output [3:0]	   hexcode, // The hexidecimal number currently pressed
			  output	   newop,   // High when an operator is pressed
			  output reg [1:0] opcode,  // Operator currently being pressed
			  output	   eq,      // Equals currently pressed
			  output	   BS,      // backspace currently pressed
			  output	   CA,      // CA key currently pressed
			  output	   CE       // CE key currently pressed
			  );      

   // Keypad Values
   // Settings for our keypad layout
   localparam [4:0]			   ADDKEY = 5'b01010;
   localparam [4:0]			   SUBKEY = 5'b00011;
   localparam [4:0]			   MULTKEY = 5'b00010;
   localparam [4:0]			   BACKKEY = 5'b00001;
   localparam [4:0]			   CAKEY = 5'b01001;
   localparam [4:0]			   CEKEY = 5'b01100;
   localparam [4:0]			   EQUALS = 5'b00100;
    
    //Opcode output Values
   localparam				   ADD =2'b00;
   localparam				   MULTIPLY = 2'b01 ;
   localparam				   SUBTRACT = 2'b10;

   // Control of eq output
   assign eq = (keycode==EQUALS)  && newkey;

   // Control of newop output
   // All operators feature a 1 as bit 4
   assign newop = newkey && !keycode[4] && (keycode[1]) ;

   // Contol of Control outputs
   assign BS = (keycode==BACKKEY) && newkey;
   assign CA = (keycode==CAKEY)   && newkey;
   assign CE = (keycode==CEKEY)   && newkey;

   // Control of newhex output
   // All hex keys feature a 1 as bit 1
   assign newhex =  (newkey && keycode[4]);

   // Control of keycode
   // All hex keys are last 4 bits of keycode
   assign hexcode = keycode[3:0];

   
   // Opcode output control
   always @ (keycode) begin
      
      case (keycode[4:0])
        ADDKEY:     opcode = ADD;
        MULTKEY:    opcode = MULTIPLY;
        SUBKEY:     opcode = SUBTRACT;
        default:     opcode = 2'b00;  //addition is default
      endcase
      
   end
   
endmodule
