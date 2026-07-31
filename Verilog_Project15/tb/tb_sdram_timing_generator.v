`timescale 1ns/1ps

module tb_sdram_timing_generator;

// Parameters
parameter WAIT_CYCLES = 8;

// Inputs
reg clk;
reg rst;
reg start;

// Outputs
wire done;

// DUT
sdram_timing_generator #

(
    .WAIT_CYCLES(WAIT_CYCLES)
)

uut
(
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_timing_generator.vcd");
    $dumpvars(0,tb_sdram_timing_generator);

    clk = 0;
    rst = 1;
    start = 0;

    #20;
    rst = 0;

    // First Delay
    #20;
    start = 1;
    #100;
    start = 0;

    // Second Delay
    #40;
    start = 1;
    #100;
    start = 0;

    #50;
    $finish;

end
endmodule