module interrupt_priority_encoder
#(
    parameter NUM_IRQS = 8
)
(
    input wire [NUM_IRQS-1:0] pending_irq,

    output reg valid,
    output reg [2:0] interrupt_id
);

always @(*)

begin

    valid = 1'b1;

    casez(pending_irq)

        8'b1??????? :
        interrupt_id = 3'd7;

        8'b01?????? :
        interrupt_id = 3'd6;

        8'b001????? :
        interrupt_id = 3'd5;

        8'b0001???? :
        interrupt_id = 3'd4;

        8'b00001??? :
        interrupt_id = 3'd3;

        8'b000001?? :
        interrupt_id = 3'd2;

        8'b0000001? :
        interrupt_id = 3'd1;

        8'b00000001 :
        interrupt_id = 3'd0;

        default:

        begin

            valid = 1'b0;
            interrupt_id = 3'd0;

        end

    endcase

end
endmodule