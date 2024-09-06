`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 17:27:45
// Design Name: 
// Module Name: cascade
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

// This cascaded squaring module has u_s = 3 which means that it can output a^(2^n) upto n = 3 in one clock cycle
// We implemented this because for the addition chain we used {1,2,3,6} we didnt require n>3, and the squaring block
// itself is very specific to the irredcible polynomial
module cascade(
    input [7 : 0] din,
    input [1 : 0] select,
    output [7 : 0] dout
    );
    wire [7 : 0] sq1_out, sq2_out, sq3_out; // sqn_out = (din)^(2^n)
    squarer sq1(din, sq1_out);
    squarer sq2(sq1_out, sq2_out);
    squarer sq3(sq2_out, sq3_out);
    
    assign dout = (select[1] ? (select[0] ? sq3_out : sq2_out) : (select[0] ? sq1_out : din));
    // the option select = 2'b00 is expected never to be used and hence just outputs din itself
    
endmodule
