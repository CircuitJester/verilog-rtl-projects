`timescale 1ns/1ps

module tb_pipelined_alu_top;

    reg clk;
    reg rst;

    reg stall_request;
    reg flush_request;

    reg [31:0] fetch_pc;
    reg [31:0] fetch_instruction;

    reg [31:0] decode_rs1_value;
    reg [31:0] decode_rs2_value;
    reg [31:0] decode_immediate;

    reg [4:0] decode_rs1;
    reg [4:0] decode_rs2;
    reg [4:0] decode_rd;
    reg [3:0] decode_alu_control;

    reg decode_reg_write;
    reg decode_mem_read;
    reg decode_mem_write;
    reg decode_mem_to_reg;
    reg decode_alu_src;

    reg [31:0] execute_result;
    reg [31:0] execute_store_data;
    reg execute_zero;
    reg [31:0] memory_read_data;

    wire [31:0] wb_alu_result;
    wire [31:0] wb_memory_data;
    wire [4:0] wb_rd;

    wire wb_reg_write;
    wire wb_mem_to_reg;

    pipelined_alu_top dut (
        .clk(clk),
        .rst(rst),

        .stall_request(stall_request),
        .flush_request(flush_request),
        .fetch_pc(fetch_pc),
        .fetch_instruction(fetch_instruction),

        .decode_rs1_value(decode_rs1_value),
        .decode_rs2_value(decode_rs2_value),
        .decode_immediate(decode_immediate),

        .decode_rs1(decode_rs1),
        .decode_rs2(decode_rs2),
        .decode_rd(decode_rd),

        .decode_alu_control(decode_alu_control),
        .decode_reg_write(decode_reg_write),
        .decode_mem_read(decode_mem_read),
        .decode_mem_write(decode_mem_write),
        .decode_mem_to_reg(decode_mem_to_reg),
        .decode_alu_src(decode_alu_src),

        .execute_result(execute_result),
        .execute_store_data(execute_store_data),
        .execute_zero(execute_zero),
        .memory_read_data(memory_read_data),

        .wb_alu_result(wb_alu_result),
        .wb_memory_data(wb_memory_data),
        .wb_rd(wb_rd),
        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waves/pipelined_alu_top.vcd");
        $dumpvars(0, tb_pipelined_alu_top);

        rst = 1'b1;

        stall_request = 1'b0;
        flush_request = 1'b0;

        fetch_pc = 32'h00000000;
        fetch_instruction = 32'h00000000;

        decode_rs1_value = 32'h00000000;
        decode_rs2_value = 32'h00000000;
        decode_immediate = 32'h00000000;

        decode_rs1 = 5'd0;
        decode_rs2 = 5'd0;
        decode_rd = 5'd0;
        decode_alu_control = 4'h0;

        decode_reg_write = 1'b0;
        decode_mem_read = 1'b0;
        decode_mem_write = 1'b0;
        decode_mem_to_reg = 1'b0;
        decode_alu_src = 1'b0;

        execute_result = 32'h00000000;
        execute_store_data = 32'h00000000;
        execute_zero = 1'b0;

        memory_read_data = 32'h00000000;

        #12;

        rst = 1'b0;

        fetch_pc = 32'h00000004;
        fetch_instruction = 32'h00000093;

        decode_rs1_value = 32'h00000005;
        decode_rs2_value = 32'h00000003;
        decode_immediate = 32'h00000008;

        decode_rs1 = 5'd1;
        decode_rs2 = 5'd2;
        decode_rd = 5'd10;

        decode_alu_control = 4'h1;
        decode_reg_write = 1'b1;
        decode_mem_read = 1'b0;
        decode_mem_write = 1'b0;
        decode_mem_to_reg = 1'b0;
        decode_alu_src = 1'b0;

        execute_result = 32'h0000000F;
        execute_store_data = 32'h00000000;
        execute_zero = 1'b0;

        #20;

        fetch_pc = 32'h00000008;
        fetch_instruction = 32'h00100113;

        decode_rd = 5'd11;
        decode_rs1_value = 32'h0000000A;
        decode_rs2_value = 32'h00000002;
        execute_result = 32'h0000002A;

        #20;

        decode_rd = 5'd12;
        decode_reg_write = 1'b1;
        decode_mem_read = 1'b1;
        decode_mem_write = 1'b0;
        decode_mem_to_reg = 1'b1;

        execute_result = 32'h00000120;
        memory_read_data = 32'h12345678;

        #20;

        stall_request = 1'b1;
        fetch_pc = 32'h0000000C;
        fetch_instruction = 32'h002081B3;

        decode_rd = 5'd13;
        execute_result = 32'hAAAAAAAA;
        memory_read_data = 32'hBBBBBBBB;

        #10;

        stall_request = 1'b0;

        fetch_pc = 32'h00000010;
        fetch_instruction = 32'h00310233;

        decode_rd = 5'd14;
        decode_mem_read = 1'b0;
        decode_mem_to_reg = 1'b0;
        execute_result = 32'h00000055;
        memory_read_data = 32'hCCCCCCCC;

        #20;

        flush_request = 1'b1;
        fetch_pc = 32'h00000014;
        fetch_instruction = 32'hFFFFFFFF;

        decode_rd = 5'd15;
        execute_result = 32'h22222222;
        memory_read_data = 32'h11111111;

        #10;

        flush_request = 1'b0;
        fetch_pc = 32'h00000018;
        fetch_instruction = 32'h004182B3;

        decode_rd = 5'd16;
        decode_reg_write = 1'b1;
        decode_mem_to_reg = 1'b0;

        execute_result = 32'h00000099;
        memory_read_data = 32'h33333333;

        #30;

        $finish;
    end

endmodule