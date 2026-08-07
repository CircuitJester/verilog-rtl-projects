`timescale 1ns/1ps

module tb_pipeline_stall_generator;

// Inputs
reg match_rs1;
reg match_rs2;

// Outputs
wire stall;
wire pc_write;
wire if_id_write;

// DUT
pipeline_stall_generator uut
(
    .match_rs1(match_rs1),
    .match_rs2(match_rs2),

    .stall(stall),
    .pc_write(pc_write),
    .if_id_write(if_id_write)
);

// Test Sequence
initial
begin

    $dumpfile("waves/pipeline_stall_generator.vcd");
    $dumpvars(0, tb_pipeline_stall_generator);

    // Test 1
    // No Hazard
    match_rs1 = 0;
    match_rs2 = 0;

    #20;

    // Test 2
    // Hazard on rs1
    match_rs1 = 1;
    match_rs2 = 0;

    #20;

    // Test 3
    // Hazard on rs2
    match_rs1 = 0;
    match_rs2 = 1;

    #20;

    // Test 4
    // Hazard on Both
    match_rs1 = 1;
    match_rs2 = 1;

    #20;

    // Test 5
    // Hazard Cleared
    match_rs1 = 0;
    match_rs2 = 0;

    #20;

    $finish;

end

endmodule