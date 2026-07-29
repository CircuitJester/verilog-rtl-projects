`timescale 1ns/1ps

module tb_i2c_clock_generator;

parameter DIVIDER = 4;

// Inputs
reg clk;
reg rst;

// Outputs
wire scl;

// DUT
i2c_clock_generator #

(
    .DIVIDER(DIVIDER)
)
uut

(
    .clk(clk),
    .rst(rst),
    .scl(scl)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/i2c_clock_generator.vcd");
    $dumpvars(0,tb_i2c_clock_generator);

    clk = 0;
    rst = 1;

    // Reset
    #20;
    rst = 0;

    // Run
    #300;

    $finish;
end
endmodule