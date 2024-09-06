`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 16:55:00
// Design Name: 
// Module Name: modulo
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

// This module performs the modulo operation wrt to the generator polynomial f(x) = x^7+x^5+x^4+x^3+x^2+x+1
// This takes a 15-bit value and converts it to the equivalent number in the GF field specified
// The XOR combinations for this were computed by hand using the relation x^7 = x^5+x^4+x^3+x^2+x+1
// they are given below for reference :
// x^8 = x^6+x^5+x^4+x^3+x^2+x
// x^9 = x^6+x+1
// x^10 = x^5+x^4+x^3+1
// x^11 = x^6+x^5+x^4+x
// x^12 = x^6+x^4+x^3+x+1
// x^13 = x^3+1
// x^14 = x^4+x
module modulo(
    input [14 : 0] d,
    output [7 : 0] dmodf    
    );
    
    assign dmodf[7] = 1'b0;
    assign dmodf[6] = d[6]^d[8]^d[9]^d[11]^d[12];
    assign dmodf[5] = d[5]^d[7]^d[8]^d[10]^d[11];
    assign dmodf[4] = d[4]^d[7]^d[8]^d[10]^d[11]^d[12]^d[14];
    assign dmodf[3] = d[3]^d[7]^d[8]^d[10]^d[12]^d[13];
    assign dmodf[2] = d[2]^d[7]^d[8];
    assign dmodf[1] = d[1]^d[7]^d[8]^d[9]^d[11]^d[12]^d[14];
    assign dmodf[0] = d[0]^d[7]^d[9]^d[10]^d[12]^d[13];
endmodule
