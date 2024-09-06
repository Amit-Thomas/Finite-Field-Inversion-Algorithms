`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 11:26:52 AM
// Design Name: 
// Module Name: D_Cell
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// This is the basic inversion cell as given in the paper. 
// It operates only on R and S where the goal is to calculate the inverse of R
// using the algorithm which calculates gcd(R,S) and the fact that the gcd is 1 
// when S is the irreducible polynomial that generates the field in question

// Each Ri represents 1 bit in R and the DCell works at the bit level
module D_Cell(
    input inRi,
    input inRi_1, // stands for R_(i-1)
    input inSi,
    input inTi_1, // stands for T_(i-1)
    input Switch, Reduce, MultR,
    output outRi, outTi, outSi, Ri_up
    );
    // This assists when performing x.R because we need to just shift each bit up
    // The corresponding control signal is MultR
    assign Ri_up = inRi; 
    
    // This statement is used to perform the xS operation and x.(S-R) operations 
    // The Reduce control signal takes care of the reduction when rm=sm=1
    // If sm is not 1, then that means reduction is not applied, and outTi simply 
    // assists in shifting the bits left, which can be used in the switch 
    // when delta=0 as well
    assign outTi = inSi ^ (Reduce & inRi);
    wire tempR, tempS;
    // These are simply wires which determine the possible next values of Ri and Si
    // which will be decided depending on the Switch control signal
    assign tempR = MultR ? inRi_1 : inRi;
    assign tempS = MultR ? inSi : inTi_1;
    assign outRi = Switch ? tempS : tempR;
    assign outSi = Switch ? tempR : tempS;
endmodule