module branch_control_unit (
    input  wire branch_enable,
    input  wire branch_taken,
    input  wire [31:0] current_pc,
    input  wire [31:0] branch_offset,

    output reg flush_pipeline,
    output reg [31:0] target_pc
);

always @(*) begin
    flush_pipeline = 1'b0;
    target_pc = current_pc + 32'd4;

    if (branch_enable && branch_taken) begin
        flush_pipeline = 1'b1;
        target_pc = current_pc + branch_offset;
    end
end

endmodule