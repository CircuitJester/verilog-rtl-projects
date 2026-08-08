`timescale 1ns/1ps

module tb_forwarding_unit;

    // Inputs
    reg [4:0] rs1;
    reg [4:0] rs2;

    reg [4:0] ex_mem_rd;
    reg       ex_mem_reg_write;

    reg [4:0] mem_wb_rd;
    reg       mem_wb_reg_write;


    // Outputs
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // DUT
    forwarding_unit uut
    (
        .rs1(rs1),
        .rs2(rs2),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Test Sequence
    initial
    begin

        $dumpfile("waves/forwarding_unit.vcd");
        $dumpvars(0, tb_forwarding_unit);

        // Test 1
        // No Forwarding
        rs1 = 5'd5;
        rs2 = 5'd6;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 2
        // EX/MEM -> rs1
        rs1 = 5'd10;
        rs2 = 5'd6;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 3
        // MEM/WB -> rs1
        rs1 = 5'd12;
        rs2 = 5'd6;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 4
        // EX/MEM -> rs2
        rs1 = 5'd5;
        rs2 = 5'd10;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 5
        // MEM/WB -> rs2
        rs1 = 5'd5;
        rs2 = 5'd12;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 6
        // EX/MEM -> Both Operands
        rs1 = 5'd10;
        rs2 = 5'd10;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 7
        // Mixed Forwarding
        // rs1 -> EX/MEM
        // rs2 -> MEM/WB
        rs1 = 5'd10;
        rs2 = 5'd12;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 8
        // Both Match
        // EX/MEM Must Win
        rs1 = 5'd10;
        rs2 = 5'd10;

        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd10;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 9
        // x0 Protection
        rs1 = 5'd0;
        rs2 = 5'd0;

        ex_mem_rd = 5'd0;
        mem_wb_rd = 5'd0;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

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