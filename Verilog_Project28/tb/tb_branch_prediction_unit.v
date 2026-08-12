`timescale 1ns/1ps

module tb_branch_prediction_unit;

reg [31:0] current_pc;
reg [31:0] branch_offset;
reg branch_valid;

wire predict_taken;
wire [31:0] predicted_pc;

branch_prediction_unit dut (
    .current_pc(current_pc),
    .branch_offset(branch_offset),
    .branch_valid(branch_valid),
    .predict_taken(predict_taken),
    .predicted_pc(predicted_pc)
);

task automatic test_branch;
    input [31:0] test_pc;
    input [31:0] test_offset;
    input test_branch_valid;

    begin
        current_pc = test_pc;
        branch_offset = test_offset;
        branch_valid = test_branch_valid;
        #10;
    end
endtask

initial begin
    $dumpfile("waves/branch_prediction_unit.vcd");
    $dumpvars(0, tb_branch_prediction_unit);

    current_pc = 32'h00000000;
    branch_offset = 32'h00000000;
    branch_valid  = 1'b0;

    #10;

    test_branch(32'h00001000, 32'h00000010, 1'b0);
    test_branch(32'h00001000, 32'h00000010, 1'b1);
    test_branch(32'h00002000, 32'h00000020, 1'b1);
    test_branch(32'h00003000, 32'hFFFFFFE0, 1'b1);
    test_branch(32'h00004000, 32'h00000100, 1'b1);
    test_branch(32'h00005000, 32'hFFFFFFF0, 1'b1);

    #10;

    $finish;
    
end

endmodule