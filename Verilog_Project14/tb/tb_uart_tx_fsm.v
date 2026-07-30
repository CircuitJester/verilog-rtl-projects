`timescale 1ns/1ps

module tb_uart_tx_fsm;

// Inputs
reg clk;
reg rst;
reg start;
reg baud_tick;
reg shift_done;

// Outputs
wire load;
wire start_bit;
wire shift_enable;
wire stop_bit;
wire busy;
wire done;

// DUT
uart_tx_fsm uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .baud_tick(baud_tick),
    .shift_done(shift_done),
    .load(load),
    .start_bit(start_bit),
    .shift_enable(shift_enable),
    .stop_bit(stop_bit),
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
    $dumpfile("waves/uart_tx_fsm.vcd");
    $dumpvars(0,tb_uart_tx_fsm);

    clk = 0;
    rst = 1;
    start = 0;
    shift_done = 0;

    // Reset
    #20;
    rst = 0;

    // Start Transmission
    #20;
    start = 1;
    #10;
    start = 0;

    // Simulate Shift Complete
    #250;
    shift_done = 1;
    #10;
    shift_done = 0;

    #150;
    $finish;

end
endmodule