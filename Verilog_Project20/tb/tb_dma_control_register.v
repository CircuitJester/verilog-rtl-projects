`timescale 1ns/1ps

module tb_dma_control_register;


// Inputs
reg clk;
reg rst;

reg start;
reg dma_busy;
reg dma_done;

// Outputs
wire start_reg;
wire busy_reg;
wire done_reg;

// DUT
dma_control_register uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .dma_busy(dma_busy),
    .dma_done(dma_done),
    .start_reg(start_reg),
    .busy_reg(busy_reg),
    .done_reg(done_reg)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/dma_control_register.vcd");
    $dumpvars(0, tb_dma_control_register);

    clk = 0;
    rst = 1;

    start = 0;
    dma_busy = 0;
    dma_done = 0;

    // Reset
    #20;
    rst = 0;

    // CPU Starts DMA
    #20;
    start = 1;
    #10;
    start = 0;

    // DMA Busy
    #20;
    dma_busy = 1;
    #30;

    // DMA Complete
    dma_busy = 0;
    dma_done = 1;
    #20;

    // Clear Done
    dma_done = 0;

    #20;
    $finish;

end
endmodule