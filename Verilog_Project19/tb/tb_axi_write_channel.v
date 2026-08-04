`timescale 1ns/1ps

module tb_axi_write_channel;


// Inputs
reg clk;
reg rst;
reg awvalid;
reg wvalid;
reg bready;
reg address_valid;

// Outputs
wire awready;
wire wready;
wire bvalid;
wire write_enable;

// DUT
axi_write_channel uut
(
    .clk(clk),
    .rst(rst),
    .awvalid(awvalid),
    .wvalid(wvalid),
    .bready(bready),
    .address_valid(address_valid),
    .awready(awready),
    .wready(wready),
    .bvalid(bvalid),
    .write_enable(write_enable)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/axi_write_channel.vcd");
    $dumpvars(0, tb_axi_write_channel);

    clk = 0;
    rst = 1;

    awvalid = 0;
    wvalid = 0;
    bready = 0;
    address_valid = 0;

    // Reset
    #20;
    rst = 0;

    // Valid Write Transaction
    #20;
    awvalid = 1;
    wvalid = 1;
    address_valid = 1;
    #20;

    // CPU Accepts Response
    bready = 1;
    #10;
    bready = 0;
    awvalid = 0;
    wvalid = 0;
    address_valid = 0;

    // Invalid Address
    #30;
    awvalid = 1;
    wvalid = 1;
    address_valid = 0;
    #20;
    awvalid = 0;
    wvalid = 0;

    // Second Valid Write
    #30;
    awvalid = 1;
    wvalid = 1;
    address_valid = 1;
    #20;
    bready = 1;
    #10;
    bready = 0;
    awvalid = 0;
    wvalid = 0;
    address_valid = 0;


    #40;
    $finish;

end
endmodule