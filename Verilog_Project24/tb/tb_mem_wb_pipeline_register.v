`timescale 1ns/1ps

module tb_mem_wb_pipeline_register;
    reg clock;
    reg reset;
    reg pipeline_stall;
    reg pipeline_flush;

    reg [31:0] memory_read_data;
    reg [31:0] alu_result;
    reg [4:0] destination_register;
    reg register_write_enable;
    reg select_memory_data;

    wire [31:0] registered_memory_data;
    wire [31:0] registered_alu_result;
    wire [4:0] registered_destination;
    wire registered_write_enable;
    wire registered_memory_select;

    mem_wb_pipeline_register dut (
        .clk(clock),
        .rst(reset),
        .stall(pipeline_stall),
        .flush(pipeline_flush),
        .mem_data_in(memory_read_data),
        .alu_result_in(alu_result),
        .rd_in(destination_register),
        .reg_write_in(register_write_enable),
        .mem_to_reg_in(select_memory_data),
        .mem_data_out(registered_memory_data),
        .alu_result_out(registered_alu_result),
        .rd_out(registered_destination),
        .reg_write_out(registered_write_enable),
        .mem_to_reg_out(registered_memory_select)
    );

    task automatic drive_transaction;
        input [31:0] next_memory_data;
        input [31:0] next_alu_result;
        input [4:0] next_destination;
        input next_write_enable;
        input next_memory_select;
        begin
            memory_read_data = next_memory_data;
            alu_result = next_alu_result;
            destination_register = next_destination;
            register_write_enable = next_write_enable;
            select_memory_data = next_memory_select;
            #10;
        end
    endtask

    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock;
    end

    initial begin
        $dumpfile("waves/mem_wb_pipeline_register.vcd");
        $dumpvars(0, tb_mem_wb_pipeline_register);

        reset = 1'b1;
        pipeline_stall = 1'b0;
        pipeline_flush = 1'b0;
        memory_read_data = 32'h00000000;
        alu_result = 32'h00000000;
        destination_register = 5'd0;
        register_write_enable = 1'b0;
        select_memory_data = 1'b0;
        #12;

        reset = 1'b0;
        drive_transaction(32'hDEADBEEF, 32'h0000000F, 5'd10, 1'b1, 1'b0);
        drive_transaction(32'hAAAAAAAA, 32'h0000002A, 5'd11, 1'b1, 1'b0);
        drive_transaction(32'h12345678, 32'h00000120, 5'd12, 1'b1, 1'b1);
        drive_transaction(32'hCAFEBABE, 32'h00000200, 5'd13, 1'b1, 1'b1);
        drive_transaction(32'hFFFFFFFF, 32'h00000055, 5'd14, 1'b0, 1'b0);

        pipeline_stall = 1'b1;
        drive_transaction(32'hAAAAAAAA, 32'hBBBBBBBB, 5'd20, 1'b1, 1'b1);

        pipeline_stall = 1'b0;
        drive_transaction(32'h00000077, 32'h00000088, 5'd15, 1'b1, 1'b0);

        pipeline_flush = 1'b1;
        drive_transaction(32'h11111111, 32'h22222222, 5'd18, 1'b1, 1'b1);

        pipeline_flush = 1'b0;
        drive_transaction(32'h33333333, 32'h00000099, 5'd21, 1'b1, 1'b0);

        $finish;
    end
endmodule