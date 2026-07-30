`timescale 1ns/1ps

module tb_uart_top;

parameter CLOCK_DIVIDER = 4;
parameter DATA_WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg tx_start;
reg [DATA_WIDTH-1:0] tx_data;

// Loopback
wire tx;

// Outputs
wire tx_busy;
wire tx_done;
wire [DATA_WIDTH-1:0] rx_data;
wire rx_busy;
wire rx_done;

// DUT
uart_top #

(
.CLOCK_DIVIDER(CLOCK_DIVIDER),
.DATA_WIDTH(DATA_WIDTH)

)
uut

(
.clk(clk),
.rst(rst),

.tx_start(tx_start),
.tx_data(tx_data),
.tx_busy(tx_busy),
.tx_done(tx_done),
.tx(tx),
.rx(tx),
.rx_data(rx_data),
.rx_busy(rx_busy),
.rx_done(rx_done)
);

// Clock
always #5 clk = ~clk;

// Test
initial
begin

    $dumpfile("waves/uart_top.vcd");
    $dumpvars(0,tb_uart_top);

    clk = 0;
    rst = 1;

    tx_start = 0;
    tx_data = 8'hA5;

    #20;
    rst = 0;

    #20;
    tx_start = 1;
    #10;
    tx_start = 0;

    #1200;

    tx_data = 8'h5A;
    #20;
    tx_start = 1;
    #10;
    tx_start = 0;

    #1200;
    $finish;
end
endmodule