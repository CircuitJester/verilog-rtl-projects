module register_comparator
(
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire reg_write,

    output wire match_rs1,
    output wire match_rs2
);

// Register Comparison
assign match_rs1 = reg_write &&
                   (rd != 5'd0) &&
                   (rs1 == rd);

assign match_rs2 = reg_write &&
                   (rd != 5'd0) &&
                   (rs2 == rd);

endmodule