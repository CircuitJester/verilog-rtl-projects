`timescale 1ns/1ps

module tb_i2c_start_stop;

// Inputs
reg clk;
reg rst;
reg start_cmd;
reg stop_cmd;
reg scl;

// Outputs
wire sda;
wire busy;

// DUT
i2c_start_stop uut
(
    .clk(clk),
    .rst(rst),

    .start_cmd(start_cmd),
    .stop_cmd(stop_cmd),
    .scl(scl),
    .sda(sda),
    .busy(busy)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/i2c_start_stop.vcd");
    $dumpvars(0,tb_i2c_start_stop);

    clk = 0;
    rst = 1;

    start_cmd = 0;
    stop_cmd = 0;
    scl = 1;

    // Reset
    #20;
    rst = 0;

    // Generate START
    #20;
    start_cmd = 1;
    #10;
    start_cmd = 0;

    // Keep Bus Busy
    #60;

    // Generate STOP
    stop_cmd = 1;
    #10;
    stop_cmd = 0;

    #80;
    $finish;

end
endmodule