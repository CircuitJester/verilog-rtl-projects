`timescale 1ns/1ps

module tb_register_comparator;

// Inputs
reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg reg_write;

// Outputs
wire match_rs1;
wire match_rs2;

// DUT
register_comparator uut
(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .reg_write(reg_write),
    .match_rs1(match_rs1),
    .match_rs2(match_rs2)
);

// Test Sequence
initial
begin

    $dumpfile("waves/register_comparator.vcd");
    $dumpvars(0,tb_register_comparator);

    // Test 1
    // No Match
    rs1 = 5'd1;
    rs2 = 5'd2;
    rd  = 5'd5;

    reg_write = 1;

    #20;

    // Test 2
    // rs1 Match
    rs1 = 5'd10;
    rs2 = 5'd3;
    rd  = 5'd10;

    #20;

    // Test 3
    // rs2 Match
    rs1 = 5'd7;
    rs2 = 5'd15;
    rd  = 5'd15;

    #20;

    // Test 4
    // Both Match
    rs1 = 5'd20;
    rs2 = 5'd20;
    rd  = 5'd20;

    #20;

    // Test 5
    // Register x0
    rs1 = 5'd0;
    rs2 = 5'd0;
    rd  = 5'd0;

    #20;

    // Test 6
    // reg_write Disabled
    rs1 = 5'd12;
    rs2 = 5'd12;
    rd  = 5'd12;

    reg_write = 0;

    #20;

    $finish;

end

endmodule