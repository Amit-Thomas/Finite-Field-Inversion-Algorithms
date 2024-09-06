`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 21:17:39
// Design Name: 
// Module Name: storage
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

// This module functions as a regular storage unit, but since we might need to 
// read and write in the same clock cycle, there are separate position selectors
// since the data to be written is always the current beta_k value and the only module reading the
// data from this storage also has access to the current beta_k value, we dont expect a read and write 
// to the same location concurrently
module storage(
    input [1:0] sel_write,
    input [7:0] data_write,
    input [1:0] sel_read,
    output reg [7:0] data_read,
    input CLK
    );
    
    reg [7 : 0] regbank [3 : 0];
    initial
    begin
        regbank [0] = 8'b00000001;
    end
    
    always@(posedge CLK) begin
    case (sel_write)
        2'b00: ;
        2'b01: regbank[1] <= data_write;
        2'b10: regbank[0] <= data_write;
        2'b11: regbank[1] <= data_write;
    endcase 
    
    case (sel_read)
        2'b00: data_read <= regbank[0];
        2'b01: data_read <= regbank[1];
        2'b10: data_read <= regbank[2];
        2'b11: data_read <= regbank[3];
    endcase
    end
   
endmodule
