`timescale 1ns/1ps

module tb_sdram_read_controller;

// Inputs
reg clk;
reg rst;
reg read_request;
reg delay_done;

// Outputs
wire start_delay;
wire activate;
wire read_cmd;
wire read_done;

// DUT
sdram_read_controller uut
(
    .clk(clk),
    .rst(rst),

    .read_request(read_request),
    .delay_done(delay_done),
    .start_delay(start_delay),
    .activate(activate),
    .read_cmd(read_cmd),
    .read_done(read_done)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_read_controller.vcd");
    $dumpvars(0, tb_sdram_read_controller);

    clk = 0;
    rst = 1;

    read_request = 0;
    delay_done = 0;

    #20;
    rst = 0;

    // First Read
    #20;
    read_request = 1;
    #10;
    read_request = 0;

    // tRCD Finished
    #60;
    delay_done = 1;
    #10;
    delay_done = 0;

    // Second Read
    #40;
    read_request = 1;
    #10;
    read_request = 0;
    #60;
    delay_done = 1;
    #10;
    delay_done = 0;

    #100;
    $finish;

end
endmodule