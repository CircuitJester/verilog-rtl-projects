`timescale 1ns/1ps

module tb_interrupt_controller_fsm;

// Inputs
reg clk;
reg rst;
reg valid;
reg cpu_ack;

// Outputs
wire cpu_interrupt;
wire clear_interrupt;
wire busy;

// DUT
interrupt_controller_fsm uut
(
    .clk(clk),
    .rst(rst),
    .valid(valid),
    .cpu_ack(cpu_ack),
    .cpu_interrupt(cpu_interrupt),
    .clear_interrupt(clear_interrupt),
    .busy(busy)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/interrupt_controller_fsm.vcd");
    $dumpvars(0, tb_interrupt_controller_fsm);

    clk = 0;
    rst = 1;
    valid = 0;
    cpu_ack = 0;

    // Reset
    #20;
    rst = 0;

    // First Interrupt
    #20;
    valid = 1;
    #10;
    valid = 0;

    // CPU acknowledges interrupt
    #30;
    cpu_ack = 1;
    #10;
    cpu_ack = 0;

    // Second Interrupt
    #30;
    valid = 1;
    #10;
    valid = 0;

    // Delayed CPU Acknowledge
    #40;
    cpu_ack = 1;
    #10;
    cpu_ack = 0;

    #40;
    $finish;

end
endmodule