`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 12:57:05
// Design Name: 
// Module Name: ckm_2
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

// 2 bit Karatsuba multiplier using 3 1-bit multipliers following same principle as explained in the
// documentation of the 8-bit multiplier ckm_8.v 
module ckm_2(
    input [1:0] a,
    input [1:0] b,
    output [2:0] c
    );
    wire c_temp;
    ckm_1 CKM1_0(a[0], b[0], c[0]);
    ckm_1 CKM1_1(a[0]^a[1], b[0]^b[1], c_temp);
    ckm_1 CKM1_2(a[1], b[1], c[2]);
    
    assign c[1] = c_temp^c[0]^c[2];
endmodule
