`timescale 1ns/1ps

module tb_arbiter_fsm;

// Inputs
reg clk;
reg rst;
reg request_pending;
reg transfer_done;

// Outputs
wire read_fifo;
wire grant_enable;
wire done;

// DUT
arbiter_fsm uut
(
    .clk(clk),
    .rst(rst),
    .request_pending(request_pending),
    .transfer_done(transfer_done),
    .read_fifo(read_fifo),
    .grant_enable(grant_enable),
    .done(done)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/arbiter_fsm.vcd");
    $dumpvars(0, tb_arbiter_fsm);

    clk = 0;
    rst = 1;
    request_pending = 0;
    transfer_done = 0;

    // Reset
    #20;
    rst = 0;

    // First Request
    #20;
    request_pending = 1;
    #10;
    request_pending = 0;

    // SDRAM Busy duration
    #40;

    // Transfer Complete
    transfer_done = 1;
    #10;
    transfer_done = 0;

    // Second Request
    #40;
    request_pending = 1;
    #10;
    request_pending = 0;

    // Complete Again
    #40;
    transfer_done = 1;
    #10;
    transfer_done = 0;

    #50;
    $finish;

end
endmodule