module interrupt_mask_register
#(
    parameter NUM_IRQS = 8
)
(
    input wire clk,
    input wire rst,
    input wire mask_write,
    input wire [NUM_IRQS-1:0] mask_data,

    output reg [NUM_IRQS-1:0] mask_register
);

always @(posedge clk or posedge rst)
begin

    if(rst)

    begin

        // Enable all interrupts after reset
        mask_register <= {NUM_IRQS{1'b1}};

    end
    else

    begin

        if(mask_write)
            mask_register <= mask_data;

    end

end
endmodule