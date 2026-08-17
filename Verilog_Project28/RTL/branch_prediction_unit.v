module branch_prediction_unit (
    input  wire [31:0] current_pc,
    input  wire [31:0] branch_offset,
    input  wire branch_valid,

    output reg predict_taken,
    output reg [31:0] predicted_pc
);

always @(*) begin
    predict_taken = 1'b0;
    predicted_pc = current_pc + 32'd4;

    if (branch_valid) begin
        predict_taken = 1'b1;
        predicted_pc = current_pc + branch_offset;
    end
end

endmodule