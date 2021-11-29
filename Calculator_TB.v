`timescale 1ns / 1ps
module TB_Calculator;
   // Inputs to modu1e being verified
   reg clock, reset, newkey;
   reg [4:0] keycode;
   // Outputs from modu1e being verified
   wire	     ovw, sign;
   wire [15:0] value;
   // Instantiate module
   Calculator uut (
		   .clock(clock),
		   .reset(reset),
		   .newkey(newkey),
		   .keycode(keycode),
		   .ovw(ovw),
		   .sign(sign),
		   .value(value)
		   );
   // Generate clock signal
   initial
     begin
	clock  = 1'b1;
	forever
	  #100 clock  = ~clock ;
     end
   // Generate other input signals
   initial
     // Init and reset
     begin
	reset = 1'b0;
	newkey = 1'b0;
	keycode = 5'b0;
	
	#150
	  reset = 1'b1;
	#200
	  reset = 1'b0;
	// #200 means wait 1 clock cycle

	// addition 3+2 (5) then add 5 (A)

	// 3
	#650  
	  newkey = 1'b1;
	keycode = 5'b10011;
	#200 
	  newkey = 1'b0;
	keycode = 5'b00000;

	// +
	#1000 
	  newkey = 1'b1;
	keycode = 5'b01010;
	#200
	  newkey = 1'b0;
	keycode = 5'b00000;

	// 2
	#1000                                                                                                                                          
          newkey = 1'b1;
        keycode	= 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =
	#1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// +
	#1000
          newkey = 1'b1;
        keycode = 5'b01010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 5
	#1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =
	#1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// addition 3B + 23 (should be 5E)

	// 3
	#2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// B
	#1000
          newkey = 1'b1;
        keycode = 5'b11011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// +                                                                                                                                               
        #1000
          newkey = 1'b1;
        keycode = 5'b01010;
        #200
          newkey = 1'b0;
	keycode = 5'b00000;

	// 2                                                                                                                         
        #1000
          newkey = 1'b1;
        keycode = 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 3                                                                                                                                                   
        #1000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =
	#1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;
	
	// addtion 3B + F2 (should overflow (12D))
	
	// 3 
	#2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // B
	#1000
          newkey = 1'b1;
        keycode = 5'b11011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // +
	#1000
          newkey = 1'b1;
        keycode = 5'b01010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// F
	#1000
	  newkey = 1'b1;
	keycode = 5'b11111;
	#200
	  newkey = 1'b0;
	keycode = 5'b00000;
	
	// 2
        #1000
          newkey = 1'b1;
        keycode = 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// = 
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// multiplication 3x2 (6) x 5 (1E)

        // 3
        #2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// x
	#1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 2
        #1000
          newkey = 1'b1;
        keycode = 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // = 
	#1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// x
	#1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 5
        #1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// multiplication 11xC (should be CC)

	// 1
	#2000
          newkey = 1'b1;
        keycode = 5'b10001;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 1
	#1000
          newkey = 1'b1;
        keycode = 5'b10001;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// x
        #1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// C
        #1000
          newkey = 1'b1;
        keycode = 5'b11100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	
	// mult 3B x F (should overflow (375))

	// 3
        #2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// B
        #1000
          newkey = 1'b1;
        keycode = 5'b11011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// X
        #1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // F
	#1000
          newkey = 1'b1;
        keycode = 5'b11111;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// subt 3 - 2

	// 3
	#2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
	keycode = 5'b00000;

	// -
        #1000
          newkey = 1'b1;
        keycode = 5'b00011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 2
	#1000
          newkey = 1'b1;
        keycode = 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// = 
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;


	//subt 3B - F2 (-B7) -F@ (should underflow (-1A9))
	       
	// 3                                                                                                                                                                                                             
        #2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // B                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b11011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // -                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // F                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b11111;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 2                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// -                                                                                                                                                                                                     
        #1000
          newkey = 1'b1;
        keycode = 5'b00011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // F                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b11111;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 2                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b10010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// some mixed operations 3-1 (2) x 3 (6) - 8 (-2) + 5 (3)

	// 3                                                                                                                                                                                                             
        #2000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // -                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 1                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b10001;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// X                                                                                                                                                                                                     
        #1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 3                                                                                                                                                                                                     
        #1000
          newkey = 1'b1;
        keycode = 5'b10011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =                                                                                                                                                                                                           
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// -                                                                                                                                                                                                          
        #1000
          newkey = 1'b1;
        keycode = 5'b00011;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 8
        #1000
          newkey = 1'b1;
        keycode = 5'b11000;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// +                                                                                                                                                                                                            
        #1000
          newkey = 1'b1;
        keycode = 5'b01010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 5                
        #1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =
	#1000
          newkey = 1'b1;
	keycode = 5'b00100;
        #200
          newkey = 1'b0;
	keycode = 5'b00000;


	// Backspace functionality test

	// 5                                                                                                                                                                                                     
        #2000
          newkey = 1'b1;
	keycode = 5'b10101;
        #200
          newkey = 1'b0;
	keycode = 5'b00000;

	// 5                                                                                                                                                                                                     
        #1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // 5                                                                                                                                                                                                            
        #1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// BSP                                                                                                                                                                                                   
        #1000
          newkey = 1'b1;
        keycode = 5'b00001;
        #200
          newkey = 1'b0;
	keycode = 5'b00000;

	// BSP                                                                                                                                                                                                  
        #1000
          newkey = 1'b1;
        keycode = 5'b00001;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 5 + = test

	// 5
	#2000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;
	
	// +                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b01010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =                                                                                                                                                                                                            
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	//5 - = test

	// 5                                                                                                                                                                                                             
        #2000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // -                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	
	//5 x = test

	// 5                                                                                                                                                                                                     
        #2000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // +                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

        // =                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// Backspace after answer test

	// 5                                                                                                                                                                                                             
        #2000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// 5                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// +                                                                                                                                                                                                             
        #1000
          newkey = 1'b1;
        keycode = 5'b00010;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	
	// 5                                                                                                                                                                                                           
        #1000
          newkey = 1'b1;
        keycode = 5'b10101;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;

	// =                                                                                                                                                                                                          
        #1000
          newkey = 1'b1;
        keycode = 5'b00100;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;
	
	// BSP                                                                                                                                                                                                           
        #1000
          newkey = 1'b1;
        keycode = 5'b00001;
        #200
          newkey = 1'b0;
        keycode = 5'b00000;


	
	#5000
	$stop;
     end
endmodule
