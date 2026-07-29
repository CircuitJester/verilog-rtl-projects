`timescale 1ns/1ps

module tb_i2c_master_fsm;

// Inputs
reg clk;
reg rst;
reg start;
reg shift_done;
reg ack;
reg error;

// Outputs
wire start_cmd;
wire load;
wire shift;
wire check_ack;
wire stop_cmd;
wire busy;
wire done;

// DUT
i2c_master_fsm uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .shift_done(shift_done),
    .ack(ack),
    .error(error),
    .start_cmd(start_cmd),
    .load(load),
    .shift(shift),
    .check_ack(check_ack),
    .stop_cmd(stop_cmd),
    .busy(busy),
    .done(done)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/i2c_master_fsm.vcd");
    $dumpvars(0,tb_i2c_master_fsm);

    clk = 0;
    rst = 1;

    start = 0;
    shift_done = 0;
    ack = 0;
    error = 0;

    // Reset
    #20;
    rst = 0;

    // Start Transaction
    #20;
    start = 1;
    #10;
    start = 0;

    // Simulate Shift Complete
    #40;
    shift_done = 1;
    #10;
    shift_done = 0;

    // ACK Received
    #20;
    ack = 1;
    #10;
    ack = 0;

    #80;

    $finish;
end
endmodule