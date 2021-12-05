// arithmetic modu1e
module Arth_module(
		   input	 clock,
		   input	 reset,
		   input [16:0]	 V1,     // as sign and magnitude
		   input [16:0]	 V2,     // as sign and magnitude
		   input [1:0]	 opcode, // code for new operator
		   input	 newop,  // new operator pressed
		   input	 newhex, // new  hexcode coming in
		   input	 eq,     // equals key pressed
		   output [16:0] answer, // Sign and magnitude
		   output	 ovw_out // an overflow detected
		   );

   reg [1:0]			 operator_curr; // Register to store operator  
   reg [16:0]			 Ianswer;       // Register for internal answer
   wire signed [16:0]		 add, subtract; // wires for operation result
   wire [16:0]			 multiply;      // Multiplication is unsigned
   wire signed [16:0]		 V1_2c, V2_2c;  
  
   reg				 ovw;           // Internal overflow register
   reg				 omode_next;    // [ OverflowMode register
   reg				 omode_curr;    // to check if equals has been pressed ]
   wire				 ovwa,ovws;     // internal wire for add/sub overflows
   wire [15:0]			 multextra;     // Extra bits to capture possible multiplication overflow
   wire				 ovwm = |multextra; // If any of these bits are non-zero there has been a multiplication overflow
   
   wire signed [16:0]		 nadd, nsubtract;
    
   // [ Convert to 2's complement by checking sign bit, 
   //   if it is 1 take the number to be minus the unsigned magnitude, 
   //   otherwise take the unsigned magnitude ]    
   assign V1_2c= V1[16] ? -$signed({1'b0,V1[15:0]}) : $signed(V1);
   assign V2_2c = V2[16] ? -$signed({1'b0,V2[15:0]}) : $signed(V2); 

   // ===== Main Register Control =====
   // For assigning values of omode, ovw and operator registers
   always @ (posedge clock) begin
      
      if (reset) begin  // [ In the case of a reset
	                //   all values set to zero ]
         operator_curr <= 2'b00;
         omode_curr <= 1'd0;
         ovw <= 1'b0;
         
      end else begin    // normal (non-rst) operation
         
	 // oVERFLOWmode register control
	 omode_curr <= omode_next; // [ omode overwritten by
	                           //   omode_next (assigned
	                           //    elsewhere) ]

	 // Operator register control
         if (newop) operator_curr <= opcode;
         else       operator_curr <= operator_curr;

	 // Overflow register control
	 // [ A different type of overflow, e.g. an multiplication
	 //   overflow may be present during an addtion operation,
	 //   this ensures the right overflow wire is connected
	 //   to the overflow register ]
         
	 if (newop || newhex) ovw <= 1'b0; // newop or newhex end the overflow

	 // Assign the correct overflow if one occurs
	 else if (ovwa | ovwm | ovws)  
           case (operator_curr) 
             2'b00:   ovw <= ovwa; // Calculation overflowed if addition overflowed
             2'b01:   ovw <= ovwm; // Did multiplication overflow?
             2'b10:   ovw <= ovws; // Did subtraction overflow
             default: ovw <= 1'b1; // Should not have invalid operator, show an overflow error
           endcase 

	 // If nothing touched, the overflow will stay for many clock cycles
	 else ovw <= ovw;
	 
      end
   end // End of main register control;




   
   // ===== Arithmetic blocks =====

   // Addition block 
   assign add = V1_2c+V2_2c;       // standard addition
   assign nadd= -add;              // negative add wire
   assign ovwa=((V1_2c[16]&V2_2c[16])&!(add[16])) || ((!V1_2c[16]&!V2_2c[16])&add[16]); // addition overflow 
   // [ Addition overflow if add a positive to a positive and get a negative,
   //   or add a negative to a negative and get a positive ] 

   // Subtraction block
   assign subtract = V2_2c-V1_2c;  // standard subtraction
   assign nsubtract = -subtract;   // negative subraction wire
   assign ovws=((V2_2c[16]&!V1_2c[16])&!(subtract[16])) || ((!V2_2c[16]&V1_2c[16])&subtract[16]); // sub overflow
   // [ Subtraction overflow if subtract a negative from a positive and get a negative, 
   //   or subtract a positive from a negative and get a positive ] 

   // Multiplication block
   assign {multextra,multiply[15:0]}=V1[15:0]*V2[15:0];   // Multiply the magnitudes
   assign multiply[16]=V1[16]^V2[16];                     // XOR the sign bits



   
   // =====Interal answer assignment=====
   // One of three results chosen depending on operator
   always @ ( * ) 
     case (operator_curr)    //Answer depends on the selected operator

       // Addition
       2'b00:   Ianswer = add[16] ? {1'b1,nadd[15:0]}: $unsigned(add);  
       // [ Convert back to sign and magnitude. If 2's complement is negative, 
       //   set sign bit to 1 and set magnitude to negative of the remaining bits ]

       // Multiplication
       2'b01:   Ianswer = multiply;

       // Subtraction
       2'b10:   Ianswer = subtract[16] ? {1'b1,nsubtract[15:0]} : $unsigned(subtract);  
       // [ If 2's complement is negative, set sign bit to 1 and 
       //   set magnitude to negative of the remaining bits ]
       
       default: Ianswer = 16'd0;
       // default case displays zeroes
       // (this should never happen)
       
     endcase 

   // ===== Control of Next OverflowMode =====
   // [ Overflow mode ensures overflow only displayed
   //   after equals is pressed and disappears if
   //   another key is pressed ]
   
   always @ ( * ) begin
   
      if (newhex || newop)             omode_next <= 1'b0;
      // another keypress kills the overflow
      
      else if (eq)                     omode_next <= 1'b1;
      // only once equals is pressed can overflow show
      
      else                             omode_next <= omode_curr;
      // overflow mode will stay as long as necessary
   
   end
   
   // ===== Final overflow control =====
   
   assign answer = ovw ? 16'd0 : Ianswer;
   // an overflow will display zereos on screen
   
   assign ovw_out = omode_curr && ovw;
   // overflow only visible when overflowmode is one
   
endmodule
