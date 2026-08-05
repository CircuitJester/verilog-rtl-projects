`timescale 1ns/1ps

module tb_dma_controller_fsm;


// Inputs
reg clk;
reg rst;

reg start;
reg transfer_done;

// Outputs
wire load;
wire increment;
wire decrement;
wire dma_busy;
wire dma_done;

// DUT
dma_controller_fsm uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .transfer_done(transfer_done),
    .load(load),
    .increment(increment),
    .decrement(decrement),

    .dma_busy(dma_busy),
    .dma_done(dma_done)
);


// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/dma_controller_fsm.vcd");
    $dumpvars(0,tb_dma_controller_fsm);

    clk = 0;
    rst = 1;

    start = 0;
    transfer_done = 0;

    // Reset
    #20;
    rst = 0;

    // Start DMA
    #20;
    start = 1;
    #10;
    start = 0;

    // First Transfer
    #60;

    // Second Transfer
    #60;

    // Finish DMA
    transfer_done = 1;
    #20;
    transfer_done = 0;

    #40;

    $finish;

end
endmodule