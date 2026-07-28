`timescale 1ns/1ps

module tb_spi_master_top;

parameter DATA_WIDTH = 8;
parameter CLOCK_DIVIDER = 4;

// Inputs
reg clk;
reg rst;
reg start;
reg [DATA_WIDTH-1:0] tx_data;
reg miso;

// Outputs
wire mosi;
wire spi_clk;
wire cs_n;
wire [DATA_WIDTH-1:0] rx_data;
wire busy;

// DUT
spi_master_top #

(
    .DATA_WIDTH(DATA_WIDTH),
    .CLOCK_DIVIDER(CLOCK_DIVIDER)
)
uut

(
    .clk(clk),
    .rst(rst),

    .start(start),
    .tx_data(tx_data),
    .miso(miso),
    .mosi(mosi),
    .spi_clk(spi_clk),
    .cs_n(cs_n),
    .rx_data(rx_data),
    .busy(busy)
);
// Clock
always #5 clk = ~clk;

// Test
initial
begin

    $dumpfile("waves/spi_master_top.vcd");
    $dumpvars(0,tb_spi_master_top);

    clk = 0;
    rst = 1;
    start = 0;
    tx_data = 8'hA5;
    miso = 0;

    #20;
    rst = 0;

    // First Transfer
    #20;
    start = 1;
    #10;
    start = 0;

    // Incoming SPI bits
    #20; miso = 0;
    #20; miso = 0;
    #20; miso = 1;
    #20; miso = 1;
    #20; miso = 1;
    #20; miso = 1;
    #20; miso = 0;
    #20; miso = 0;

    // Second Transfer
    #100;

    tx_data = 8'h5A;
    start = 1;
    #10;
    start = 0;


    #20; miso = 1;
    #20; miso = 1;
    #20; miso = 0;
    #20; miso = 0;
    #20; miso = 0;
    #20; miso = 0;
    #20; miso = 1;
    #20; miso = 1;

    #100;

    $finish;
end
endmodule