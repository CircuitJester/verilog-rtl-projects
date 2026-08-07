`timescale 1ns/1ps

module tb_hazard_detection_logic;

// Inputs
reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg reg_write;

// Outputs
wire stall;
wire pc_write;
wire if_id_write;

// DUT
hazard_detection_logic uut
(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .reg_write(reg_write),

    .stall(stall),
    .pc_write(pc_write),
    .if_id_write(if_id_write)
);

// Test Sequence
initial
begin

    $dumpfile("waves/hazard_detection_logic.vcd");
    $dumpvars(0,tb_hazard_detection_logic);

    // Test 1
    // No Hazard
    rs1 = 5'd1;
    rs2 = 5'd2;
    rd  = 5'd5;

    reg_write = 1;

    #20;

    // Test 2
    // Hazard on rs1
    rs1 = 5'd10;
    rs2 = 5'd3;
    rd  = 5'd10;

    #20;

    // Test 3
    // Hazard on rs2
    rs1 = 5'd7;
    rs2 = 5'd15;
    rd  = 5'd15;

    #20;

    // Test 4
    // Hazard on Both
    rs1 = 5'd20;
    rs2 = 5'd20;
    rd  = 5'd20;

    #20;

    // Test 5
    // x0 Register
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