`timescale 1ns/1ps

module tb_spi_master_slave_system;

parameter DATA_WIDTH = 8;

// Master Inputs

reg clk;
reg rst;
reg start;
reg cpol;
reg [7:0] clk_divider;
reg [DATA_WIDTH-1:0] master_tx_data;

// Slave Inputs

reg [DATA_WIDTH-1:0] slave_tx_data;

// SPI Bus

wire spi_clk;
wire mosi;
wire miso;
wire cs;

// Outputs

wire master_busy;
wire slave_busy;

wire [DATA_WIDTH-1:0] master_rx_data;
wire [DATA_WIDTH-1:0] slave_rx_data;

// SPI MASTER

spi_master #(
    .DATA_WIDTH(DATA_WIDTH)
) master (

    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(master_tx_data),
    .miso(miso),
    .clk_divider(clk_divider),
    .cpol(cpol),
    .spi_clk(spi_clk),
    .mosi(mosi),
    .busy(master_busy),
    .cs(cs),
    .rx_data(master_rx_data)

);

// SPI SLAVE

spi_slave #(
    .DATA_WIDTH(DATA_WIDTH)
) slave (

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .mosi(mosi),
    .tx_data(slave_tx_data),
    .miso(miso),
    .busy(slave_busy),
    .rx_data(slave_rx_data)

);

// System Clock

always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/spi_master_slave_system.vcd");
    $dumpvars(0,tb_spi_master_slave_system);

    clk = 0;
    rst = 1;
    start = 0;
    cpol = 0;
    clk_divider = 8'd3;

    master_tx_data = 8'b10110010;

    slave_tx_data = 8'b11001100;

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