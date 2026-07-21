`timescale 1ns/1ps

module tb_spi_slave;

parameter DATA_WIDTH = 8;

reg spi_clk;
reg rst;
reg cs;
reg mosi;
reg [DATA_WIDTH-1:0] tx_data;

wire miso;
wire busy;
wire [DATA_WIDTH-1:0] rx_data;

spi_slave #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .mosi(mosi),
    .tx_data(tx_data),
    .miso(miso),
    .busy(busy),
    .rx_data(rx_data)

);

always #5 spi_clk = ~spi_clk;

initial
begin

    $dumpfile("waves/spi_slave.vcd");
    $dumpvars(0,tb_spi_slave);

    spi_clk = 0;
    rst = 1;
    cs = 1;
    mosi = 0;
    tx_data = 8'b10110010;
    #20;
    rst = 0;
    #20;

    cs = 0;

    // Send 11001010

    mosi = 1; #10;
    mosi = 1; #10;
    mosi = 0; #10;
    mosi = 0; #10;
    mosi = 1; #10;
    mosi = 0; #10;
    mosi = 1; #10;
    mosi = 0; #10;

    cs = 1;
    #50;

    $finish;

end
endmodule