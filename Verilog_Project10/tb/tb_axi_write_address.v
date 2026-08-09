`timescale 1ns/1ps

module tb_axi_write_address;


parameter ADDR_WIDTH = 32;

reg clk;
reg rst;
reg start;
reg [ADDR_WIDTH-1:0] address;
reg awready;

wire [ADDR_WIDTH-1:0] awaddr;
wire awvalid;
wire done;

axi_write_address #(
    .ADDR_WIDTH(ADDR_WIDTH)
) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .address(address),
    .awready(awready),
    .awaddr(awaddr),
    .awvalid(awvalid),
    .done(done)

);


always #5 clk = ~clk;


initial 

begin

    $dumpfile("waves/axi_write_address.vcd");
    $dumpvars(0, tb_axi_write_address);

    clk = 0;
    rst = 1;

    start = 0;
    address = 32'h00000000;
    awready = 0;

    #20;
    rst = 0;

    #10;
    address = 32'h40001000;
    start = 1;

    #10;
    start = 0;

    #30;
    awready = 1;

    #10;
    awready = 0;

    #40;
    $finish;
end

endmodule