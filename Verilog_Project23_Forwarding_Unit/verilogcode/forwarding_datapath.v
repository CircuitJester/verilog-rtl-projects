module forwarding_datapath
(
    // Current instruction source registers
    input wire [4:0] rs1,
    input wire [4:0] rs2,

    // Register-file values
    input wire [31:0] reg_value_a,
    input wire [31:0] reg_value_b,

    // EX/MEM pipeline values
    input wire [4:0]  ex_mem_rd,
    input wire [31:0] ex_mem_value,
    input wire        ex_mem_reg_write,

    // MEM/WB pipeline values
    input wire [4:0]  mem_wb_rd,
    input wire [31:0] mem_wb_value,
    input wire        mem_wb_reg_write,

    // Final ALU operands
    output wire [31:0] alu_operand_a,
    output wire [31:0] alu_operand_b,

    // Forwarding status
    output wire [1:0] forward_a,
    output wire [1:0] forward_b
);

    // Forwarding Unit
    forwarding_unit forwarding_control
    (
        .rs1(rs1),
        .rs2(rs2),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );


    // Operand A Forwarding MUX
    forwarding_mux mux_a
    (
        .reg_value(reg_value_a),
        .ex_mem_value(ex_mem_value),
        .mem_wb_value(mem_wb_value),

        .forward_select(forward_a),
        .mux_output(alu_operand_a)
    );


    // Operand B Forwarding MUX
    forwarding_mux mux_b
    (
        .reg_value(reg_value_b),
        .ex_mem_value(ex_mem_value),
        .mem_wb_value(mem_wb_value),

        .forward_select(forward_b),
        .mux_output(alu_operand_b)
    );

endmodule