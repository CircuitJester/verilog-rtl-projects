module forwarding_unit
(
    // Current instruction source registers
    input wire [4:0] rs1,
    input wire [4:0] rs2,

    // EX/MEM pipeline destination
    input wire [4:0] ex_mem_rd,
    input wire ex_mem_reg_write,

    // MEM/WB pipeline destination
    input wire [4:0] mem_wb_rd,
    input wire mem_wb_reg_write,

    // Forwarding control outputs
    output wire [1:0] forward_a,
    output wire [1:0] forward_b
);

    // Internal Match Signals
    wire ex_mem_match_rs1;
    wire mem_wb_match_rs1;

    wire ex_mem_match_rs2;
    wire mem_wb_match_rs2;

    // Register Comparator

    forwarding_comparator comparator_rs1
    (
        .rs(rs1),

        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),

        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_write(mem_wb_reg_write),

        .ex_mem_match(ex_mem_match_rs1),
        .mem_wb_match(mem_wb_match_rs1)
    );


    forwarding_comparator comparator_rs2
    (
        .rs(rs2),

        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),

        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_write(mem_wb_reg_write),

        .ex_mem_match(ex_mem_match_rs2),
        .mem_wb_match(mem_wb_match_rs2)
    );


    // Forwarding Control Logic 
    forwarding_control_logic control_logic
    (
        .ex_mem_match_rs1(ex_mem_match_rs1),
        .mem_wb_match_rs1(mem_wb_match_rs1),

        .ex_mem_match_rs2(ex_mem_match_rs2),
        .mem_wb_match_rs2(mem_wb_match_rs2),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );

endmodule