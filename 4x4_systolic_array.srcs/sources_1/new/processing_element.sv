`timescale 1ns / 1ps

module pe #(
    parameter int DATA_WIDTH    = 8,
    parameter int ACC_WIDTH     = 32
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  valid,    // 0: start new accumulation (clear feedback), 1: accumulate

    // Data inputs
    input  logic [DATA_WIDTH-1:0] a_in,     // Activation from left
    input  logic [DATA_WIDTH-1:0] b_in,     // Weight from top

    // Data outputs
    output logic [DATA_WIDTH-1:0] a_out,    // Activation to right (via R2)
    output logic [DATA_WIDTH-1:0] b_out,    // Weight to bottom (via R3)
    output logic [ACC_WIDTH-1:0]  c_out     // Accumulated sum (from R1)  // Accumulated result
    );

// ==================================
// internal signals
// ==================================
logic [2*DATA_WIDTH-1:0] mult_prod;         // 16-bit product
logic [ACC_WIDTH-1:0] mult_prod_ext;        // 32-bit zero-extended product
logic [ACC_WIDTH-1:0] mux_out;              // feedback multiplexer output
logic [ACC_WIDTH-1:0] adder_sum ;            // sum of product + feedback
 
// =================================
// arithmatic units
// ================================= 
// step 1
assign mult_prod = a_in * b_in;
// step 2
assign mult_prod_ext = {{(ACC_WIDTH - 2*DATA_WIDTH){1'b0}}, mult_prod};
// step 3
assign adder_sum = mult_prod_ext + mux_out;

// ================================
// Sub-module instantiations
// ================================
// MUX: select's 0 when valid ==0 and selec't cout when valid =1
mux_21 feedback_mux(
    .ctrl(valid),
    .in(adder_sum),
    .out(mux_out)
);
// R1: Accumulator register
dff_reg_32b r1_accum(
    .clk(clk),
    .rst(rst),
    .d(adder_sum),
    .q(c_out)
);
// R2: vertical pipeline register for activation (A)
dff_reg_8b r2_activation(
    .clk(clk),
    .rst(rst),
    .d(a_in),
    .q(a_out)   
);
// R3: Horizontal pipeline register for weight (B)
dff_reg_8b r3_weight(
    .clk(clk),
    .rst(rst),
    .d(b_in),
    .q(b_out)
);

 
endmodule
