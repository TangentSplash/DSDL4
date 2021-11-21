module Calculate(
    input clock,
    input reset,
    input newhex.           // High when a hexidecimal number is pressed
    input [3:0] hexcode,    // The hexidecimal number currently pressed
    input newop,            // High when an operator is pressed
    input [1:0] opcode, 	// Operator currently being pressed
    input eq);              // Equals is currently being pressed

    reg [3:0] V1curr, V1next, V2curr, V2next;  
    reg FLOWMODEcurr, FLOWMODEnext;

     always @ (posedge clock)
        if (reset)
        begin
            V1curr <= 4'b0000;
            V2curr <= 4'b0000;
            FLOWMODEcurr <=1'b0;
        end 
        else 
        begin
            V1curr <= V1next;
            V2curr <=V2next;
            FLOWMODEcurr <= FLOWMODEnext;
        end

    //Flow Mode
    always @ (FLOWMODEcurr)
        begin
            if (newhex)             FLOWMODEnext <= 1'b0;
            else if (eq | newop)    FLOWMODEnext <= 1'b1;
            else                    FLOWMODEnext <= FLOWMODEcurr;
        end

    //V1
    always @ (V1curr)
        begin
            if (eq)                 V1next <= ans;
            else if (FLOWMODEcurr)  V1next <= overwrite;
            else                    V1next <= V1curr;
        end
endmodule