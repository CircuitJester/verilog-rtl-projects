`timescale 1ns/1ps

module tb_id_ex_pipeline_register;

    reg clk;
    reg rst;
    reg stall;
    reg flush;

    reg [31:0] decode_pc;
    reg [31:0] source_a;
    reg [31:0] source_b;
    reg [31:0] immediate_value;

    reg [4:0] source_a_reg;
    reg [4:0] source_b_reg;
    reg [4:0] destination_reg;

    reg [3:0] alu_operation;
    reg enable_reg_write;
    reg enable_mem_read;
    reg enable_mem_write;
    reg select_memory_result;
    reg select_immediate;

    wire [31:0] execute_pc;
    wire [31:0] execute_source_a;
    wire [31:0] execute_source_b;
    wire [31:0] execute_immediate;

    wire [4:0] execute_source_a_reg;
    wire [4:0] execute_source_b_reg;
    wire [4:0] execute_destination_reg;

    wire [3:0] execute_alu_operation;
    wire execute_reg_write;
    wire execute_mem_read;
    wire execute_mem_write;
    wire execute_memory_select;
    wire execute_immediate_select;

    id_ex_pipeline_register dut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),

        .pc_in(decode_pc),
        .rs1_value_in(source_a),
        .rs2_value_in(source_b),
        .immediate_in(immediate_value),

        .rs1_in(source_a_reg),
        .rs2_in(source_b_reg),
        .rd_in(destination_reg),

        .alu_control_in(alu_operation),
        .reg_write_in(enable_reg_write),
        .mem_read_in(enable_mem_read),
        .mem_write_in(enable_mem_write),
        .mem_to_reg_in(select_memory_result),
        .alu_src_in(select_immediate),

        .pc_out(execute_pc),
        .rs1_value_out(execute_source_a),
        .rs2_value_out(execute_source_b),
        .immediate_out(execute_immediate),

        .rs1_out(execute_source_a_reg),
        .rs2_out(execute_source_b_reg),
        .rd_out(execute_destination_reg),

        .alu_control_out(execute_alu_operation),
        .reg_write_out(execute_reg_write),
        .mem_read_out(execute_mem_read),
        .mem_write_out(execute_mem_write),
        .mem_to_reg_out(execute_memory_select),
        .alu_src_out(execute_immediate_select)
    );


    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    initial begin
        $dumpfile("waves/id_ex_pipeline_register.vcd");
        $dumpvars(0, tb_id_ex_pipeline_register);

        rst = 1'b1;
        stall = 1'b0;
        flush = 1'b0;

        decode_pc = 32'h00000000;
        source_a = 32'h00000000;
        source_b = 32'h00000000;
        immediate_value = 32'h00000000;

        source_a_reg = 5'd0;
        source_b_reg = 5'd0;
        destination_reg = 5'd0;

        alu_operation = 4'h0;
        enable_reg_write = 1'b0;
        enable_mem_read = 1'b0;
        enable_mem_write = 1'b0;
        select_memory_result = 1'b0;
        select_immediate = 1'b0;

        #12;

        rst = 1'b0;

        decode_pc = 32'h00000004;
        source_a = 32'h0000000A;
        source_b = 32'h00000005;
        immediate_value = 32'h00000010;

        source_a_reg = 5'd1;
        source_b_reg = 5'd2;
        destination_reg = 5'd10;

        alu_operation = 4'h1;
        enable_reg_write = 1'b1;

        #10;

        decode_pc = 32'h00000008;
        source_a = 32'h00000014;
        source_b = 32'h00000006;
        immediate_value = 32'h00000020;

        source_a_reg = 5'd3;
        source_b_reg = 5'd4;
        destination_reg = 5'd11;

        alu_operation = 4'h2;

        #10;

        stall = 1'b1;

        decode_pc = 32'h0000000C;
        source_a = 32'hAAAAAAAA;
        source_b = 32'hBBBBBBBB;
        immediate_value = 32'hCCCCCCCC;

        source_a_reg = 5'd8;
        source_b_reg = 5'd9;
        destination_reg = 5'd12;

        alu_operation = 4'hF;
        enable_mem_read = 1'b1;
        select_memory_result = 1'b1;

        #10;

        stall = 1'b0;

        decode_pc = 32'h00000010;
        source_a = 32'h00000028;
        source_b = 32'h00000004;
        immediate_value = 32'h00000030;

        source_a_reg = 5'd5;
        source_b_reg = 5'd6;
        destination_reg = 5'd13;

        alu_operation = 4'h3;
        enable_mem_read = 1'b0;
        select_memory_result = 1'b0;

        #10;

        flush = 1'b1;

        decode_pc = 32'h00000014;
        source_a = 32'h11111111;
        source_b = 32'h22222222;
        immediate_value = 32'h33333333;

        source_a_reg = 5'd14;
        source_b_reg = 5'd15;
        destination_reg = 5'd16;

        alu_operation = 4'h7;
        enable_reg_write = 1'b1;
        enable_mem_write = 1'b1;

        #10;

        flush = 1'b0;

        decode_pc = 32'h00000018;
        source_a = 32'h00000040;
        source_b = 32'h00000008;
        immediate_value = 32'h00000040;

        source_a_reg = 5'd7;
        source_b_reg = 5'd8;
        destination_reg = 5'd17;

        alu_operation = 4'h4;
        enable_mem_write = 1'b0;
        enable_reg_write = 1'b1;

        #20;

        $finish;
    end

endmodule