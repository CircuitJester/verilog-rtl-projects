`timescale 1ns/1ps

module tb_interrupt_priority_encoder;

// Parameters
parameter NUM_IRQS = 8;

// Inputs
reg [NUM_IRQS-1:0] pending_irq;

// Outputs
wire valid;
wire [2:0] interrupt_id;

// DUT
interrupt_priority_encoder
#(
    .NUM_IRQS(NUM_IRQS)
)
uut
(
    .pending_irq(pending_irq),
    .valid(valid),
    .interrupt_id(interrupt_id)
);

// Test Sequence
initial
begin

    $dumpfile("waves/interrupt_priority_encoder.vcd");
    $dumpvars(0,tb_interrupt_priority_encoder);

    // No Interrupt
    pending_irq = 8'b00000000;
    #20;

    // IRQ0
    pending_irq = 8'b00000001;
    #20;

    // IRQ2
    pending_irq = 8'b00000100;
    #20;

    // IRQ4
    pending_irq = 8'b00010000;
    #20;

    // IRQ7
    pending_irq = 8'b10000000;
    #20;

    // IRQ5 + IRQ2
    pending_irq = 8'b00100100;
    #20;

    // IRQ7 + IRQ1
    pending_irq = 8'b10000010;
    #20;

    // All Interrupts Active
    pending_irq = 8'b11111111;
    #20;

    // IRQ6 + IRQ4 + IRQ3
    pending_irq = 8'b01011000;
    #20;

    $finish;

end
endmodule