`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 12:53:14
// Design Name: 
// Module Name: ckm4
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

// 4 bit Karatsuba multiplier using 3 2-bit multipliers following same prinicple as explained in the
// documentation of the 8-bit multiplier ckm8.v 
module ckm4(
    input [3:0] a, b,
    output [6:0] c
    );
    wire [2:0] c_temp, c_h, c_l;
    wire [6 : 0] high, mid, low, test;
    ckm_2 CKM2_0(.a(a[1:0]), .b(b[1:0]), .c(c_l));
    ckm_2 CKM2_1(.a(a[3:2]^a[1:0]), .b(b[3:2]^b[1:0]), .c(c_temp));
    ckm_2 CKM2_2(.a(a[3:2]), .b(b[3:2]), .c(c_h));
    
    assign test = c_temp^c_h^c_l;
    assign high = {c_h[2:0], 4'b0};
    assign low = {4'b0, c_l[2:0]};
    assign mid = {2'b0, c_temp^c_h^c_l, 2'b0};
    assign c = high^mid^low;
    
endmodule
