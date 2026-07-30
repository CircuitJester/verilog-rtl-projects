`timescale 1ns/1ps

module tb_uart_rx_fsm;

// Inputs
reg clk;
reg rst;
reg rx;
reg baud_tick;
reg receive_done;

// Outputs
wire sample_enable;
wire busy;
wire done;

// DUT
uart_rx_fsm uut
(
    .clk(clk),
    .rst(rst),

    .rx(rx),
    .baud_tick(baud_tick),
    .receive_done(receive_done),
    .sample_enable(sample_enable),
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

    $dumpfile("waves/uart_rx_fsm.vcd");
    $dumpvars(0,tb_uart_rx_fsm);

    clk = 0;
    rst = 1;

    rx = 1;
    receive_done = 0;

    // Reset
    #20;
    rst = 0;

    // Start Bit Detection
    #30;
    rx = 0;

    // Simulate Data Reception
    #250;
    receive_done = 1;
    #10;
    receive_done = 0;

    //------------------------
    // Return RX to Idle
    #50;
    rx = 1;

    #150;

    $finish;
end
endmodule