`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 21:33:17
// Design Name: 
// Module Name: control_logic
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

// This control logic block is very specific to the irreducible polynomial and the addition chain created for 
// the GF(2^7) field -> {1,2,3,6}
// 2 = 1+1, 3 = 2+1, 6 = 3+3

// each of the signals are explained in the tb module documentation
module control_logic(
    input CLK,
    output reg [1:0] n_cascade,
    output reg [1:0] sel_read,
    output reg [1:0] sel_write,
    output reg [1:0] sel_mux1,
    output reg [1:0] sel_mux2,
    output reg en = 1'b1
    
    );
//    addition chain = 1, 2, 3, 6
    reg [2:0] counter = 3'b0;
    
    always@(negedge CLK) begin
    counter <= counter + 1;
    case (counter)
        3'b000: begin
                n_cascade <= 2'b00;
                sel_mux1 <= 2'b01; // storage[0] which is just = 1
                sel_mux2 <= 2'b00; // a
                sel_read <= 2'b00; // read storage[0]
                sel_write <= 2'b00; // do nothing
                end
        3'b001: begin
                n_cascade <= 2'b01; // n = 1 = j (k,j=1,1) since beta_(k+j) = (beta_k)^(2^j)*(beta_j)
                sel_mux1 <= 2'b00; // beta_1 = a
                sel_mux2 <= 2'b01; // (beta_1)^(2^1)
                sel_write <= 2'b00; // do nothing
                end
        3'b010: begin
                n_cascade <= 2'b01; //  n = 1 = j (k,j=2,1)
                sel_mux1 <= 2'b00; // beta_1
                sel_mux2 <= 2'b01; // (beta_1)^(2^2)
                sel_write <= 2'b01; // write beta_2 to regbank
                end
        3'b011: begin
                n_cascade <= 2'b11; // n = 3 (k,j = 3,3)
                sel_mux1 <= 2'b10; // beta_3 = current output
                sel_mux2 <= 2'b01; // (beta_3)^(2^3)
                sel_write <= 2'b10; // write beta_3 to regbank
                end
        3'b100: begin // this is the extra squaring step to get the inverse
                sel_mux1 <= 2'b10; // beta_6 = current output
                sel_mux2 <= 2'b10; // beta_6 = current output
                sel_write <= 2'b11; // write beta_6 to regbank
                end
        default: en<=1'b0;
    endcase
    end
    
endmodule
