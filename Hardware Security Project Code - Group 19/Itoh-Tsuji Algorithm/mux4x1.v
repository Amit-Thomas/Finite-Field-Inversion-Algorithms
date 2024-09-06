`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 18:32:54
// Design Name: 
// Module Name: mux4x1
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


// This module is just a normal 4x1 MUX module and it is used to select the multiplicands of the multiplier
module mux4x1(
    input [7 : 0]  d0, d1, d2, d3,
    input [1 : 0] sel,
    output [7 : 0] dout
    );
    
    assign dout = (sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0));
endmodule
