`timescale 1ns/1ps

module tb_ex_mem_pipeline_register;

    reg clk;
    reg rst;
    reg stall;
    reg flush;

    reg [31:0] alu_result_value;
    reg [31:0] store_data_value;
    reg [4:0]  destination_register;
    reg alu_zero;

    reg enable_reg_write;
    reg enable_mem_read;
    reg enable_mem_write;
    reg select_memory_result;

    wire [31:0] registered_alu_result;
    wire [31:0] registered_store_data;
    wire [4:0]  registered_destination;
    wire registered_zero;

    wire registered_reg_write;
    wire registered_mem_read;
    wire registered_mem_write;
    wire registered_mem_to_reg;

    ex_mem_pipeline_register dut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),

        .alu_result_in(alu_result_value),
        .store_data_in(store_data_value),
        .rd_in(destination_register),
        .zero_in(alu_zero),

        .reg_write_in(enable_reg_write),
        .mem_read_in(enable_mem_read),
        .mem_write_in(enable_mem_write),
        .mem_to_reg_in(select_memory_result),

        .alu_result_out(registered_alu_result),
        .store_data_out(registered_store_data),
        .rd_out(registered_destination),
        .zero_out(registered_zero),

        .reg_write_out(registered_reg_write),
        .mem_read_out(registered_mem_read),
        .mem_write_out(registered_mem_write),
        .mem_to_reg_out(registered_mem_to_reg)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waves/ex_mem_pipeline_register.vcd");
        $dumpvars(0, tb_ex_mem_pipeline_register);

        rst = 1'b1;
        stall = 1'b0;
        flush = 1'b0;

        alu_result_value = 32'h00000000;
        store_data_value = 32'h00000000;
        destination_register = 5'd0;
        alu_zero = 1'b0;

        enable_reg_write = 1'b0;
        enable_mem_read = 1'b0;
        enable_mem_write = 1'b0;
        select_memory_result = 1'b0;


        #12;

        rst = 1'b0;

        alu_result_value = 32'h0000000F;
        store_data_value = 32'h12345678;
        destination_register = 5'd10;
        alu_zero = 1'b0;

        enable_reg_write = 1'b1;
        enable_mem_read = 1'b0;
        enable_mem_write = 1'b0;
        select_memory_result = 1'b0;


        #10;

        alu_result_value = 32'h0000002A;
        store_data_value = 32'hAAAAAAAA;
        destination_register = 5'd11;
        alu_zero = 1'b0;


        #10;

        stall = 1'b1;

        alu_result_value = 32'h00000120;
        store_data_value = 32'hBBBBBBBB;
        destination_register = 5'd12;
        alu_zero = 1'b1;

        enable_mem_read = 1'b1;
        select_memory_result = 1'b1;

        #10;


        stall = 1'b0;

        alu_result_value = 32'h00000200;
        store_data_value = 32'hCCCCCCCC;
        destination_register = 5'd13;
        alu_zero = 1'b0;

        enable_mem_read = 1'b0;
        select_memory_result = 1'b0;

        #10;


        flush = 1'b1;

        alu_result_value = 32'h00000300;
        store_data_value = 32'hDDDDDDDD;
        destination_register = 5'd14;
        alu_zero = 1'b1;

        enable_reg_write = 1'b1;
        enable_mem_write = 1'b1;

        #10;


        flush = 1'b0;

        alu_result_value = 32'h00000055;
        store_data_value = 32'hEEEEEEEE;
        destination_register = 5'd15;
        alu_zero = 1'b0;

        enable_mem_write = 1'b0;

        #20;

        $finish;
    end

endmodule