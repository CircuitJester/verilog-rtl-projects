`timescale 1ns/1ps

module tb_dma_top;

// Inputs
reg clk;
reg rst;
reg start;

reg [31:0] src_addr_in;
reg [31:0] dst_addr_in;
reg [15:0] transfer_length;

// Outputs
wire [31:0] src_addr;
wire [31:0] dst_addr;

wire dma_busy;
wire dma_done;

// DUT
dma_top uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .src_addr_in(src_addr_in),
    .dst_addr_in(dst_addr_in),

    .transfer_length(transfer_length),

    .src_addr(src_addr),
    .dst_addr(dst_addr),
    .dma_busy(dma_busy),
    .dma_done(dma_done)
);

// Clock
always #5 clk = ~clk;

// Test
initial
begin

    $dumpfile("waves/dma_top.vcd");
    $dumpvars(0,tb_dma_top);

    clk = 0;
    rst = 1;

    start = 0;

    src_addr_in = 32'h00001000;
    dst_addr_in = 32'h00002000;

    transfer_length = 16'd4;

    // Reset
    #20;
    rst = 0;

    // Start DMA
    #20;
    start = 1;
    #10;
    start = 0;


    #250;
    $finish;

end

endmodule