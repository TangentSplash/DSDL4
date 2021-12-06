`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Calculator Testbench
// Description: Testbench created to verify the calculator module
// Most of the tests are run from an input file, with some extra
// special operator tests written in the testbench. The testbench
// also checks the calculators are the same as the expected answers
// given in the input file.
//////////////////////////////////////////////////////////////////////////////////

module CalculatorTestbench;

	localparam ADD =  4'b1010;	  // Add key
	localparam MULT = 4'b0010;    //Multiplication key
	localparam SUBT = 4'b0011;    //Subtract key
	localparam EQLS = 4'b0100;    //Equals key
	localparam BACK = 4'b0001;    //Backspace key
	localparam CLEAR =4'b1001;    //Clear All Key
	localparam CLRE = 4'b1100;    //Clear Entry Key
	
	localparam CONSOLE = 1;		  // file handle for printing to console
	localparam NUMTESTS = 26;     //Number of tests in the text file

    // Inputs to modu1e being verified
   reg clock, reset, newkey;
   reg [4:0] keycode;
   // Outputs from modu1e being verified
   wire	     ovw, sign;
   wire [15:0] value;
   
   //Testbench Signals
   integer outfile,error_count,test;
   reg [63:0] stim [0:NUMTESTS];    //Array to hold text file lines
   
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
   // Generate 5MHz clock signal
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
	
	$readmemh("CalculatorTests.txt",stim);         //Read text file as hexidecimal
	outfile = $fopen("Calculator_results.txt");    //Open output file
	$fdisplay(outfile,"Operator codes:\nAdd: a\nMultiply: 2\nSubtract: 3\n");  //Write to the output file
	
	#150   //Reset
	  reset = 1'b1;
	#200
	  reset = 1'b0;
	  
	  //Test of keypad bounce
	  //Set multiple values of keycode before seting newkey to high for one clock cycle, should only sample keycode during this time
	  keycode = {1'b1, 4'h5};
      #(({$random}%1000)+400) //Wait a random amount of time between 400 and 1400ns
      keycode = {1'b0, MULT};
      #(({$random}%1000)+400)
      keycode = {1'b1, 4'hD};   //This value should be entered to the calculator
      #(({$random}%1000)+400)
      @(posedge clock)
      newkey = 1'b1;     //Set newkey to high for exactly one clock cycle
      @(posedge clock)
      newkey = 1'b0;
      #(({$random}%1000)+400)
      keycode = {1'b1, 4'h5};
      #(({$random}%1000)+400)
      keycode = 5'b00000;    //Set keycode back to 0
      #(({$random}%1000)+400)
      keycode = {1'b0, ADD};
      #(({$random}%1000)+400)
      keycode = {1'b0, SUBT};   //This should be entered
       #(({$random}%1000)+400)
      @(posedge clock)
      newkey = 1'b1;     //Set newkey to high for exactly one clock cycle
      @(posedge clock)
      newkey = 1'b0;
      #(({$random}%1000)+400)
      keycode = {1'b1, 4'h4};
      #(({$random}%1000)+400)
      keycode = 5'b00000;    //Set keycode back to 0
      #(({$random}%1000)+400)
      keycode = {1'b1, 4'h2};
      #(({$random}%1000)+400)
      keycode = {1'b0, EQLS};
      #(({$random}%1000)+400)
      keycode = {1'b0, CLEAR};
      #(({$random}%1000)+400)
      keycode = {1'b1, 4'hF};   //This should be entered
      #(({$random}%1000)+400)
      @(posedge clock)
      newkey = 1'b1;     //Set newkey to high for exactly one clock cycle
      @(posedge clock)
      newkey = 1'b0;
      #(({$random}%1000)+400)
      keycode = 5'b00000;
      #(({$random}%1000)+400)
      keycode = {1'b0, EQLS};
      @(posedge clock)
      newkey = 1'b1;     //Set newkey to 1high for exactly one clock cycle
      @(posedge clock)
      newkey = 1'b0;
      #1000 CHECK_ANS(1'b1,16'h2,1'b0);    //D-F=-2
      //Check the answer is as expected using a task
      //First argument is expected sign, second is expected magnitude and third if for if overflow is expected
      
	
	for (test=0; test<NUMTESTS;test=test+1)    //Go through each of the text file tests
	begin
	   if(!stim[test][60]) //If this is a new operation, two values and an operator must be input
	       INPUT_FULL(stim[test][59:44],stim[test][43:40],stim[test][39:24]);  
	       //First argument is the first operand, the second is the keycode of the operator, and the third is the second operand
	   else    //This is a continuation so only operator and a single value will be input
	       INPUT_PARTIAL(stim[test][43:40],stim[test][39:24]); //Operator and operand are the two input arguments
    #(({$random}%1000)+400) 
    CHECK_ANS(stim[test][20],stim[test][19:4],stim[test][0]);   //Check that the answer is as expected from the input file
    //The first argument is the expected sign, the second is the expected magnitude and the third is for if overflow is expected
	end

    //Special Operations Tests
    //(Tests that could not be put in the input file easily)
    
    // Backspace functionality test
    INPUT_NUM(16'h555);
    INPUT_KEY(BACK,1'b0);
    INPUT_KEY(BACK,1'b0);
    CHECK_ANS(1'b0,16'h5,1'b0);
    
    // 55 + = test
    INPUT_NUM(16'h5);
    INPUT_KEY(ADD,1'b0);
    INPUT_KEY(EQLS,1'b0);
    CHECK_ANS(1'b0,16'haa,1'b0);
    
    //5 - = test
    INPUT_NUM(16'h5);
    INPUT_KEY(SUBT,1'b0);
    INPUT_KEY(EQLS,1'b0);
    CHECK_ANS(1'b0,16'h0,1'b0);
    
    //5 x = test
    INPUT_NUM(16'h5);
    INPUT_KEY(MULT,1'b0);
    INPUT_KEY(EQLS,1'b0);
    CHECK_ANS(1'b0,16'h19,1'b0);
    
    // Backspace after answer test
    INPUT_NUM(16'h55);
    INPUT_KEY(ADD,1'b0);
    INPUT_NUM(16'h5);
    INPUT_KEY(EQLS,1'b0);
    CHECK_ANS(1'b0,16'h5A,1'b0);
    INPUT_KEY(BACK,1'b0);
    CHECK_ANS(1'b0,16'h5,1'b0);
    INPUT_KEY(CLEAR,1'b0);
    CHECK_ANS(1'b0,16'h0,1'b0);
    
    //Clear entry Test
    INPUT_NUM(16'h5);
    INPUT_KEY(ADD,1'b0);
    INPUT_NUM(16'h4);
    INPUT_KEY(CLRE,1'b0);
    INPUT_NUM(16'h3);
    INPUT_KEY(EQLS,1'b0);
    CHECK_ANS(1'b0,16'h8,1'b0);
    
	#5000
	if (error_count==0)    //If no errors have been found
	 $fdisplay(outfile|CONSOLE, "Finished with no errors");
	 else
	 begin
         $fwrite(outfile|CONSOLE, "Finished with %d errors",error_count);
         $display(", see CalculatorTests.txt for more details");   //Just write this to the console
	 end
	$fclose(outfile);
	$stop;
    end
     
    task INPUT_NUM(input [15:0] value); //Task to input all the digits of a single number
        begin: input_a_number
        reg have_input; //Flag to determine wheter any digit has been input yet
        have_input=1'b0;
        
        if (|(value[15:12]))   //If the most significant digit is non-zero
        begin
            INPUT_KEY(value[15:12],1'b1);   //Simulate pressing it
            have_input=1'b1;                //Set the flag so that the three other digits will be entered no matter their value
        end
        if (|(value[11:8]) || have_input)   //If the second most significant digit is non-zero, or have already input a more significant digit
        begin
            INPUT_KEY(value[11:8],1'b1);
            have_input=1'b1;
        end
        if(|(value[7:4]) || have_input)
            INPUT_KEY(value[7:4],1'b1);
        INPUT_KEY(value[3:0],1'b1);     //Will always have to input some data, so don't need to check if least significant digit is non-zero
        end
    endtask
    
    task INPUT_PARTIAL(input [3:0] operator, input [15:0] input_val);   //Input just an operator and operand, for continuing a calculation
        begin
        #(({$random}%2000)+400)
        INPUT_KEY(operator,1'b0);
        #(({$random}%2000)+400)
        INPUT_NUM(input_val);
        #(({$random}%2000)+400)
        INPUT_KEY(EQLS,1'b0);
        $fwrite(outfile,"operator '%h' Value 2 %h = ",operator,input_val);                  //Write the input...
        #1000 $fdisplay(outfile, "value %h with sign %b and overflow %b",value,sign,ovw);   //and output to the file
        //Delay for 1000ns before sampling the calculator result, but do not hold up the rest of the testbench
        end
    endtask
     
     task INPUT_FULL(input [15:0] value1, input [3:0] operator, input [15:0] value2);   //Input two operators and an operand, for new calculations
     begin
        #(({$random}%2000)+400)
        INPUT_NUM(value1);
        #(({$random}%2000)+400)
        $fwrite(outfile,"Value 1 %h, ",value1);
        INPUT_PARTIAL(operator,value2); //Input the rest of the data using the task that has already been written
        end
    endtask
        
     task INPUT_KEY(input [3:0] val, input is_num); //Input a single digit or operator
     //Inputs are the 4 rightmost bits of the keycode and whether the input is a number 
         begin
            #(({$random}%1000)+400)
             keycode = {is_num, val};   //The keycode is the two inputs concatonated
            #(({$random}%1000)+400)
             @(posedge clock)
             newkey = 1'b1;     //Set newkey to 1high for exactly one clock cycle
             @(posedge clock)
             newkey = 1'b0;
             #(({$random}%1000)+400)
             keycode = 5'b00000;    //Set keycode back to 0
          end
      endtask
      
    
    task CHECK_ANS(input sign_expected,input [15:0] answer_expected,input ovw_expected);    //Check the calculator output is as expected
    begin
        
        if((value!=answer_expected) || (sign!=sign_expected) || (ovw!=ovw_expected))    //If any of the calculator outputs are not as expected 
            begin
                $fdisplay(outfile|CONSOLE, "***Wrong value at time %t. Expected value %h, got %h, expected sign %b, got %b, expected overflow %b, got %b***",$time,answer_expected,value,sign_expected,sign,ovw_expected,ovw);
                error_count=error_count+1;  //Incrament the number of errors found
            end
    end
    endtask
endmodule
