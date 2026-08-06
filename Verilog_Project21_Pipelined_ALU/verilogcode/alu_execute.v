module alu_execute
#
(
    parameter DATA_WIDTH = 32
)
(
    input wire [DATA_WIDTH-1:0] operand_a,
    input wire [DATA_WIDTH-1:0] operand_b,
    input wire [3:0] alu_control,

    output reg [DATA_WIDTH-1:0] result
);

// Execute ALU Operation
always @(*)
begin

    case(alu_control)

        // ADD
        4'b0000:

            result = operand_a + operand_b;

        // SUB
        4'b0001:

            result = operand_a - operand_b;

        // AND
        4'b0010:

            result = operand_a & operand_b;

        // OR
        4'b0011:

            result = operand_a | operand_b;

        // XOR
        4'b0100:

            result = operand_a ^ operand_b;

        // Shift Left
        4'b0101:

            result = operand_a << 1;

        // Shift Right
        4'b0110:

            result = operand_a >> 1;

        // Compare
        4'b0111:

            result = (operand_a == operand_b);

        default:
            result = 0;

    endcase

end
endmodule