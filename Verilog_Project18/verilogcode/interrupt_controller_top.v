module interrupt_controller_top
#(
    parameter NUM_IRQS = 8
)
(
    input wire clk,
    input wire rst,
    input wire [NUM_IRQS-1:0] irq,
    input wire mask_write,
    input wire [NUM_IRQS-1:0] mask_data,
    input wire cpu_ack,

    output wire cpu_interrupt,
    output wire busy,
    output wire [2:0] interrupt_id
);

// Internal Signals
wire [NUM_IRQS-1:0] pending_irq;
wire [NUM_IRQS-1:0] mask_register;
wire [NUM_IRQS-1:0] masked_irq;
wire valid;
wire clear_interrupt;
wire [NUM_IRQS-1:0] clear_vector;

// Clear Selected Interrupt
assign clear_vector =
        clear_interrupt ?
        (8'b00000001 << interrupt_id) :
        8'b00000000;

// Request Register
interrupt_request_register
#(
    .NUM_IRQS(NUM_IRQS)
)
request_reg
(
    .clk(clk),
    .rst(rst),
    .irq(irq),
    .clear(clear_vector),
    .pending_irq(pending_irq)
);

// Mask Register
interrupt_mask_register
#(
    .NUM_IRQS(NUM_IRQS)
)
mask_reg
(
    .clk(clk),
    .rst(rst),

    .mask_write(mask_write),
    .mask_data(mask_data),
    .mask_register(mask_register)
);

// Apply Interrupt Mask
assign masked_irq = pending_irq & mask_register;

// Priority Encoder
interrupt_priority_encoder
#(
    .NUM_IRQS(NUM_IRQS)
)
priority_encoder
(
    .pending_irq(masked_irq),
    .valid(valid),
    .interrupt_id(interrupt_id)
);

// Interrupt FSM
interrupt_controller_fsm
fsm
(
    .clk(clk),
    .rst(rst),
    .valid(valid),
    .cpu_ack(cpu_ack),
    .cpu_interrupt(cpu_interrupt),
    .clear_interrupt(clear_interrupt),
    .busy(busy)
);
endmodule