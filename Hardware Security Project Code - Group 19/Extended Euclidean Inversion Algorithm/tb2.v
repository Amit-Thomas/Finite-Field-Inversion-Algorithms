`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 07:17:20 PM
// Design Name: 
// Module Name: tb1
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

// This module implements the Euclidean algorithm for finte field inversion
// over GF(2^7) with generator f(x) = x^7+x^5+x^4+x^3+x^2+x^1+1
module tb2(

    );
    wire [2 : 0] delta;
    reg clk, clk2;    
    localparam m = 7;
    reg [m : 0] R; // initialized to the number for which inverse is required
    reg [m : 0] S; // initially contains the irreducible polynomial, 
    // logic explained in the documentation for DCell
    reg [m-1 : 0] U; // the final value of U after 2m iterations is what holds the inverse 
    reg [m-1 : 0] V;
    
    // precomputed value of coefficients corresponding to X^(-1) and X^m MOD F(X)
    reg [m-1 : 0] X_1 = 7'b1011111;  
    reg [m-1 : 0] Xm = 7'b0111111; 
    
    // We need to separate this as registers only accept values at clock edges
    wire [m : 0] R_next;
    wire [m : 0] S_next;
    wire [m-1 : 0] U_next;
    wire [m-1 : 0] V_next;
    
    wire Switch, Reduce, MultR, MultU;
    
    wire [m : 0] R_up; // used in DCell
    wire [m : 0] T; // used in DCell
    wire [m-1 : 0] W; // used in MCell

    // generating the Control Logic block
    Control_Logic #(.m(m)) CTRL 
    (
        .clk(clk),
        .rm(R[m]),
        .sm(S[m]),
        .Switch(Switch), 
        .Reduce(Reduce), 
        .MultR(MultR),
        .MultU(MultU),
        .delta(delta)
    );
    
    
     // Generating a clk signal
    localparam t = 50;    
    initial
    begin
        forever
        begin
            clk = 1'b0;
            #(t / 2);
            clk = 1'b1;
            #(t / 2);
        end
    end
    
    // Generate D cells
    // D0 is separate because T_(i-1) and R_(i-1) do not exist
    D_Cell D0(
                .inRi(R[0]),
                .inRi_1(1'b0),
                .inSi(S[0]),
                .inTi_1(1'b0),
                .Switch(Switch), 
                .Reduce(Reduce), 
                .MultR(MultR),
                .outRi(R_next[0]),
                .outTi(T[0]),
                .outSi(S_next[0]),
                .Ri_up(R_up[0])
                );
    generate
        genvar i;
        for (i = 1; i <= m; i = i + 1)
        begin
             D_Cell D(
                .inRi(R[i]),
                .inRi_1(R_up[i-1]),
                .inSi(S[i]),
                .inTi_1(T[i-1]),
                .Switch(Switch), 
                .Reduce(Reduce), 
                .MultR(MultR),
                .outRi(R_next[i]),
                .outTi(T[i]),
                .outSi(S_next[i]),
                .Ri_up(R_up[i])
            );
        end
    endgenerate // D_CELL
    
    // Generate M Cells
    M_Cell M0(
        .inWix1(W[1]), 
        .inWi_1(1'b0),
        .inUi(U[0]),
        .inVi(V[0]),
        .inXi_1(X_1[0]),
        .inXim(Xm[0]),
        .Switch(Switch), 
        .Reduce(Reduce), 
        .MultU(MultU), 
        .Carry(Carry),
        .outWi(W[0]), 
        .outUi(U_next[0]), 
        .outVi(V_next[0])
    );
    
    M_Cell Mm(
        .inWix1(1'b0), 
        .inWi_1(W[m-2]),
        .inUi(U[m-1]),
        .inVi(V[m-1]),
        .inXi_1(X_1[m-1]),
        .inXim(Xm[m-1]),
        .Switch(Switch), 
        .Reduce(Reduce), 
        .MultU(MultU), 
        .Carry(Carry),
        .outWi(W[m-1]), 
        .outUi(U_next[m-1]), 
        .outVi(V_next[m-1])
    );
    
    generate
        genvar j;
        for (j = 1; j <= m - 2; j = j + 1)
        begin
             M_Cell M0(
                    .inWix1(W[j+1]), 
                    .inWi_1(W[j-1]),
                    .inUi(U[j]),
                    .inVi(V[j]),
                    .inXi_1(X_1[j]),
                    .inXim(Xm[j]),
                    .Switch(Switch), 
                    .Reduce(Reduce), 
                    .MultU(MultU), 
                    .Carry(Carry),
                    .outWi(W[j]), 
                    .outUi(U_next[j]), 
                    .outVi(V_next[j])
                );
        end
    endgenerate // M_CELL
    
    assign Carry = MultU ? W[m-1] : W[0]; 
    // even though the paper says u_(m-1) and u_0, it doesnt work 
    // since the value of u is never fixed, hence acc to the diagram we used W instead
    
    always@(posedge clk2)
    begin
        R <= R_next;
        S <= S_next;
        U <= U_next;
        V <= V_next;

    end
    
    initial
    begin
         R <= 8'd83;
         S <= 8'b10111111;
         U <= 8'b1;
         V <= 8'b0;
    end
    
    // this second clock works at 1 ns delay compared to the clk used to generate the control signals
    // the only reason is so that the control signals do not cause ambiguity at the edge 
    // and are settled at the gate inputs before they are consumed
    initial
    begin
    #1
        forever
        begin
            clk2 = 1'b0;
            #(t / 2);
            clk2 = 1'b1;
            #(t / 2);
        end
    end
endmodule
