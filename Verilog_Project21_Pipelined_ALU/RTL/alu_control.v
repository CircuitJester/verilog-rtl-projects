module alu_control
(
    input  wire [2:0] opcode,

    output reg  [3:0] alu_control
);

// ALU Operation Decoder
always @(*)
begin

    case(opcode)

        3'b000:
            alu_control = 4'b0000;     // ADD

        3'b001:
            alu_control = 4'b0001;     // SUB

        3'b010:
            alu_control = 4'b0010;     // AND

        3'b011:
            alu_control = 4'b0011;     // OR

        3'b100:
            alu_control = 4'b0100;     // XOR

        3'b101:
            alu_control = 4'b0101;     // Shift Left

        3'b110:
            alu_control = 4'b0110;     // Shift Right

        3'b111:
            alu_control = 4'b0111;     // Compare

        default:
            alu_control = 4'b0000;

    endcase

end

endmodule