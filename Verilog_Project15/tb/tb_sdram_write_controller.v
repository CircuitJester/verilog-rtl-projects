`timescale 1ns/1ps

module tb_sdram_write_controller;

// Inputs
reg clk;
reg rst;
reg write_request;
reg delay_done;

// Outputs
wire start_delay;
wire activate;
wire write_cmd;
wire write_done;

// DUT
sdram_write_controller uut
(
    .clk(clk),
    .rst(rst),

    .write_request(write_request),
    .delay_done(delay_done),
    .start_delay(start_delay),
    .activate(activate),
    .write_cmd(write_cmd),
    .write_done(write_done)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_write_controller.vcd");
    $dumpvars(0, tb_sdram_write_controller);

    clk = 0;
    rst = 1;

    write_request = 0;
    delay_done = 0;

    // Reset
    #20;
    rst = 0;

    // First Write
    #20;
    write_request = 1;
    #10;
    write_request = 0;

    // tRCD Finished
    #60;
    delay_done = 1;
    #10;
    delay_done = 0;

    // Second Write
    #40;
    write_request = 1;
    #10;
    write_request = 0;
    #60;
    delay_done = 1;
    #10;
    delay_done = 0;

    #100;
    $finish;

end
endmodule