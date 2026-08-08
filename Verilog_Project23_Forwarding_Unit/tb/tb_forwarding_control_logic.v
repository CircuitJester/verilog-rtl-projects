`timescale 1ns/1ps

module tb_forwarding_control_logic;

    // Inputs
    reg ex_mem_match_rs1;
    reg mem_wb_match_rs1;
    reg ex_mem_match_rs2;
    reg mem_wb_match_rs2;

    // Outputs
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // DUT
    forwarding_control_logic uut
    (
        .ex_mem_match_rs1(ex_mem_match_rs1),
        .mem_wb_match_rs1(mem_wb_match_rs1),

        .ex_mem_match_rs2(ex_mem_match_rs2),
        .mem_wb_match_rs2(mem_wb_match_rs2),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Test Sequence
    initial
    begin

        $dumpfile("waves/forwarding_control_logic.vcd");
        $dumpvars(0, tb_forwarding_control_logic);

        // Test 1
        // No Forwarding
        ex_mem_match_rs1 = 0;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 0;

        #20;

        // Test 2
        // MEM/WB -> Operand A
        ex_mem_match_rs1 = 0;
        mem_wb_match_rs1 = 1;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 0;

        #20;

        // Test 3
        // EX/MEM -> Operand A
        ex_mem_match_rs1 = 1;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 0;

        #20;

        // Test 4
        // EX/MEM Priority for Operand A
        ex_mem_match_rs1 = 1;
        mem_wb_match_rs1 = 1;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 0;

        #20;

        // Test 5
        // MEM/WB -> Operand B
        ex_mem_match_rs1 = 0;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 1;

        #20;

        // Test 6
        // EX/MEM -> Operand B
        ex_mem_match_rs1 = 0;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 1;
        mem_wb_match_rs2 = 0;

        #20;

        // Test 7
        // EX/MEM Priority for Operand B
        ex_mem_match_rs1 = 0;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 1;
        mem_wb_match_rs2 = 1;

        #20;

        // Test 8
        // Forward Both Operands from EX/MEM
        ex_mem_match_rs1 = 1;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 1;
        mem_wb_match_rs2 = 0;

        #20;

        // Test 9
        // Forward Both Operands from MEM/WB
        ex_mem_match_rs1 = 0;
        mem_wb_match_rs1 = 1;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 1;

        #20;

        // Test 10
        // Mixed Forwarding
        ex_mem_match_rs1 = 1;
        mem_wb_match_rs1 = 0;

        ex_mem_match_rs2 = 0;
        mem_wb_match_rs2 = 1;

        #20;

        $finish;
    end

endmodule