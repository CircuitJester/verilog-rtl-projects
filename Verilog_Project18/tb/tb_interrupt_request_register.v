`timescale 1ns/1ps

module tb_interrupt_request_register;

// Parameters
parameter NUM_IRQS = 8;

// Inputs
reg clk;
reg rst;
reg [NUM_IRQS-1:0] irq;
reg [NUM_IRQS-1:0] clear;

// Outputs
wire [NUM_IRQS-1:0] pending_irq;

// DUT
interrupt_request_register
#(
    .NUM_IRQS(NUM_IRQS)
)
uut
(
    .clk(clk),
    .rst(rst),
    .irq(irq),
    .clear(clear),
    .pending_irq(pending_irq)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/interrupt_request_register.vcd");
    $dumpvars(0, tb_interrupt_request_register);

    clk = 0;
    rst = 1;

    irq = 8'b00000000;
    clear = 8'b00000000;

    // Reset
    #20;
    rst = 0;

    // Interrupt 1 Occurs
    #10;
    irq = 8'b00000010;
    #10;
    irq = 8'b00000000;

    // Interrupt 4 Occurs
    #20;
    irq = 8'b00010000;
    #10;
    irq = 8'b00000000;

    // Simultaneous Interrupts
    #20;
    irq = 8'b10000001;
    #10;
    irq = 8'b00000000;

    // Clear IRQ1
    #20;
    clear = 8'b00000010;
    #10;
    clear = 8'b00000000;

    // Clear IRQ4
    #20;
    clear = 8'b00010000;
    #10;
    clear = 8'b00000000;

    // Clear Remaining IRQ7 and IRQ0
    #20;
    clear = 8'b10000001;
    #10;
    clear = 8'b00000000;

    #40;

    $finish;

end
endmodule