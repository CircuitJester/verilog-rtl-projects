`timescale 1ns/1ps

module tb_priority_encoder;

// Inputs
reg cpu_req;
reg dma_req;
reg eth_req;
reg gpu_req;


// Outputs
wire [1:0] grant;
wire valid;

// DUT
priority_encoder uut
(
    .cpu_req(cpu_req),
    .dma_req(dma_req),
    .eth_req(eth_req),
    .gpu_req(gpu_req),
    .grant(grant),
    .valid(valid)
);

// Test Sequence
initial
begin

    $dumpfile("waves/priority_encoder.vcd");
    $dumpvars(0,tb_priority_encoder);

    // No Requests
    cpu_req = 0;
    dma_req = 0;
    eth_req = 0;
    gpu_req = 0;

    #20;

    // CPU Only
    cpu_req = 1;
    #20;
    cpu_req = 0;

    // DMA Only
    dma_req = 1;
    #20;
    dma_req = 0;

    // Ethernet Only
    eth_req = 1;
    #20;
    eth_req = 0;

    // GPU Only
    gpu_req = 1;
    #20;
    gpu_req = 0;

    // CPU + DMA
    cpu_req = 1;
    dma_req = 1;
    #20;
    cpu_req = 0;
    dma_req = 0;

    // DMA + ETH
    dma_req = 1;
    eth_req = 1;
    #20;
    dma_req = 0;
    eth_req = 0;

    // ETH + GPU
    eth_req = 1;
    gpu_req = 1;
    #20;
    eth_req = 0;
    gpu_req = 0;

    // All Active
    cpu_req = 1;
    dma_req = 1;
    eth_req = 1;
    gpu_req = 1;
    #20;
    cpu_req = 0;
    dma_req = 0;
    eth_req = 0;
    gpu_req = 0;

    #20;
    $finish;

end
endmodule