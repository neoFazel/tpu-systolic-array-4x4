`timescale 1ns / 1ps

module pe_tb();

parameter int DATA_WIDTH    = 8;
parameter int ACC_WIDTH     = 32;

logic                       clk;
logic                       rst;
logic                       valid;
logic [DATA_WIDTH-1:0]      a_in;
logic [DATA_WIDTH-1:0]      b_in;
logic [DATA_WIDTH-1:0]      a_out;
logic [DATA_WIDTH-1:0]      b_out;
logic [ACC_WIDTH-1:0]       c_out;

// PE instantiation
pe DUV(
    .clk(clk),
    .rst(rst),
    .valid(valid),
    .a_in(a_in),
    .b_in(b_in),
    .a_out(a_out),
    .b_out(b_out),
    .c_out(c_out)
);


task scoreboard(
    input logic [7:0]  a_golden, b_golden,
    input logic [31:0] c_golden,
    input logic [7:0]  a_actual, b_actual,
    input logic [31:0] c_actual
);
    begin
        $display("==================================================");
        $display("golden datas ---> a_out: %0d, b_out: %0d, c_out: %0d", a_golden, b_golden, c_golden);
        $display("actual datas ---> a_out: %0d, b_out: %0d, c_out: %0d. at: %0t", a_actual, b_actual, c_actual, $time());        
        // Self-Checking
        if ((a_actual === a_golden) && (b_actual === b_golden) && (c_actual === c_golden)) begin
            $display("[PASS] Results match successfully");
        end else begin
            $display("[FAIL] Mismatch detected!");
        end
        $display("==================================================");  
    end
endtask: scoreboard


always #5 clk = ~clk;

initial begin
    // initialize signals
    clk     = 0;
    rst     = 1;
    valid   = 0;
    a_in    = 0;
    b_in    = 0;
    #12;
    rst     = 0;
    
    // verify reset behaviour
    a_in = 8'h03;
    b_in = 8'h0A;
    scoreboard(8'b0, 8'b0, 32'b0, a_out, b_out, c_out);
    #16;
    rst = 1;
    @(posedge clk)
    rst = 0;
    
    // verify single MAC operation
    $display("time: %t", $time());
    a_in    = 8'h03;
    b_in    = 8'h10;
    #12;
    scoreboard(8'h03, 8'h10, 32'd48, a_out, b_out, c_out);
    
    // accumulation sequence
    #5;
    a_in    = 8'h01;
    b_in    = 8'h02;
    #8;
    a_in    = 8'h03;
    b_in    = 8'h01;
    valid   = 1'b1;
    @(posedge clk);
    #2;
    scoreboard(8'h03, 8'h01, 32'd05, a_out, b_out, c_out);
    #7;
    valid = 0;
    
    
end


initial begin
    #500;
    $finish();
end

endmodule
