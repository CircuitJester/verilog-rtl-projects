`timescale 1ns/1ps

module tb_axi_slave_read_address;

parameter ADDR_WIDTH = 32;

// Inputs

reg clk;
reg rst;
reg [ADDR_WIDTH-1:0] araddr;
reg arvalid;

// Outputs

wire arready;
wire [ADDR_WIDTH-1:0] address;
wire address_valid;

// DUT

axi_slave_read_address #

(
    .ADDR_WIDTH(ADDR_WIDTH)
)

uut

(
    .clk(clk),
    .rst(rst),
    .araddr(araddr),
    .arvalid(arvalid),
    .arready(arready),
    .address(address),
    .address_valid(address_valid)
);

// Clock

always #5 clk = ~clk;

// Stimulus

initial
begin

    $dumpfile("waves/axi_slave_read_address.vcd");
    $dumpvars(0, tb_axi_slave_read_address);

    clk = 0;
    rst = 1;

    araddr  = 32'h00000000;
    arvalid = 0;

    // Reset

    #20;
    rst = 0;

    // First Read Address

    #20;
    araddr  = 32'h00000008;
    arvalid = 1;
    #10;
    arvalid = 0;

    // Second Read Address

    #30;
    araddr  = 32'h0000000C;
    arvalid = 1;
    #10;
    arvalid = 0;

    #40;

    $finish;

end
endmodule