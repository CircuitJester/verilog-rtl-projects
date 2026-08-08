`timescale 1ns/1ps

module tb_forwarding_mux;

    // Inputs
    reg [31:0] reg_value;
    reg [31:0] ex_mem_value;
    reg [31:0] mem_wb_value;
    reg [1:0] forward_select;

    // Output
    wire [31:0] mux_output;
    // DUT
    forwarding_mux uut
    (
        .reg_value(reg_value),
        .ex_mem_value(ex_mem_value),
        .mem_wb_value(mem_wb_value),
        .forward_select(forward_select),
        .mux_output(mux_output)
    );

    // Test Sequence
    initial
    begin

        $dumpfile("waves/forwarding_mux.vcd");
        $dumpvars(0, tb_forwarding_mux);

        // Common Test Data
        reg_value    = 32'h00000011;
        ex_mem_value = 32'hAAAAAAAA;
        mem_wb_value = 32'h55555555;

        // Test 1
        // Register File
        forward_select = 2'b00;
        #20;

        // Test 2
        // MEM/WB
        forward_select = 2'b01;
        #20;

        // Test 3
        // EX/MEM
        forward_select = 2'b10;
        #20;

        // Test 4
        // Reserved Selection
        forward_select = 2'b11;
        #20;

        // Test 5
        // Change Data Values
        reg_value    = 32'h00000025;
        ex_mem_value = 32'h12345678;
        mem_wb_value = 32'h87654321;

        // Register File
        forward_select = 2'b00;
        #20;

        // MEM/WB
        forward_select = 2'b01;
        #20;


        // EX/MEM
        forward_select = 2'b10;
        #20;

        // Reserved
        forward_select = 2'b11;
        #20;

        $finish;

    end
endmodule