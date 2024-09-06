`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 10:22:50
// Design Name: 
// Module Name: tb
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

// This module implements the Itoh Tsujii algorithm using repeated squaring and a binary Karatsuba multiplier
// for GF(2^7) with generator f(x) = x^7+x^5+x^4+x^3+x^2+x^1+1 for finite field inversion
module tb(
    
    );
    
    //generating a clock signal
    reg clk;
    localparam t = 50;    
    initial
    begin
        forever
        begin
            clk = 1'b1;
            #(t / 2);
            clk = 1'b0;
            #(t / 2);
        end
    end
  
    reg [7 : 0] a = 8'b00011011; // value to be inverted
     
    // in iteration i, holds value beta_k = a^(2^k - 1) at the ith position of the addition chain
    // in the last iteration, holds (beta_(m-1))^2 which is the required inverse value
    reg [7 : 0] mout;
    
    // carries the value of the product of the inputs given to the karatsuba multipier
    wire [14 : 0] mult_out;
    wire en; // enable for the result register mout, which is turned OFF when inverse is calculated
    wire [1:0] n_cascade, sel_read, sel_write, sel_mux1, sel_mux2;
   
    control_logic ctrl(.CLK(clk), 
                        .n_cascade(n_cascade), // selects n for output (input)^(2^n) in the cascaded squaring block
                        .sel_read(sel_read), // select register to read data from
                        .sel_write(sel_write), // select register to write data to in the regbank
                        .sel_mux1(sel_mux1), 
                        .sel_mux2(sel_mux2),
                        .en(en)
                        );
    wire [7:0] storage_out, mult_1, mult_2, cascade_out, mod_out;
    
    // since we are using an addition chain, we need arbitrary values computed earlier, and hence need to store them
    // in the addition chain we developed for GF(2^7) -> {1,2,3,6} since m-1 = 6, it so happens that we do not need to 
    // read from the bank, but we still made the circuitry for it to use in the future
    storage register_bank(.CLK(clk), .sel_read(sel_read), .sel_write(sel_write), .data_write(mout), .data_read(storage_out));
    
    // the cascaded squaring block, which may have considerable path delays, and is coded specifically for the
    // irreducible polynomial in question
    cascade casc(.din(mout), .select(n_cascade), .dout(cascade_out));
    
    // the two MUX blocks which decide the multiplicands of the Karatsuba multiplier
    mux4x1 mux1(.d0(a), .d1(storage_out), .d2(mout), .sel(sel_mux1), .dout(mult_1));
    mux4x1 mux2(.d0(a), .d1(cascade_out), .d2(mout), .sel(sel_mux2), .dout(mult_2));
    
    // we implemented an 8-bit binary Karatsuba multiplier since it was more computationally
    // efficient to pad an extra bit for m=7 which is small, as out focus was to compare this 
    // with the euclidean algorithm for the same Galois field
    // this is a general Karatsuba multiplier which we implemented
    ckm_8 karatsuba_multiplier(.a(mult_1), .b(mult_2), .c(mult_out));
    
    // takes the output of the multiplier and computes its equivalent value in the GF in question
    modulo MOD(.d(mult_out), .dmodf(mod_out));
    
    // instead of generating a separate clock, this time we just 
    // used the alternating edges of the clock signal to account 
    // for the settling time of the control and data signals at the registers
    always @ (negedge clk)
    begin
        if(en) begin
            mout <= mod_out;
        end
    end
    
endmodule
