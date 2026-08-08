`timescale 1ns/1ps

module tb_forwarding_comparator;

    // Inputs
    reg [4:0] rs;
    reg [4:0] ex_mem_rd;
    reg [4:0] mem_wb_rd;

    reg ex_mem_reg_write;
    reg mem_wb_reg_write;

    // Outputs
    wire ex_mem_match;
    wire mem_wb_match;

    // DUT
    forwarding_comparator uut
    (
        .rs(rs),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),

        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_write(mem_wb_reg_write),
        .ex_mem_match(ex_mem_match),
        .mem_wb_match(mem_wb_match)
    );

    initial
    begin

        $dumpfile("waves/forwarding_comparator.vcd");
        $dumpvars(0, tb_forwarding_comparator);

        // Test 1: No Match
        rs = 5'd5;
        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd15;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #20;

        // Test 2: EX/MEM Match
        rs = 5'd10;
        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd15;

        #20;

        // Test 3: MEM/WB Match
        rs = 5'd15;
        ex_mem_rd = 5'd10;
        mem_wb_rd = 5'd15;

        #20;

        // Test 4: Both Match
        rs = 5'd20;
        ex_mem_rd = 5'd20;
        mem_wb_rd = 5'd20;

        #20;

        // Test 5: x0 Destination
        rs = 5'd0;
        ex_mem_rd = 5'd0;
        mem_wb_rd = 5'd0;

        #20;

        // Test 6: EX/MEM Write Disabled
        rs = 5'd8;
        ex_mem_rd = 5'd8;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 0;
        mem_wb_reg_write = 1;

        #20;

        // Test 7: MEM/WB Write Disabled
        rs = 5'd12;
        ex_mem_rd = 5'd8;
        mem_wb_rd = 5'd12;

        ex_mem_reg_write = 1;
        mem_wb_reg_write = 0;

        #20;

        $finish;
    end

endmodule