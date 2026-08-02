`timescale 1ns/1ps

module tb_spi_master_fsm;

// Inputs
reg clk;
reg rst;
reg start;
reg shift_done;

// Outputs
wire load;
wire shift_enable;
wire cs_enable;
wire done;

// DUT
spi_master_fsm uut
(
    .clk(clk),
    .rst(rst),
    .start(start),
    .shift_done(shift_done),
    .load(load),
    .shift_enable(shift_enable),
    .cs_enable(cs_enable),
    .done(done)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/spi_master_fsm.vcd");
    $dumpvars(0,tb_spi_master_fsm);

    clk = 0;
    rst = 1;
    start = 0;
    shift_done = 0;

    // Reset
    #20;
    rst = 0;

    // First SPI Transfer
    #20;
    start = 1;
    #10;
    start = 0;

    // Simulate Transfer Time
    #60;
    shift_done = 1;
    #10;
    shift_done = 0;

    // Second Transfer
    #40;
    start = 1;
    #10;
    start = 0;

    #60;
    shift_done = 1;
    #10;
    shift_done = 0;

    #50;
    $finish;

end
endmodule