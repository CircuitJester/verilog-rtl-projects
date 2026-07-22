`timescale 1ns/1ps

module tb_spi_master_v2;

parameter DATA_WIDTH = 8;

reg clk;
reg rst;
reg start;
reg miso;
reg cpol;
reg [7:0] clk_divider;
reg [DATA_WIDTH-1:0] data_in;

wire spi_clk;
wire mosi;
wire busy;
wire cs;
wire [DATA_WIDTH-1:0] rx_data;

spi_master #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (

    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .miso(miso),
    .clk_divider(clk_divider),
    .cpol(cpol),
    .spi_clk(spi_clk),
    .mosi(mosi),
    .busy(busy),
    .cs(cs),

    .rx_data(rx_data)

);

always #5 clk = ~clk;
initial begin
    $dumpfile("waves/spi_master_v2.vcd");
    $dumpvars(0, tb_spi_master_v2);
end

initial
begin

    clk = 0;
    rst = 1;
    start = 0;
    cpol = 0;
    clk_divider = 8'd3;
    data_in = 8'b10110010;

    miso = 0;
    #20;
    rst = 0;
    #20;
    start = 1;
    #10;
    start = 0;

end

always @(posedge spi_clk)
begin
    miso <= ~miso;

end

initial
begin

    #500;

    $finish;

end
endmodule