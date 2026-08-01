`timescale 1ns/1ps

module tb_multi_port_sdram_top;


// Inputs
reg clk;
reg rst;
reg cpu_req;
reg dma_req;
reg eth_req;
reg gpu_req;

// Outputs
wire [1:0] grant;
wire done;

// DUT
multi_port_sdram_top uut
(
    .clk(clk),
    .rst(rst),

    .cpu_req(cpu_req),
    .dma_req(dma_req),
    .eth_req(eth_req),
    .gpu_req(gpu_req),
    .grant(grant),
    .done(done)
);

// Clock
always #5 clk = ~clk;


// Test Sequence
initial
begin

    $dumpfile("waves/multi_port_sdram_top.vcd");
    $dumpvars(0,tb_multi_port_sdram_top);

    clk = 0;
    rst = 1;

    cpu_req = 0;
    dma_req = 0;
    eth_req = 0;
    gpu_req = 0;

    // Reset
    #20;
    rst = 0;

    // CPU Request
    #20;
    cpu_req = 1;
    #20;
    cpu_req = 0;

    // DMA Request
    #40;
    dma_req = 1;
    #20;
    dma_req = 0;

    // Ethernet Request
    #40;
    eth_req = 1;
    #20;
    eth_req = 0;

    // GPU Request
    #40;
    gpu_req = 1;
    #20;
    gpu_req = 0;

    // Simultaneous Requests
    #40;
    cpu_req = 1;
    dma_req = 1;
    eth_req = 1;
    gpu_req = 1;
    #40;
    cpu_req = 0;
    dma_req = 0;
    eth_req = 0;
    gpu_req = 0;

    #100;

    $finish;
end
endmodule