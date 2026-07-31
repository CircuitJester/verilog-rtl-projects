`timescale 1ns/1ps

module tb_sdram_main_fsm;

// Inputs
reg clk;
reg rst;
reg init_done;
reg refresh_request;
reg read_request;
reg write_request;
reg read_done;
reg write_done;

// Outputs
wire start_init;
wire start_refresh;
wire start_read;
wire start_write;

// DUT
sdram_main_fsm uut
(
    .clk(clk),
    .rst(rst),

    .init_done(init_done),
    .refresh_request(refresh_request),
    .read_request(read_request),
    .write_request(write_request),
    .read_done(read_done),
    .write_done(write_done),
    .start_init(start_init),
    .start_refresh(start_refresh),
    .start_read(start_read),
    .start_write(start_write)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_main_fsm.vcd");
    $dumpvars(0,tb_sdram_main_fsm);

    clk = 0;
    rst = 1;

    init_done = 0;
    refresh_request = 0;
    read_request = 0;
    write_request = 0;
    read_done = 0;
    write_done = 0;

    // Reset
    #20;
    rst = 0;

    // Finish Initialization
    #40;
    init_done = 1;
    #10;
    init_done = 0;

    // Refresh Request
    #40;
    refresh_request = 1;
    #10;
    refresh_request = 0;

    // Read Request
    #40;
    read_request = 1;
    #10;
    read_request = 0;
    #40;
    read_done = 1;
    #10;
    read_done = 0;

    // Write Request
    #40;
    write_request = 1;
    #10;
    write_request = 0;
    #40;
    write_done = 1;
    #10;
    write_done = 0;

    #100;
    $finish;

end
endmodule