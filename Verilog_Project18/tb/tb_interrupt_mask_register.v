`timescale 1ns/1ps

module tb_interrupt_mask_register;

// Parameters
parameter NUM_IRQS = 8;

// Inputs
reg clk;
reg rst;
reg mask_write;
reg [NUM_IRQS-1:0] mask_data;

// Outputs
wire [NUM_IRQS-1:0] mask_register;

// DUT
interrupt_mask_register
#(
    .NUM_IRQS(NUM_IRQS)
)
uut
(
    .clk(clk),
    .rst(rst),
    .mask_write(mask_write),
    .mask_data(mask_data),
    .mask_register(mask_register)
);


// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/interrupt_mask_register.vcd");
    $dumpvars(0, tb_interrupt_mask_register);

    clk = 0;
    rst = 1;

    mask_write = 0;
    mask_data = 8'hFF;

    // Reset
    #20;
    rst = 0;

    // Disable IRQ4
    #20;
    mask_write = 1;
    mask_data = 8'b11101111;
    #10;
    mask_write = 0;

    // Disable IRQ1 and IRQ3
    #20;
    mask_write = 1;
    mask_data = 8'b11110101;
    #10;
    mask_write = 0;

    // Enable Only Upper Four IRQs
    #20;
    mask_write = 1;
    mask_data = 8'b11110000;
    #10;
    mask_write = 0;

    // Disable All Interrupts
    #20;
    mask_write = 1;
    mask_data = 8'b00000000;
    #10;
    mask_write = 0;

    // Enable All Interrupts
    #20;
    mask_write = 1;
    mask_data = 8'b11111111;
    #10;
    mask_write = 0;


    #40;

    $finish;

end
endmodule