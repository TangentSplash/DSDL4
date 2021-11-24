// Registers Module contains

module Registers(
    input clock,
    input reset,
    input newhex,           // High when a hexidecimal number is pressed
    input [3:0] hexcode,    // The hexidecimal number currently pressed
    input newop,            // High when an operator is pressed
    input [1:0] opcode, 	// Operator currently being pressed
    input eq,               // Equals is currently being pressed
    input signed [15:0] ans,
    output signed [15:0] V1_reg,
    output signed [15:0] V2_reg
    );              

    reg signed [15:0] V1curr, V1next, V2curr, V2next;  
    reg FLOWMODEcurr, FLOWMODEnext;

    wire [15:0] overwrite <= {12'b000000000000, hexcode};
    
    // Reset condition
    
    wire [15:0] ans, overwrite, shifteddigits;

    assign shifteddigits = {V1curr[11:0],newhex};
    assign overwrite = {12'b0,newhex};

    always @ (posedge clock)
        if (reset)
            begin   
                V1curr <= 16'h0000;
                V2curr <= 16'h0000;
                FLOWMODEcurr <=1'b0;
            end 
        else 
            begin
               V1curr <= V1next;
               V2curr <= V2next;
               FLOWMODEcurr <= FLOWMODEnext;
               V1_reg <= V1curr; // Output will go to arith and display
               V2_reg <= V2curr; // Output will go to arithmetic block
            end

    //Flow Mode Module
    always @ (FLOWMODEcurr)
        begin
            if (newhex)             FLOWMODEnext <= 1'b0;
            else if (eq | newop)    FLOWMODEnext <= 1'b1;
            else                    FLOWMODEnext <= FLOWMODEcurr;
        end

    //V1 Register
    always @ (eq | new_hex)
    begin 
        V1next <= V1curr
    end

    //V1
    always @ (V1curr)
        begin
            if (eq)                             V1next <= ans;
            else if (FLOWMODEcurr && newhex)    V1next <= overwrite; // only overwrite if we get a new char
            else                                V1next <= {V1curr[11:0], hexcode}; // shift left
        end

    //V2 Register
    always @ (newop)
        begin
            V2next <= V2curr
        end 

    //V2
    always @ (V2curr)
        begin
            if (newhex | eq)    V2next <= V1curr;
            else                V2next <=V2curr;
        end

endmodule
