`timescale 1ns/1ps

module tb_dma_address_generator;

// Inputs
reg clk;
reg rst;

reg load;
reg increment;
reg [31:0] src_addr_in;
reg [31:0] dst_addr_in;


// Outputs
wire [31:0] src_addr;
wire [31:0] dst_addr;

// DUT
dma_address_generator uut
(
    .clk(clk),
    .rst(rst),

    .load(load),
    .increment(increment),
    .src_addr_in(src_addr_in),
    .dst_addr_in(dst_addr_in),
    .src_addr(src_addr),
    .dst_addr(dst_addr)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/dma_address_generator.vcd");
    $dumpvars(0, tb_dma_address_generator);

    clk = 0;
    rst = 1;

    load = 0;
    increment = 0;

    src_addr_in = 0;
    dst_addr_in = 0;

    // Reset
    #20;
    rst = 0;


    // Load Addresses

    #20;
    src_addr_in = 32'h00001000;
    dst_addr_in = 32'h00002000;

    load = 1;
    #10;
    load = 0;

    // Increment #1
    #20;
    increment = 1;
    #10;
    increment = 0;

    // Increment #2
    #20;
    increment = 1;
    #10;
    increment = 0;

    // Increment #3
    #20;
    increment = 1;
    #10;
    increment = 0;

    #30;

    $finish;

end
endmodule