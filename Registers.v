// Registers Module for storing Data
module Registers(
    input		     clock,
    input		     reset,
    input		     newhex,    // High when a hexidecimal number is pressed
    input [3:0]		     hexcode,   // The hexidecimal number currently pressed
    input		     newop,     // High when an operator is pressed
    input		     eq,        // Equals is currently being pressed
    input		     BS,        // Backspace key
    input		     CE,        // Clears V1 register
    input signed [16:0]	     answer,    // Sign and magnitude
    output reg signed [16:0] V1curr,    // Sign and magnitude
    output reg signed [16:0] V2curr     // Sign and magnitude
		 );              

   reg signed [16:0]	     V1next;    // Sign and magnitude
   reg			     FLOWMODEcurr, FLOWMODEnext;      
   // [ FLOWMODE Register for choosing whether 
   //   V1 will be shifted or overwritten  ] 

   wire [16:0]		     overwrite; // [ Overwrite wire concatenates input
   assign overwrite = {13'd0, hexcode}; //   hexcode with zeroes ]
    
   // Main register Control
   // Assigns the next vaule to all registers
   always @ (posedge clock) begin
	
	if (reset) begin        // Condition if Reset is pressed  
           V1curr <= 17'd0;     // All registers set to 0
           V2curr <= 17'd0;
           FLOWMODEcurr <=1'b0;
	   
        end else
	  
          if (CE) begin         // Condition if CE pressed
             V1curr <= 17'd0;   // Only V1 set to zero
             
	  end else begin        // Condition if neither CE or Reset
             
	     V1curr <= V1next;// [ V1 and Flowmode set to next value
             FLOWMODEcurr <= FLOWMODEnext;  // (Assigned elsewhere) ]
	     
	     if (newop)       // [ In the case of a new operator
               V2curr <= V1curr;// V2 copies V1 value ] 
             else
               V2curr <= V2curr;// if no "newop", V2 is unchanged
             
	  end // else: !if(CE)
      
   end // end of main register control

   
   // Flow Mode Control Module
   // Assigns the next vaule of Flowmode
   
   // [ A flowmode of 0 means the next hexcode will
   //   appear at the rightmost side of the current 
   //   contents of V1, while 1 means that the contents
   //   will be overwritten ]
   always @ ( * ) begin
      
      if (newhex)             FLOWMODEnext = 1'b0; // A New character resets Flowmode 
      
      else if (eq | newop)    FLOWMODEnext = 1'b1; // [ An "=" or newop means that the
                                                   //   next hexcode will overwrite V1 ]
      else                    FLOWMODEnext = FLOWMODEcurr; // [ otherwise, flowmode will stay
                                                           //   for as many cycles as needed ]
   end // end of Flow Mode Control Module
   
   // V1 Control Module
   // Assigns the next value of V1 register
   always @ ( * ) begin
        
      if ( eq | newhex | BS ) begin // V1 only changes when one of these 3 pressed
   
	 if (eq)                             V1next = answer;    // Equals stores the result in V1
	 
         else if (FLOWMODEcurr && newhex)    V1next = overwrite; // [ Overwrite if a new charachter is
	                                                         //   entered and flowmode is 1 ]   
	 else if (BS)                        V1next = {4'b0, V1curr[15:4]}; // shifting right is backspace
         
	 else                                V1next = {V1curr[16],V1curr[11:0], hexcode}; 
	                                              // Shift left and add new digit by default
      end else
      
	V1next = V1curr;  // otherwise, V1 will remain unchanged
   
   end // end of V1 control module
   
endmodule
