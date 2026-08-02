`timescale 1ns/1ps

module tb_spi_master_top;

// Parameters
parameter DATA_WIDTH = 8;
parameter DIVIDER = 4;

// Inputs
reg clk;
reg rst;
reg start;
reg [DATA_WIDTH-1:0] tx_data;
reg miso;


// Outputs
wire spi_clk;
wire mosi;
wire cs_n;
wire [DATA_WIDTH-1:0] rx_data;
wire done;

// DUT
spi_master_top
#(
    .DATA_WIDTH(DATA_WIDTH),
    .DIVIDER(DIVIDER)
)
uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .tx_data(tx_data),
    .miso(miso),
    .spi_clk(spi_clk),
    .mosi(mosi),
    .cs_n(cs_n),
    .rx_data(rx_data),
    .done(done)
);

// Clock
always #5 clk = ~clk;

// Simulated SPI Slave
always @(posedge spi_clk)

begin
    miso <= ~miso;

end


// Test Sequence
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

    #300;

    // Second Transfer
    tx_data = 8'h5A;
    #20;
    start = 1;
    #10;
    start = 0;


    #350;

    $finish;

end
endmodule