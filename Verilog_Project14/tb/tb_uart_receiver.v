`timescale 1ns/1ps

module tb_uart_receiver;

parameter DATA_WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg baud_tick;
reg rx;

// Outputs
wire [DATA_WIDTH-1:0] rx_data;
wire busy;
wire done;

// DUT
uart_receiver #

(
.DATA_WIDTH(DATA_WIDTH)

)
uut

(
.clk(clk),
.rst(rst),

.baud_tick(baud_tick),
.rx(rx),
.rx_data(rx_data),
.busy(busy),
.done(done)

);

// Clock Generation

always #5 clk = ~clk;

// Baud Tick Generation

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

    $dumpfile("waves/uart_receiver.vcd");
    $dumpvars(0,tb_uart_receiver);

    clk = 0;
    rst = 1;

    rx = 1;

    // Reset
    #20;
    rst = 0;

    // Idle
    #40;

    // Start Bit
    rx = 0;
    #50;

    // Send 0xA5
    // LSB First: 10100101

    rx = 1; #50;   // Bit0
    rx = 0; #50;   // Bit1
    rx = 1; #50;   // Bit2
    rx = 0; #50;   // Bit3
    rx = 0; #50;   // Bit4
    rx = 1; #50;   // Bit5
    rx = 0; #50;   // Bit6
    rx = 1; #50;   // Bit7

    // Stop Bit
    rx = 1;
    #100;
    $finish;

end
endmodule