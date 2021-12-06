`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Calculator Testbench
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module CalculatorTestbench;

/* localparam [4:0]			   CAKEY = 5'b01001;
   localparam [4:0]			   CEKEY = 5'b01100;
*/
	localparam ADD = 4'b1010;	       // Add key
	localparam MULT = 4'b0010;         //Multiplication key
	localparam SUBT = 4'b0011;         //Subtract key
	localparam EQLS = 4'b0100;         //Equals key
	localparam BACK = 4'b0001;      //Backspace key
	
	localparam CONSOLE = 1;		// file handle for printing to console
	localparam NUMTESTS = 17;   //Number of tests in the textfile

    // Inputs to modu1e being verified
   reg clock, reset, newkey;
   reg [4:0] keycode;
   // Outputs from modu1e being verified
   wire	     ovw, sign;
   wire [15:0] value;
   
   //Testbench Signals
   integer outfile,error_count,test;
   reg [39:0] stim [0:NUMTESTS];
   integer answer_expected;
   reg ovw_expected,sign_expected;
   
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
    
    
    //Apply input signals
   initial
     // Init and reset
    begin
	reset = 1'b0;
	newkey = 1'b0;
	keycode = 5'b0;
	error_count=0;
	
	$readmemh("CalculatorTests.txt",stim);
	outfile = $fopen("Calculator_results.txt");
	$fdisplay(outfile,"Operator codes:\nAdd: a\nMultiply: 2\nSubtract: 3\n");
	#150
	  reset = 1'b1;
	#200
	  reset = 1'b0;
	// #200 means wait 1 clock cycle
	
	for (test=0; test<NUMTESTS;test=test+1)
	begin
	   if(!stim[test][36])
	   begin
	   	   sign_expected=1'b0;
	       ovw_expected=1'b0;
	       INPUT_FULL(stim[test][35:20],stim[test][19:16],stim[test][15:0]);
       end
	   else
	   begin
	   //$fdisplay(outfile|CONSOLE,"%h",stim[test][15:0]);
	       INPUT_PARTIAL(stim[test][19:16],stim[test][15:0]);
	       end
	end

	#5000
	if (error_count==0)
	 $fdisplay(outfile|CONSOLE, "Finished with no errors");
	 else
	 $fwrite(outfile|CONSOLE, "Finished with %d errors",error_count);
	 $display(", see CalculatorTests.txt for more details");
	$fclose(outfile);
	$stop;
    end
     
    task INPUT_NUM(input [15:0] value);
        begin: input_a_number
        reg have_input;
        have_input=1'b0;
        
        if (|(value[15:12]))   //If any of the remaining bits have data
        begin
            INPUT_KEY(value[15:12],1'b1);
            have_input=1'b1;
        end
        if (|(value[11:8]) || have_input)
        begin
            INPUT_KEY(value[11:8],1'b1);
            have_input=1'b1;
        end
        if(|(value[7:4]) || have_input)
            INPUT_KEY(value[7:4],1'b1);
        INPUT_KEY(value[3:0],1'b1);
        end
    endtask
    
    task INPUT_PARTIAL(input [3:0] operator, input [15:0] input_val);
        begin
        #(({$random}%2000)+400)
        INPUT_KEY(operator,1'b0);
        #(({$random}%2000)+400)
        INPUT_NUM(input_val);
        #(({$random}%2000)+400)
        INPUT_KEY(EQLS,1'b0);
        $fwrite(outfile,"Value 1 %h, operator '%h' Value 2 %h = ",answer_expected,operator,input_val);
        #1000 $fdisplay(outfile, "value %h with sign %b and overflow %b",value,sign,ovw);
        CALC_EXPECTED(operator,input_val);
        #(({$random}%1000)+400)
        CHECK_ANS();
        end
    endtask
     
     task INPUT_FULL(input [15:0] value1, input [3:0] operator, input [15:0] value2);
     begin
        #(({$random}%2000)+400)
        INPUT_NUM(value1);
        #(({$random}%2000)+400)
        answer_expected=value1;
        INPUT_PARTIAL(operator,value2);
        end
    endtask
        
     task INPUT_KEY(input [3:0] val, input is_num);
         begin
             keycode = {is_num, val};
            #(({$random}%1000)+400)
             @(posedge clock)
             newkey = 1'b1;
             @(posedge clock)
             newkey = 1'b0;
             #(({$random}%1000)+400)
             keycode = 5'b00000;
          end
      endtask
      
    task CALC_EXPECTED(input[3:0] opcode,input signed [15:0] value2);
        begin: calculate_expected
        integer val2;
        val2=$signed(value2);
           if(sign_expected)                        //If the sign of the previous operation was negative
                answer_expected=answer_expected*-1; //Get the negitive of the previous answer magnitude
           if (opcode==4'ha)    //Add operator
           begin
            answer_expected=answer_expected+value2;
           end
           else if (opcode==4'h2)   //Multiply Operator
           begin
            answer_expected=answer_expected*value2;
           end
           else if (opcode==4'h3)   //Subtract Operator
           begin
           $fdisplay(outfile|CONSOLE,"%h - %h = %h",answer_expected,val2,$signed(answer_expected-val2));
            answer_expected=answer_expected-val2;
           end
           
           if (answer_expected > 16'hffff || answer_expected < -16'shffff)
           begin
           $fdisplay(outfile|CONSOLE,"Expect overflow because answer would be %h",answer_expected);
            answer_expected=16'h0;
            ovw_expected=1'b1;
           end
           
           if(answer_expected<0)
           begin
            sign_expected=1'b1;
            answer_expected=answer_expected*-1;
            end
        end
    endtask
    
    task CHECK_ANS();
    begin
        if((value!=answer_expected) || (sign!=sign_expected) || (ovw!=ovw_expected))
            begin
                $fdisplay(outfile|CONSOLE, "***Wrong value at time %t. Expected value %h, got %h, expected sign %b, got %b, expected overflow %b, got %b***",$time,answer_expected,value,sign_expected,sign,ovw_expected,ovw);
                error_count=error_count+1;
            end
    end
    endtask
endmodule
