module forwarding_comparator
(
    input wire [4:0] rs,
    input wire [4:0] ex_mem_rd,
    input wire [4:0] mem_wb_rd,

    input wire ex_mem_reg_write,
    input wire mem_wb_reg_write,

    output wire ex_mem_match,
    output wire mem_wb_match
);

    // EX/MEM forwarding condition
    assign ex_mem_match =
        ex_mem_reg_write &&
        (ex_mem_rd != 5'd0) &&
        (ex_mem_rd == rs);

    // MEM/WB forwarding condition
    assign mem_wb_match =
        mem_wb_reg_write &&
        (mem_wb_rd != 5'd0) &&
        (mem_wb_rd == rs);

endmodule