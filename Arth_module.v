module Arth_module(
    input clock,
    input reset,
    input [16:0] V1, //Sign and magnitude
    input [16:0] V2, //Sign and magnitude
    input [1:0] opcode,           
    input newop,
    output reg [16:0] answer,    //Sign and magnitude
    output reg ovw);

    reg [1:0] operator_curr,operator_next;  

    wire signed [16:0] add, subtract;
    wire signed [16:0] V1_2c,V2_2c;
    //wire [15:0] V1_unsigned, V2_unsigned;
    wire [16:0] multiply;   //Multiplication of sign and magnitude is much easier

    wire ovwa,ovwm,ovws;
    
     wire signed [16:0] nadd, nsubtract;
    
    //Convert to 2's complement by checking sign bit, if it is 1 take the number to be minus the unsigned magnitude, otherwise take the unsigned magnitude
    assign V1_2c = V1[16] ? -$unsigned(V1[15:0]) : $unsigned(V1[15:0]);     
    assign V2_2c = V2[16] ? -$unsigned(V2[15:0]) : $unsigned(V2[15:0]); 

    always @ (posedge clock)
    begin
        if (reset)
        begin
            operator_curr <= 2'b00;
        end 
        else 
        begin
            operator_curr <= operator_next;
        end

        if (newop)
            operator_next <= opcode;
    end
   
    assign add = V1_2c+V2_2c;
    assign nadd= -add;
    assign ovwa=((V1[15]&V2[15])&!(add[15])) || ((!V1[15]&!V2[15])&add[15]); //Addition overflow if add a positive to a positive and get a negative, or add a negative to a negative and get a positive 
    assign subtract = V2_2c-V1_2c;
    assign nsubtract = -subtract;
    assign ovws=((V1[15]&!V2[15])&(add[15])) || ((!V1[15]&V2[15])&add[15]);  //Subtraction overflow if subtract a negative from a positive and get a negative, or subtract a positive from a negative and get a positive 
    
    assign {ovwm,multiply[15:0]}=V1[15:0]*V2[15:0];     //Multiply the magnitudes
    assign multiply[16]=V1[16]^V2[16];                  //XOR the sign bits
    
    always @ (V1, V2,operator_curr) 
        case (operator_curr)    //Answer depends on the selected operator
            2'b00: 
            begin 
                answer = add[16] ? {1'b1,nadd[15:0]}: $unsigned(add);  //Convert back to sign and magnitude. If 2's complement is negative, set sign bit to 1 and set magnitude to negative of the remaining bits
                ovw = ovwa;     //Calculation overflowed if addition overflowed
            end
            2'b01:
            begin
                answer = multiply;
                ovw = ovwm; //Did multiplication overflow?
            end 
            2'b10:
            begin
                answer = subtract[16] ? {1'b1,nsubtract[15:0]} : $unsigned(subtract);  //If 2's complement is negative, set sign bit to 1 and set magnitude to negative of the remaining bits
                ovw = ovws; //Did subtraction overflow
            end
            default: 
            begin 
                answer = 4'h0;
                ovw = 1'b1; //Should not have invalid operator, show an overflow error
            end
        endcase 
endmodule
