`timescale 1ns/1ps

module tb_axi_read_channel;

// Inputs
reg clk;
reg rst;
reg arvalid;
reg rready;
reg address_valid;

// Outputs
wire arready;
wire rvalid;
wire read_enable;

// DUT
axi_read_channel uut
(
    .clk(clk),
    .rst(rst),

    .arvalid(arvalid),
    .rready(rready),
    .address_valid(address_valid),
    .arready(arready),
    .rvalid(rvalid),
    .read_enable(read_enable)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/axi_read_channel.vcd");
    $dumpvars(0,tb_axi_read_channel);

    clk = 0;
    rst = 1;

    arvalid = 0;
    rready = 0;
    address_valid = 0;

    // Reset
    #20;
    rst = 0;

    // First Valid Read
    #20;
    arvalid = 1;
    address_valid = 1;
    #20;
    // CPU Accepts Data
    rready = 1;

    #10;
    rready = 0;
    arvalid = 0;
    address_valid = 0;

    // Invalid Address
    #30;
    arvalid = 1;
    address_valid = 0;

    #20;
    arvalid = 0;

    // Second Valid Read
    #30;
    arvalid = 1;
    address_valid = 1;

    #20;
    rready = 1;
    #10;
    rready = 0;
    arvalid = 0;
    address_valid = 0;

    #40;
    $finish;

end
endmodule