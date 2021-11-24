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

    wire [15:0] add,multiply;

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

    assign add = V1curr+V2curr;
    assign multiply = V1curr*V2curr;
    
    always @ (V1curr, V2curr)
        case (operator)
            2'b0: ans <= add;
            2'b01: ans <= multiply;
        endcase 



endmodule