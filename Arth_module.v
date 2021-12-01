module Arth_module(
    input clock,
    input reset,
    input [16:0] V1, //Sign and magnitude
    input [16:0] V2, //Sign and magnitude
    input [1:0] opcode,           
    input newop,
    input newhex,
    input eq,
    output [16:0] answer,    //Sign and magnitude
    output ovw_out);

    reg [1:0] operator_curr;  
    reg [16:0] Ianswer;
    wire signed [16:0] add, subtract;
    wire signed [16:0] V1_2c,V2_2c;
    reg ovw;
    reg omode_next;
    reg omode_curr;
    
    wire [16:0] multiply;   //Multiplication of sign and magnitude is much easier

    wire ovwa,ovws;
    wire [16:0] multextra;
    wire ovwm = |multextra;
    
     wire signed [16:0] nadd, nsubtract;
    
    //Convert to 2's complement by checking sign bit, if it is 1 take the number to be minus the unsigned magnitude, otherwise take the unsigned magnitude    
    assign V1_2c= V1[16] ? -$signed({1'b0,V1[15:0]}) : $signed(V1);
    assign V2_2c = V2[16] ? -$signed({1'b0,V2[15:0]}) : $signed(V2); 

    always @ (posedge clock)
    begin
        if (reset)
            begin
                operator_curr <= 2'b00;
                omode_curr <= 1'd0;
                ovw <= 1'b0;
            end 
        else 
            begin  
                omode_curr <= omode_next;
            
                if (newop)
                    operator_curr <= opcode;
                else
                    operator_curr <= operator_curr;
                    
                if (newop || newhex)
                    ovw <= 1'b0;
                else if (ovwa | ovwm | ovws)
                    case (operator_curr) 
                        2'b00: 
                        begin 
                            ovw <= ovwa;     //Calculation overflowed if addition overflowed
                        end
                        2'b01:
                        begin
                            ovw <= ovwm; //Did multiplication overflow?
                        end 
                        2'b10:
                        begin
                            ovw <= ovws; //Did subtraction overflow
                        end
                        default: 
                        begin 
                            ovw <= 1'b1; //Should not have invalid operator, show an overflow error
                        end
                    endcase 
                else
                    ovw <= ovw;

            end
    end
   
    assign add = V1_2c+V2_2c;
    assign nadd= -add;
    assign ovwa=((V1_2c[16]&V2_2c[16])&!(add[16])) || ((!V1_2c[16]&!V2_2c[16])&add[16]); //Addition overflow if add a positive to a positive and get a negative, or add a negative to a negative and get a positive 
    assign subtract = V2_2c-V1_2c;
    assign nsubtract = -subtract;
    assign ovws=((V2_2c[16]&!V1_2c[16])&!(subtract[16])) || ((!V2_2c[16]&V1_2c[16])&subtract[16]);  //Subtraction overflow if subtract a negative from a positive and get a negative, or subtract a positive from a negative and get a positive 
    
    assign {multextra,multiply[15:0]}=V1[15:0]*V2[15:0];     //Multiply the magnitudes
    assign multiply[16]=V1[16]^V2[16];                  //XOR the sign bits
    
    always @ ( * ) 
        case (operator_curr)    //Answer depends on the selected operator
            2'b00: 
            begin 
                Ianswer = add[16] ? {1'b1,nadd[15:0]}: $unsigned(add);  //Convert back to sign and magnitude. If 2's complement is negative, set sign bit to 1 and set magnitude to negative of the remaining bits
            end
            2'b01:
            begin
                Ianswer = multiply;
            end 
            2'b10:
            begin
                Ianswer = subtract[16] ? {1'b1,nsubtract[15:0]} : $unsigned(subtract);  //If 2's complement is negative, set sign bit to 1 and set magnitude to negative of the remaining bits
            end
            default: 
            begin 
                Ianswer = 4'h0;
            end
        endcase 
        
    always @ (newhex, eq, newop, omode_curr)
     begin
        if (newhex || newop)             omode_next <= 1'b0;
        else if (eq)                     omode_next <= 1'b1;
        else                             omode_next <= omode_curr;
     end
     
      assign answer = ovw ? 16'd0 : Ianswer;
      assign ovw_out = omode_curr ? ovw : 1'b0;
     
endmodule
