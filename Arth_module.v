// Arithmetic Module
// Must contain opcode register, add, mult and maybe subtract blocks
module Arth_module(
    input clock,
    input reset,
    input [3:0] V1,
    input [3:0] V2,
    input [1:0] opcode,           
    input newop,
    output reg [15:0] ans);

    reg [1:0] operator_curr,operator_next;  

    wire signed [15:0] add, subtract,V1_signed, V2_signed;
    wire [15:0] multiply;   //Multiplication of sign and magnitude is much easier

    assign V1_signed=$signed(V1);
    assign V2_signed=$signed(V2);

    always @ (posedge clock)
    begin
        if (reset)
        begin
            opperator_curr <= 2'b00;
        end 
        else 
        begin
            operator_curr <= opperator_next;
        end

        if (newop)
            operator_next <= opcode;
    end

    assign add = V1signed+V2signed;
    assign subtract = V2_signed-V1_signed;
    assign multiply = V1*V2;
    
    always @ (V1, V2)
        case (operator)
            2'b0: ans <= $unsigned(add);
            2'b01: ans <= multiply;
            2'b10: ans <= $unsigned(subtract);
        endcase 



endmodule