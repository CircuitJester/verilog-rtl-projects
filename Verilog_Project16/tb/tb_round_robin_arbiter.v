`timescale 1ns/1ps

module tb_round_robin_arbiter;

// Inputs
reg clk;
reg rst;
reg cpu_req;
reg dma_req;
reg eth_req;
reg gpu_req;

// Outputs
wire [1:0] grant;
wire valid;

// DUT
round_robin_arbiter uut
(
    .clk(clk),
    .rst(rst),
    .cpu_req(cpu_req),
    .dma_req(dma_req),
    .eth_req(eth_req),
    .gpu_req(gpu_req),
    .grant(grant),
    .valid(valid)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/round_robin_arbiter.vcd");
    $dumpvars(0, tb_round_robin_arbiter);

    clk = 0;
    rst = 1;

    cpu_req = 0;
    dma_req = 0;
    eth_req = 0;
    gpu_req = 0;

    // Reset
    #20;
    rst = 0;

    // All Requesters Active
    cpu_req = 1;
    dma_req = 1;
    eth_req = 1;
    gpu_req = 1;

    // Allow several arbitration cycles
    #100;

    // CPU Removed
    cpu_req = 0;
    #60;

    // DMA Removed
    dma_req = 0;
    #60;

    // Ethernet Removed
    eth_req = 0;
    #60;

    // GPU Removed
    gpu_req = 0;
    #40;
    $finish;

end
endmodule