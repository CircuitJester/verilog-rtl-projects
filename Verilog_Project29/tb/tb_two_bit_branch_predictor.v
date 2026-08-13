`timescale 1ns/1ps

module tb_two_bit_branch_predictor;

reg clk;
reg rst;
reg update_enable;
reg branch_taken_actual;

wire predict_taken;

two_bit_branch_predictor dut (
    .clk(clk),
    .rst(rst),
    .update_enable(update_enable),
    .branch_taken_actual(branch_taken_actual),
    .predict_taken(predict_taken)
);


task automatic apply_branch_outcome;
    input actual_taken;

    begin

        branch_taken_actual = actual_taken;
        update_enable = 1'b1;
        #10;

    end

endtask

initial 

begin

    clk = 1'b0;
    forever #5 clk = ~clk;

end

initial 

begin

    $dumpfile("waves/two_bit_branch_predictor.vcd");
    $dumpvars(0, tb_two_bit_branch_predictor);

    rst = 1'b1;
    update_enable = 1'b0;
    branch_taken_actual = 1'b0;

    #12;

    rst = 1'b0;

    apply_branch_outcome(1'b1);
    apply_branch_outcome(1'b1);
    apply_branch_outcome(1'b1);

    apply_branch_outcome(1'b0);
    apply_branch_outcome(1'b0);
    apply_branch_outcome(1'b0);

    update_enable = 1'b0;
    #10;

    $finish;

end

endmodule