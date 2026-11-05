`timescale 1ns / 1ps

module mux_21 #(
    parameter int ACC_WIDTH = 32
)(
    // control signal
    input ctrl,
    
    // inputs
    input logic [ACC_WIDTH-1:0] in,
    
    // output
    output logic [ACC_WIDTH-1:0] out
    );
    
    assign out = ctrl ? in : '0; 
    
endmodule
