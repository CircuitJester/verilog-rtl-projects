module id_ex_pipeline_register (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    input wire [31:0] pc_in,
    input wire [31:0] rs1_value_in,
    input wire [31:0] rs2_value_in,
    input wire [31:0] immediate_in,

    input wire [4:0] rs1_in,
    input wire [4:0] rs2_in,
    input wire [4:0] rd_in,

    input wire [3:0]  alu_control_in,
    input wire reg_write_in,
    input wire mem_read_in,
    input wire mem_write_in,
    input wire mem_to_reg_in,
    input wire alu_src_in,

    output reg [31:0] pc_out,
    output reg [31:0] rs1_value_out,
    output reg [31:0] rs2_value_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg [3:0]  alu_control_out,
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg alu_src_out
);

    always @(posedge clk) begin
        if (rst || flush) begin
            pc_out <= 32'b0;
            rs1_value_out <= 32'b0;
            rs2_value_out <= 32'b0;
            immediate_out <= 32'b0;

            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out <= 5'b0;

            alu_control_out <= 4'b0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out  <= 1'b0;
            mem_to_reg_out <= 1'b0;
            alu_src_out <= 1'b0;
        end
        else if (!stall) begin
            pc_out <= pc_in;
            rs1_value_out <= rs1_value_in;
            rs2_value_out <= rs2_value_in;
            immediate_out <= immediate_in;

            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;

            alu_control_out <= alu_control_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            alu_src_out <= alu_src_in;
        end
    end

endmodule