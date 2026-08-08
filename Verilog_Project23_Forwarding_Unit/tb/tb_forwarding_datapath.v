`timescale 1ns/1ps

module tb_forwarding_datapath;

    // Inputs
    reg [4:0] rs1;
    reg [4:0] rs2;

    reg [31:0] reg_value_a;
    reg [31:0] reg_value_b;

    reg [4:0] ex_mem_rd;
    reg [31:0] ex_mem_value;
    reg ex_mem_reg_write;

    reg [4:0] mem_wb_rd;
    reg [31:0] mem_wb_value;
    reg mem_wb_reg_write;

    // Outputs
    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // DUT
    forwarding_datapath uut
    (
        .rs1(rs1),
        .rs2(rs2),

        .reg_value_a(reg_value_a),
        .reg_value_b(reg_value_b),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_value(ex_mem_value),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_value(mem_wb_value),
        .mem_wb_reg_write(mem_wb_reg_write),

        .alu_operand_a(alu_operand_a),
        .alu_operand_b(alu_operand_b),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Test Sequence
    initial
    begin

        $dumpfile("waves/forwarding_datapath.vcd");
        $dumpvars(0, tb_forwarding_datapath);

        // Common Register Values
        reg_value_a = 32'h00000011;
        reg_value_b = 32'h00000022;

        ex_mem_value = 32'hAAAAAAAA;
        mem_wb_value = 32'h55555555;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        // Test 1
        // No Forwarding
        rs1 = 5'd5;
        rs2 = 5'd6;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 2
        // EX/MEM -> Operand A
        rs1 = 5'd10;
        rs2 = 5'd6;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 3
        // MEM/WB -> Operand A
        rs1 = 5'd12;
        rs2 = 5'd6;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 4
        // EX/MEM -> Operand B
        rs1 = 5'd5;
        rs2 = 5'd10;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 5
        // MEM/WB -> Operand B
        rs1 = 5'd5;
        rs2 = 5'd12;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 6
        // EX/MEM -> Both Operands
        rs1 = 5'd10;
        rs2 = 5'd10;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 7
        // Mixed Forwarding
        rs1 = 5'd10;
        rs2 = 5'd12;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        #20;

        // Test 8
        // Both Stages Match
        // EX/MEM Must Win
        rs1 = 5'd10;
        rs2 = 5'd10;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd10;

        #20;

        // Test 9
        // x0 Protection
        rs1 = 5'd0;
        rs2 = 5'd0;

        ex_mem_rd = 5'd0;
        mem_wb_rd = 5'd0;

        #20;

        // Test 10
        // Write Enables Disabled
        rs1 = 5'd10;
        rs2 = 5'd12;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 0;
        mem_wb_reg_write = 0;

        #20;

        $finish;

    end
endmodule