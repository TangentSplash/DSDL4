module Arth_module(
    input clock,
    input reset,
    input signed [15:0] V1,
    input signed [15:0] V2,
    input [1:0] opcode,           
    input newop,
    output reg signed [15:0] answer);

    reg [1:0] operator_curr,operator_next;  

    wire signed [15:0] add, subtract;
    wire [15:0] V1_unsigned, V2_unsigned;
    wire [15:0] multiply;   //Multiplication of sign and magnitude is much easier

    assign V1_unsigned= {1'b0, V1[14:0] };
    assign V1_unsigned= {1'b0, V2[14:0] };

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

    assign add = V1+V2;
    assign subtract = V2-V1;
    assign multiply = V1_unsigned*V2_unsigned;
    
    always @ (V1, V2)
        case (operator)
            2'b0: answer <= add;
            2'b01: answer <= {V1[15]^V2[15], multiply[14:0]};
            2'b10: answer <= add;
        endcase 



endmodule
