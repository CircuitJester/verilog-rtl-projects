`timescale 1ns/1ps

module tb_axi_read_address;

parameter ADDR_WIDTH = 32;

// Inputs

reg clk;
reg rst;
reg start;
reg [ADDR_WIDTH-1:0] address;
reg arready;

// Outputs

wire [ADDR_WIDTH-1:0] araddr;
wire arvalid;
wire done;

// DUT

axi_read_address #

(

.ADDR_WIDTH(ADDR_WIDTH)
)

uut(

.clk(clk),
.rst(rst),
.start(start),
.address(address),
.arready(arready),
.araddr(araddr),
.arvalid(arvalid),
.done(done)

);

// Clock

always #5 clk = ~clk;

// Stimulus

initial
begin

    $dumpfile("waves/axi_read_address.vcd");
    $dumpvars(0, tb_axi_read_address);

    clk = 0;
    rst = 1;

    start = 0;
    address = 32'h00000000;
    arready = 0;

    // Reset

    #20;
    rst = 0;

    // Read Request
    
    #10;
    address = 32'h40001004;
    start = 1;
    #10;
    start = 0;

    // Slave accepts address

    #30;
    arready = 1;
    #10;
    arready = 0;

    #40;

    $finish;

end
endmodule