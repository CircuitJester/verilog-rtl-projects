`timescale 1ns/1ps

module tb_spi_chip_select;

// Inputs
reg clk;
reg rst;
reg cs_enable;

// Output
wire cs_n;

// DUT
spi_chip_select uut
(
    .clk(clk),
    .rst(rst),
    .cs_enable(cs_enable),
    .cs_n(cs_n)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/spi_chip_select.vcd");
    $dumpvars(0,tb_spi_chip_select);

    clk = 0;
    rst = 1;
    cs_enable = 0;

    // Reset
    #20;
    rst = 0;

    // Enable SPI Slave
    #20;
    cs_enable = 1;
    #40;

    // Disable SPI Slave
    cs_enable = 0;
    #40;

    // Enable Again
    cs_enable = 1;
    #40;

    // Disable Again
    cs_enable = 0;
    #40;

    $finish;

end
endmodule