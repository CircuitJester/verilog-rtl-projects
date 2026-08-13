module if_id_pipeline_register (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    input wire [31:0] pc_in,
    input wire [31:0] instruction_in,

    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);

    always @(posedge clk) begin
        if (rst || flush) begin
            pc_out <= 32'b0;
            instruction_out <= 32'b0;
        end
        else if (!stall) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
        end
    end

endmodule