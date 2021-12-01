//////////////////////////////////////////////////////////////////////////////////
// Company:       UCD School of Electrical and Electronic Engineering
// Engineer:      Ciarán Cullen & Jan Przybyszewski
// Project:       Calculator Design assignment
// Target Device: XC7A100T-csg324 on Digilent Nexys-4 board
// Description:   Hardware testbench for calculator design.
//                Defines top-level input and output signals (see comments on ports).
//                Instantiates keypad block for getting inputs.
//                Instantiates clock and reset generator block, for 5 MHz clock.
//                Instantiates the calculator to be tested.
//                Instantiates a display interface to show the outpud.
//  Created: 29 November 2021
//  Modified from CleanupHardwareTest.v by Brian Mulkeen
//////////////////////////////////////////////////////////////////////////////////
module CalculatorTest(
        input clk100,        // 100 MHz clock from oscillator on board
        input rstPBn,        // reset signal, active low, from CPU RESET pushbutton
        input [5:0] kpcol,   // signal from keypad
        output [3:0] kprow,       // drives keyad rows, 0 on top
        output [7:0] digit,  // digit controls - active low (7 on left, 0 on right)
        output [7:0] segment,// segment controls - active low (a b c d e f g p)
        output overflow,     // overflow warning signal
        output sign          // sign signal
        );

// ===========================================================================
// Internal Signals
    wire clk5;              // 5 MHz clock signal, buffered
    wire reset;             // internal reset signal, active high
    wire newkey;
    wire [4:0] keycode;
    wire [15:0] value;
               
// ===========================================================================
// Instantiate clock and reset generator, connect to signals
    clockReset  clkGen  (
            .clk100 (clk100),       // input clock at 100 MHz
            .rstPBn (rstPBn),       // input reset, active low
            .clk5   (clk5),         // output clock, 5 MHz
            .reset  (reset) );      // output reset, active high


// ==================================================================================
// Instantiate keypad interface
    keypad keypad (.clk(clk5),.rst(reset),.kpcol(kpcol),.kprow(kprow),.newkey(newkey),.keycode(keycode));
// ==================================================================================
// Instantiate display interface
    top display(.clock(clk5),.reset(reset),.value(value),.dots(0000),.segment(segment),.digit(digit) ); //Badly named display module from previous assignment

// ===========================================================================
// Instantiate Calculator
     Calculator Calculator(.clock(clk5),.reset(reset),.newkey(newkey),.keycode(keycode),.value(value),.ovw(overflow),.sign(sign));
endmodule
