`timescale 1ns/1ps

module tb_bus_multiplexer;

// Inputs
reg [1:0] grant;

reg [15:0] cpu_addr;
reg [15:0] dma_addr;
reg [15:0] eth_addr;
reg [15:0] gpu_addr;

reg [7:0] cpu_data;
reg [7:0] dma_data;
reg [7:0] eth_data;
reg [7:0] gpu_data;

// Outputs
wire [15:0] addr_out;
wire [7:0] data_out;

// DUT
bus_multiplexer uut
(
    .grant(grant),
    .cpu_addr(cpu_addr),
    .dma_addr(dma_addr),
    .eth_addr(eth_addr),
    .gpu_addr(gpu_addr),
    .cpu_data(cpu_data),
    .dma_data(dma_data),
    .eth_data(eth_data),
    .gpu_data(gpu_data),
    .addr_out(addr_out),
    .data_out(data_out)
);

// Test Sequence
initial
begin

    $dumpfile("waves/bus_multiplexer.vcd");
    $dumpvars(0, tb_bus_multiplexer);

    // Assign Test Values
    cpu_addr = 16'h1000;
    dma_addr = 16'h2000;
    eth_addr = 16'h3000;
    gpu_addr = 16'h4000;

    cpu_data = 8'hAA;
    dma_data = 8'hBB;
    eth_data = 8'hCC;
    gpu_data = 8'hDD;

    // CPU Selected
    grant = 2'b00;
    #20;

    // DMA Selected
    grant = 2'b01;
    #20;

    // Ethernet Selected
    grant = 2'b10;
    #20;

    // GPU Selected
    grant = 2'b11;
    #20;

    // Back to CPU
    grant = 2'b00;
    #20;
    $finish;

end
endmodule