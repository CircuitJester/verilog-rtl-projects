`timescale 1ns/1ps

module tb_axi_slave_write_address;

parameter ADDR_WIDTH = 32;

// Inputs

reg clk;
reg rst;
reg [ADDR_WIDTH-1:0] awaddr;
reg awvalid;

// Outputs

wire awready;
wire [ADDR_WIDTH-1:0] address;
wire address_valid;

// DUT

axi_slave_write_address #

(
    .ADDR_WIDTH(ADDR_WIDTH)
)

uut
(
    .clk(clk),
    .rst(rst),
    .awaddr(awaddr),
    .awvalid(awvalid),
    .awready(awready),
    .address(address),
    .address_valid(address_valid)
);

// Clock


always #5 clk = ~clk;

// Stimulus

initial
begin

    $dumpfile("waves/axi_slave_write_address.vcd");
    $dumpvars(0, tb_axi_slave_write_address);

    clk = 0;
    rst = 1;

    awaddr  = 32'h00000000;
    awvalid = 0;

    // Reset

    #20;
    rst = 0;

    // First Write Address

    #20;
    awaddr  = 32'h00000004;
    awvalid = 1;
    #10;
    awvalid = 0;

    // Second Write Address

    #30;
    awaddr  = 32'h0000000C;
    awvalid = 1;
    #10;
    awvalid = 0;

    #40;

    $finish;

end
endmodule