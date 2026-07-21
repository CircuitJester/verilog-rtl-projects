`timescale 1ns/1ps

module tb_spi_slave_shift_register;

parameter DATA_WIDTH = 8;

reg spi_clk;
reg rst;
reg cs;
reg mosi;
reg load;
reg [DATA_WIDTH-1:0] tx_data;

wire miso;
wire [DATA_WIDTH-1:0] rx_data;

spi_slave_shift_register #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .mosi(mosi),
    .load(load),
    .tx_data(tx_data),
    .miso(miso),
    .rx_data(rx_data)

);

always #5 spi_clk = ~spi_clk;

initial
begin

    $dumpfile("waves/spi_slave_shift_register.vcd");
    $dumpvars(0,tb_spi_slave_shift_register);

    spi_clk = 0;
    rst = 1;
    cs = 1;
    load = 0;
    mosi = 0;

    tx_data = 8'b10110010;

    #20;
    rst = 0;
    #10;
    load = 1;
    #10;
    load = 0;
    cs = 0;

    // Sending 11001010 through MOSI

    mosi = 1; #10;
    mosi = 1; #10;
    mosi = 0; #10;
    mosi = 0; #10;
    mosi = 1; #10;
    mosi = 0; #10;
    mosi = 1; #10;
    mosi = 0; #10;

    cs = 1;
    #40;

    $finish;
end
endmodule