`timescale 1ns/1ps

module tb_axi_slave_top;


// Inputs
reg clk;
reg rst;

// Write Interface
reg awvalid;
reg wvalid;
reg bready;

// Read Interface
reg arvalid;
reg rready;

// Address/Data
reg [31:0] address;
reg [31:0] write_data;

// Outputs
wire [31:0] read_data;

wire awready;
wire wready;
wire bvalid;
wire arready;
wire rvalid;

// DUT
axi_slave_top uut
(
    .clk(clk),
    .rst(rst),

    .awvalid(awvalid),
    .wvalid(wvalid),
    .bready(bready),
    .arvalid(arvalid),
    .rready(rready),

    .address(address),
    .write_data(write_data),

    .read_data(read_data),
    .awready(awready),
    .wready(wready),
    .bvalid(bvalid),
    .arready(arready),
    .rvalid(rvalid)
);

// Clock
always #5 clk = ~clk;

// Test
initial
begin

    $dumpfile("waves/axi_slave_top.vcd");
    $dumpvars(0,tb_axi_slave_top);

    clk = 0;
    rst = 1;

    awvalid = 0;
    wvalid = 0;
    bready = 0;
    arvalid = 0;
    rready = 0;
    address = 0;
    write_data = 0;

    // Reset
    #20;
    rst = 0;

    // Write REG0
    #20;

    address = 32'h00000000;
    write_data = 32'h11111111;

    awvalid = 1;
    wvalid = 1;

    #20;
    bready = 1;

    #10;
    awvalid = 0;
    wvalid = 0;
    bready = 0;

    // Read REG0
    #20;

    address = 32'h00000000;
    arvalid = 1;

    #20;
    rready = 1;

    #10;
    arvalid = 0;
    rready = 0;

    // Write REG2
    #30;

    address = 32'h00000008;
    write_data = 32'hAAAAAAAA;

    awvalid = 1;
    wvalid = 1;

    #20;
    bready = 1;

    #10;
    awvalid = 0;
    wvalid = 0;
    bready = 0;

    // Read REG2
    #20;

    address = 32'h00000008;
    arvalid = 1;

    #20;

    rready = 1;
    #10;
    arvalid = 0;
    rready = 0;

    // Invalid Address
    #30;

    address = 32'h00000020;

    awvalid = 1;
    wvalid = 1;
    #20;

    awvalid = 0;
    wvalid = 0;

    #40;
    $finish;

end
endmodule