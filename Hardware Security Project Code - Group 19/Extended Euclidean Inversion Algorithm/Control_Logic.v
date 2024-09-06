`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 06:52:41 PM
// Design Name: 
// Module Name: Control_Logic
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

// This module takes charge of all the control signals which need to be sent to 
// all the D and M Cells
// The Carry signal is not generated in the control block, as shown in the paper too
module Control_Logic
    #(parameter m = 7, BITS = $clog2(m + 1))
    (
        input clk,
        input rm,
        input sm,
        output reg Switch, // determines when R <-> S, U <-> V
        output reg Reduce, // determines when S = S-R, V = V-U
        output reg MultR, // determines when x.R is computed
        output reg MultU, // if 1, then x.U modF is computed , else U/x modF
        output [BITS - 1 : 0] delta
    );
    
    reg [BITS - 1 : 0] delta_reg, delta_next;
    
    initial
    begin
        delta_reg <= 'b0;
    end
    
    
    always@(posedge clk)
    begin
        // This is a modification we brought to the paper's MultRU which wasn't working
        // because the conditions for x.R and x.U were different
        MultR <= ~rm; // rm = 0
        MultU <= ~rm | ~(|delta_reg); // rm = 0 OR delta = 0
        Switch <= rm & ~(|delta_reg); // rm = 1 AND delta = 0
        Reduce <= rm & sm; // rm = 1 and sm = 1
        delta_reg <= delta_next;
    end  
    
    // delta is a counter
    // this delta value is the difference between the degrees of R and S
    // as soon as it becomes 0, the values are swapped and the process starts again
    always@(*)
    begin
    if (~rm)
        begin 
            delta_next = delta_reg + 'b1;
        end
        
        else 
        begin
            if (rm & !delta_reg)
            begin
                delta_next = delta_reg + 'b1;
            end
            
            else
            begin
                delta_next = delta_reg - 'b1;
            end
        end
    end
    assign delta = delta_reg;
endmodule
