module pipeline_stall_generator
(
    input wire match_rs1,
    input wire match_rs2,

    output wire stall,
    output wire pc_write,
    output wire if_id_write
);

// Stall Logic 
assign stall = match_rs1 | match_rs2;

// Pipeline Control 
assign pc_write = ~stall;

assign if_id_write = ~stall;

endmodule