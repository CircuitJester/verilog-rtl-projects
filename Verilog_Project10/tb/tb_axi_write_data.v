`timescale 1ns/1ps

module tb_axi_write_data;

parameter DATA_WIDTH = 32;

reg clk;
reg rst;
reg start;
reg [DATA_WIDTH-1:0] data;
reg wready;

wire [DATA_WIDTH-1:0] wdata;
wire wvalid;
wire done;

axi_write_data #(
    .DATA_WIDTH(DATA_WIDTH)
) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data(data),
    .wready(wready),
    .wdata(wdata),
    .wvalid(wvalid),
    .done(done)

);


always #5 clk = ~clk;

initial 

begin

    $dumpfile("waves/axi_write_data.vcd");
    $dumpvars(0, tb_axi_write_data);

    clk = 0;
    rst = 1;

    start = 0;
    data = 32'h00000000;
    wready = 0;

    #20;
    rst = 0;

    #10;
    data = 32'h12345678;
    start = 1;

    #10;
    start = 0;

    #30;
    wready = 1;

    #10;
    wready = 0;

    #40;
    $finish;

end

endmodule