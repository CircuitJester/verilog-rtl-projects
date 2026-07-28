`timescale 1ns/1ps

module tb_spi_clock_generator;

// Parameter

parameter DIVIDER = 4;

// Inputs

reg clk;
reg rst;

// Output

wire spi_clk;

// DUT

spi_clock_generator #

(
    .DIVIDER(DIVIDER)
)

uut
(
    .clk(clk),
    .rst(rst),
    .spi_clk(spi_clk)
);

// Clock Generation

always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/spi_clock_generator.vcd");
    $dumpvars(0, tb_spi_clock_generator);

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