module pipelined_alu_top (
    input wire clk,
    input wire rst,

    input wire stall_request,
    input wire flush_request,

    input wire [31:0] fetch_pc,
    input wire [31:0] fetch_instruction,

    input wire [31:0] decode_rs1_value,
    input wire [31:0] decode_rs2_value,
    input wire [31:0] decode_immediate,
    input wire [4:0] decode_rs1,
    input wire [4:0] decode_rs2,
    input wire [4:0] decode_rd,

    input wire [3:0]  decode_alu_control,
    input wire decode_reg_write,
    input wire decode_mem_read,
    input wire decode_mem_write,
    input wire decode_mem_to_reg,
    input wire decode_alu_src,

    input wire [31:0] execute_result,
    input wire [31:0] execute_store_data,
    input wire execute_zero,
    input wire [31:0] memory_read_data,

    output wire [31:0] wb_alu_result,
    output wire [31:0] wb_memory_data,
    output wire [4:0]  wb_rd,
    output wire wb_reg_write,
    output wire wb_mem_to_reg
);

    wire pc_write;
    wire if_id_write;
    wire id_ex_flush;

    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_rs1_value;
    wire [31:0] id_ex_rs2_value;
    wire [31:0] id_ex_immediate;

    wire [4:0] id_ex_rs1;
    wire [4:0] id_ex_rs2;
    wire [4:0] id_ex_rd;

    wire [3:0] id_ex_alu_control;
    wire id_ex_reg_write;
    wire id_ex_mem_read;
    wire id_ex_mem_write;
    wire id_ex_mem_to_reg;
    wire id_ex_alu_src;

    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_store_data;
    wire [4:0] ex_mem_rd;
    wire ex_mem_zero;

    wire ex_mem_reg_write;
    wire ex_mem_mem_read;
    wire ex_mem_mem_write;
    wire ex_mem_mem_to_reg;

    wire [31:0] mem_wb_data;
    wire [31:0] mem_wb_alu_result;
    wire [4:0] mem_wb_rd;

    wire mem_wb_reg_write;
    wire mem_wb_mem_to_reg;

    pipeline_control_unit control_unit (
        .stall_request(stall_request),
        .flush_request(flush_request),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush)
    );

    if_id_pipeline_register if_id (
        .clk(clk),
        .rst(rst),
        .stall(~if_id_write),
        .flush(flush_request),
        .pc_in(fetch_pc),
        .instruction_in(fetch_instruction),
        .pc_out(if_id_pc),
        .instruction_out(if_id_instruction)
    );

    id_ex_pipeline_register id_ex (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .flush(id_ex_flush),

        .pc_in(if_id_pc),
        .rs1_value_in(decode_rs1_value),
        .rs2_value_in(decode_rs2_value),
        .immediate_in(decode_immediate),
        .rs1_in(decode_rs1),
        .rs2_in(decode_rs2),
        .rd_in(decode_rd),

        .alu_control_in(decode_alu_control),
        .reg_write_in(decode_reg_write),
        .mem_read_in(decode_mem_read),
        .mem_write_in(decode_mem_write),
        .mem_to_reg_in(decode_mem_to_reg),
        .alu_src_in(decode_alu_src),

        .pc_out(id_ex_pc),
        .rs1_value_out(id_ex_rs1_value),
        .rs2_value_out(id_ex_rs2_value),
        .immediate_out(id_ex_immediate),
        .rs1_out(id_ex_rs1),
        .rs2_out(id_ex_rs2),
        .rd_out(id_ex_rd),

        .alu_control_out(id_ex_alu_control),
        .reg_write_out(id_ex_reg_write),
        .mem_read_out(id_ex_mem_read),
        .mem_write_out(id_ex_mem_write),
        .mem_to_reg_out(id_ex_mem_to_reg),
        .alu_src_out(id_ex_alu_src)
    );

    ex_mem_pipeline_register ex_mem (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .flush(flush_request),

        .alu_result_in(execute_result),
        .store_data_in(execute_store_data),
        .rd_in(id_ex_rd),
        .zero_in(execute_zero),

        .reg_write_in(id_ex_reg_write),
        .mem_read_in(id_ex_mem_read),
        .mem_write_in(id_ex_mem_write),
        .mem_to_reg_in(id_ex_mem_to_reg),

        .alu_result_out(ex_mem_alu_result),
        .store_data_out(ex_mem_store_data),
        .rd_out(ex_mem_rd),
        .zero_out(ex_mem_zero),

        .reg_write_out(ex_mem_reg_write),
        .mem_read_out(ex_mem_mem_read),
        .mem_write_out(ex_mem_mem_write),
        .mem_to_reg_out(ex_mem_mem_to_reg)
    );

    mem_wb_pipeline_register mem_wb (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .flush(flush_request),

        .mem_data_in(memory_read_data),
        .alu_result_in(ex_mem_alu_result),
        .rd_in(ex_mem_rd),

        .reg_write_in(ex_mem_reg_write),
        .mem_to_reg_in(ex_mem_mem_to_reg),

        .mem_data_out(mem_wb_data),
        .alu_result_out(mem_wb_alu_result),
        .rd_out(mem_wb_rd),

        .reg_write_out(mem_wb_reg_write),
        .mem_to_reg_out(mem_wb_mem_to_reg)
    );

    assign wb_alu_result = mem_wb_alu_result;
    assign wb_memory_data = mem_wb_data;
    assign wb_rd = mem_wb_rd;
    assign wb_reg_write = mem_wb_reg_write;
    assign wb_mem_to_reg = mem_wb_mem_to_reg;

endmodule