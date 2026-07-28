`timescale 1ns/1ps

module tb_spi_chip_select;

// Inputs
reg clk;
reg rst;
reg start;
reg transfer_done;

// Outputs
wire cs_n;
wire busy;

// DUT
spi_chip_select uut
(
    .clk(clk),
    .rst(rst),
    .start(start),
    .transfer_done(transfer_done),
    .cs_n(cs_n),
    .busy(busy)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/spi_chip_select.vcd");
    $dumpvars(0, tb_spi_chip_select);

    clk = 0;
    rst = 1;

    start = 0;
    transfer_done = 0;

    // Reset
    #20;
    rst = 0;

    // First SPI Transaction
    #20;
    start = 1;
    #10;
    start = 0;
    #80;
    transfer_done = 1;
    #10;
    transfer_done = 0;

    // Second SPI Transaction
    #30;
    start = 1;
    #10;
    start = 0;
    #60;
    transfer_done = 1;
    #10;
    transfer_done = 0;

    #40;

    $finish;
end
endmodule