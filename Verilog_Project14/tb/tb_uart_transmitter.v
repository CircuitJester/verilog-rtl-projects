`timescale 1ns/1ps

module tb_uart_transmitter;

parameter DATA_WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg baud_tick;
reg start;
reg [DATA_WIDTH-1:0] tx_data;

// Outputs
wire tx;
wire busy;
wire done;

// DUT
uart_transmitter #

(
.DATA_WIDTH(DATA_WIDTH)

)
uut

(
.clk(clk),
.rst(rst),

.baud_tick(baud_tick),
.start(start),
.tx_data(tx_data),
.tx(tx),
.busy(busy),
.done(done)
);

// Clock Generation
always #5 clk = ~clk;

// Baud Tick Generator
always
begin
    baud_tick = 0;
    #40;
    baud_tick = 1;
    #10;

end

// Test Sequence
initial
begin

    $dumpfile("waves/uart_transmitter.vcd");
    $dumpvars(0,tb_uart_transmitter);

    clk = 0;
    rst = 1;

    start = 0;
    tx_data = 8'hA5;
    #20;
    rst = 0;

    // Start Transmission
    #20;
    start = 1;
    #10;
    start = 0;

    #700;
    $finish;
end
endmodule