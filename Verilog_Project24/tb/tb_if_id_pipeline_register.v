`timescale 1ns/1ps

module tb_if_id_pipeline_register;

    reg clk;
    reg rst;
    reg stall;
    reg flush;

    reg [31:0] fetch_pc;
    reg [31:0] fetched_instruction;

    wire [31:0] registered_pc;
    wire [31:0] registered_instruction;

    if_id_pipeline_register dut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_in(fetch_pc),
        .instruction_in(fetched_instruction),
        .pc_out(registered_pc),
        .instruction_out(registered_instruction)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waves/if_id_pipeline_register.vcd");
        $dumpvars(0, tb_if_id_pipeline_register);

        rst = 1'b1;
        stall = 1'b0;
        flush = 1'b0;

        fetch_pc = 32'h00000000;
        fetched_instruction = 32'h00000000;

        #12;

        rst = 1'b0;

        fetch_pc = 32'h00000004;
        fetched_instruction = 32'h00500093;

        #10;

        fetch_pc = 32'h00000008;
        fetched_instruction = 32'h00A00113;

        #10;

        stall = 1'b1;

        fetch_pc = 32'h0000000C;
        fetched_instruction = 32'h00F00193;

        #10;

        stall = 1'b0;

        fetch_pc = 32'h00000010;
        fetched_instruction = 32'h01400213;

        #10;

        flush = 1'b1;

        fetch_pc = 32'h00000014;
        fetched_instruction = 32'h00100293;

        #10;

        flush = 1'b0;

        fetch_pc = 32'h00000018;
        fetched_instruction = 32'h00200313;

        #20;

        $finish;
    end

endmodule