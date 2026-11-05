`timescale 1ns / 1ps

module dff_reg_32b #(
    parameter DATA_WIDTH = 32
)(
    input   clk,
            rst,
    
    // data input and output
    input logic [DATA_WIDTH-1:0] d,
    output logic [DATA_WIDTH-1:0] q
    );
    
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            q <= '0;
        end else begin
            q <= d;
        end
    end
    
endmodule
