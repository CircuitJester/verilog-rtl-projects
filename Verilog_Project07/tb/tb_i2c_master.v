`timescale 1ns/1ps

module tb_i2c_master;

parameter DATA_WIDTH = 8;

reg clk;
reg rst;
reg start;
reg [DATA_WIDTH-1:0] data_in;
reg sda_in;
reg [15:0] clk_divider;

wire scl;
wire sda;
wire busy;

i2c_master #(
    .DATA_WIDTH(DATA_WIDTH)
) uut(

    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .sda_in(sda_in),
    .clk_divider(clk_divider),
    .scl(scl),
    .sda(sda),
    .busy(busy)

);

always #5 clk = ~clk;

initial
begin

    $dumpfile("waves/i2c_master.vcd");
    $dumpvars(0, tb_i2c_master);

    clk = 0;
    rst = 1;
    start = 0;

    data_in = 8'hA5;
    sda_in = 0;      // Simulate ACK
    clk_divider = 4;

    #20;
    rst = 0;
    #20;
    start = 1;
    #10;
    start = 0;
    #500;

    $finish;

end
endmodule