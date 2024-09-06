`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 10:08:50
// Design Name: 
// Module Name: squarer
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

module squarer
    #(parameter m = 7, BITS = $clog2(m + 1))
    (
        input [m : 0] din,
        output [m : 0] dout
        );
     assign dout[7] = 0;
     assign dout[6] = din[6]^din[4]^din[3];
     assign dout[5] = din[5]^din[4];
     assign dout[4] = din[7]^din[6]^din[5]^din[4]^din[2];
     assign dout[3] = din[6]^din[5]^din[4];
     assign dout[2] = din[4]^din[1];
     assign dout[1] = din[7]^din[6]^din[4];
     assign dout[0] = din[6]^din[5]^din[0];
    
    //RAM
    
    
endmodule
