module pipelined_alu_top
#
(
    parameter DATA_WIDTH = 32
)
(
    input wire clk,
    input wire rst,

    // Inputs
    input wire [2:0] opcode,
    input wire [DATA_WIDTH-1:0] operand_a,
    input wire [DATA_WIDTH-1:0] operand_b,
    input wire carry_out,
    input wire overflow,

    // Outputs
    output wire [DATA_WIDTH-1:0] result,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow_flag
);

wire [3:0] alu_control;
wire [DATA_WIDTH-1:0] alu_result;

wire zero_internal;
wire carry_internal;
wire negative_internal;
wire overflow_internal;

// ALU Control
alu_control
control
(
    .opcode(opcode),

    .alu_control(alu_control)
);

// ALU Execute
alu_execute
#
(
    .DATA_WIDTH(DATA_WIDTH)
)
execute
(
    .operand_a(operand_a),

    .operand_b(operand_b),

    .alu_control(alu_control),

    .result(alu_result)
);

// Flag Generator
alu_flags
#
(
    .DATA_WIDTH(DATA_WIDTH)
)
flags
(
    .result(alu_result),

    .carry_out(carry_out),

    .overflow(overflow),

    .zero(zero_internal),

    .carry(carry_internal),

    .negative(negative_internal),

    .overflow_flag(overflow_internal)
);

// Pipeline Register
alu_pipeline_register
#
(
    .DATA_WIDTH(DATA_WIDTH)
)
pipeline
(
    .clk(clk),

    .rst(rst),

    .result_in(alu_result),

    .zero_in(zero_internal),

    .carry_in(carry_internal),

    .negative_in(negative_internal),

    .overflow_in(overflow_internal),

    .result_out(result),

    .zero_out(zero),

    .carry_out(carry),

    .negative_out(negative),

    .overflow_out(overflow_flag)
);

endmodule