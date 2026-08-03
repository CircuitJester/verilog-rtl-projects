`timescale 1ns/1ps

module tb_interrupt_controller_top;

// Parameters
parameter NUM_IRQS = 8;

// Inputs
reg clk;
reg rst;
reg [NUM_IRQS-1:0] irq;
reg mask_write;
reg [NUM_IRQS-1:0] mask_data;
reg cpu_ack;

// Outputs
wire cpu_interrupt;
wire busy;
wire [2:0] interrupt_id;

// DUT
interrupt_controller_top
#(
    .NUM_IRQS(NUM_IRQS)
)
uut
(
    .clk(clk),
    .rst(rst),
    .irq(irq),
    .mask_write(mask_write),
    .mask_data(mask_data),
    .cpu_ack(cpu_ack),
    .cpu_interrupt(cpu_interrupt),
    .busy(busy),
    .interrupt_id(interrupt_id)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/interrupt_controller_top.vcd");
    $dumpvars(0, tb_interrupt_controller_top);

    clk = 0;
    rst = 1;

    irq = 8'b00000000;

    mask_write = 0;
    mask_data = 8'hFF;
    cpu_ack = 0;

    // Reset
    #20;
    rst = 0;

    // Enable all interrupts
    #10;
    mask_write = 1;
    mask_data = 8'hFF;
    #10;
    mask_write = 0;

    // IRQ2 arrives
    #20;
    irq = 8'b00000100;
    #10;
    irq = 0;

    // CPU acknowledges
    #40;
    cpu_ack = 1;
    #10;
    cpu_ack = 0;

    // IRQ5 and IRQ1 arrive together
    #40;
    irq = 8'b00100010;
    #10;
    irq = 0;

    // CPU acknowledges
    #40;
    cpu_ack = 1;
    #10;
    cpu_ack = 0;

    // Disable IRQ5
    #30;
    mask_write = 1;
    mask_data = 8'b11011111;
    #10;
    mask_write = 0;

    // IRQ5 and IRQ0 arrive
    #30;
    irq = 8'b00100001;
    #10;
    irq = 0;

    // CPU acknowledges
    #40;
    cpu_ack = 1;
    #10;
    cpu_ack = 0;


    #60;

    $finish;

end
endmodule