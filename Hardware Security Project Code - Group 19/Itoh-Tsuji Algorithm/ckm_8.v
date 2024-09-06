`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 16:46:13
// Design Name: 
// Module Name: ckm_8
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

// The Karatsuba multiplier works so that an m-bit multiplication is broken into 3 m/2 bit multiplications
// (A1x^(m/2) + A0)(B1x^(m/2) + B0) = A1B1 x^m + ((A0+A1)(B0+B1)-A1B1-A0B0) x^(m/2) + A0B0
module ckm_8(
    input [7 : 0] a, b,
    output [14 : 0] c
    );
    
    wire [6 : 0] c_temp, c_h, c_l;
    wire [14 : 0] high, mid, low, test;
    
    //initializing the 3 m/2 bit multipliers
    ckm4 CKM3_0(.a(a[3:0]), .b(b[3:0]), .c(c_l));
    ckm4 CKM3_1(.a(a[7:4]^a[3:0]), .b(b[7:4]^b[3:0]), .c(c_temp));
    ckm4 CKM3_2(.a(a[7:4]), .b(b[7:4]), .c(c_h));
    
    //shifting the output values appropriately
    assign high = {c_h[6:0], 8'b0}; 
    assign low = {8'b0, c_l[6:0]};
    assign mid = {4'b0, c_temp^c_h^c_l, 4'b0}; //performed the XOR as well
    // combining the shifted values with XOR
    assign c = high^mid^low;
    
endmodule
