module interrupt_request_register
#(
    parameter NUM_IRQS = 8
)
(
    input wire clk,
    input wire rst,
    input wire [NUM_IRQS-1:0] irq,
    input wire [NUM_IRQS-1:0] clear,

    output reg [NUM_IRQS-1:0] pending_irq
);

always @(posedge clk or posedge rst)
begin

    if(rst)

    begin

        pending_irq <= 0;

    end
    else

    begin

        // Latch new interrupt requests
        pending_irq <= pending_irq | irq;

        // Clear serviced interrupts
        pending_irq <= (pending_irq | irq) & (~clear);

    end

end
endmodule