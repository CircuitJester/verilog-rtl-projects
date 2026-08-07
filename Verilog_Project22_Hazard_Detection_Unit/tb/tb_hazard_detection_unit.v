`timescale 1ns/1ps

module tb_hazard_detection_unit;

// Inputs
reg clk;
reg rst;

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg reg_write;

// Outputs
wire stall;
wire pc_write;
wire if_id_write;
wire pipeline_hold;
wire busy;

// DUT
hazard_detection_unit uut
(
    .clk(clk),
    .rst(rst),

    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .reg_write(reg_write),

    .stall(stall),
    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .pipeline_hold(pipeline_hold),
    .busy(busy)
);

// Clock
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test Sequence
initial
begin

    $dumpfile("waves/hazard_detection_unit.vcd");
    $dumpvars(0,tb_hazard_detection_unit);

    // Reset
    rst = 1;
    rs1 = 0;
    rs2 = 0;
    rd  = 0;

    reg_write = 0;
    #20;
    rst = 0;

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

    #40;

    // Test 3
    // Hazard Cleared
    rs1 = 5'd8;
    rs2 = 5'd9;
    rd  = 5'd15;

    #40;

    // Test 4
    // Hazard on rs2
    rs1 = 5'd4;
    rs2 = 5'd20;
    rd  = 5'd20;

    #40;

    // Test 5
    // x0 Register
    rs1 = 0;
    rs2 = 0;
    rd  = 0;

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