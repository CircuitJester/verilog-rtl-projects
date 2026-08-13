module hazard_detection_logic
(
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire reg_write,

    output wire stall,
    output wire pc_write,
    output wire if_id_write
);

// Internal Signals
wire match_rs1;
wire match_rs2;

// Register Comparator
register_comparator comparator
(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .reg_write(reg_write),
    .match_rs1(match_rs1),
    .match_rs2(match_rs2)
);

// Stall Generator
pipeline_stall_generator stall_generator
(
    .match_rs1(match_rs1),
    .match_rs2(match_rs2),

    .stall(stall),
    .pc_write(pc_write),
    .if_id_write(if_id_write)
);

endmodule