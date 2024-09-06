`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 06:40:24 PM
// Design Name: 
// Module Name: M_Cell
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


module M_Cell(
    input inWix1, inWi_1, // stands for W_(i+1) and W_(i-1)
    input inUi,
    input inVi,
    input inXi_1, inXim,  // stands for the ith bit of the precomputed values of X^-1 and X^m mod F(X)
    input Switch, Reduce, MultU, Carry, // various control signals 
    output outWi, outUi, outVi // outUi and outVi are the new values to be stored in the registers
    );
    
    // Ui is always either right or left shifted, even after switching, or being computed on
    // For ease of organization, Wi = Ui if no switch 
    // and Vi^Ui if reduced and switched, and Vi if just switched
    wire tempWx, temp;
    assign tempWx = MultU ? inWi_1 : inWix1;
    assign outVi = Switch ? inUi : temp; // doesnt need to take care of mod because it is just the XOR of 2 values which are already within the field
    assign temp = (inVi^(Reduce & inUi));
    assign outWi = Switch ? temp : inUi;
    assign outUi = tempWx ^ (Carry & (MultU ? inXim : inXi_1)); 
    // if MultU is On, we need to left shift the bits, but if the MSB is 1, 
    // we need to bring it down by computing its value modF , which is precomputed
    // and just XORed with the current value if such a problem occurs
    // similarly for right shifting/ division - when MultU is Off 

endmodule
