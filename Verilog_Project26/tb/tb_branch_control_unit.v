`timescale 1ns/1ps

module tb_branch_control_unit;

    reg branch_enable;
    reg branch_taken;
    reg [31:0] current_pc;
    reg [31:0] branch_offset;

    wire flush_pipeline;
    wire [31:0] target_pc;

    branch_control_unit dut (
        .branch_enable(branch_enable),
        .branch_taken(branch_taken),
        .current_pc(current_pc),
        .branch_offset(branch_offset),
        .flush_pipeline(flush_pipeline),
        .target_pc(target_pc)
    );

    task automatic apply_branch_case;
        input enable;
        input taken;
        input [31:0] pc_value;
        input [31:0] offset;

        begin
            branch_enable = enable;
            branch_taken = taken;
            current_pc = pc_value;
            branch_offset = offset;
            #10;
        end
    endtask

    initial begin
        $dumpfile("waves/branch_control_unit.vcd");
        $dumpvars(0, tb_branch_control_unit);

        branch_enable = 1'b0;
        branch_taken  = 1'b0;
        current_pc = 32'h00000000;
        branch_offset = 32'h00000000;

        #10;

        // Normal sequential execution
        apply_branch_case(
            1'b0,
            1'b0,
            32'h00000000,
            32'h00000010
        );

        // Branch condition says taken but branch is disabled
        apply_branch_case(
            1'b0,
            1'b1,
            32'h00000020,
            32'h00000010
        );

        // Branch instruction exists but condition is false
        apply_branch_case(
            1'b1,
            1'b0,
            32'h00000040,
            32'h00000020
        );

        // Taken branch
        apply_branch_case(
            1'b1,
            1'b1,
            32'h00000080,
            32'h00000020
        );

        // Taken branch with a negative offset
        apply_branch_case(
            1'b1,
            1'b1,
            32'h00000100,
            -32'sd32
        );

        // Another normal instruction flow case
        apply_branch_case(
            1'b0,
            1'b0,
            32'h00000200,
            32'h00000040
        );

        #10;

        $finish;

    end

endmodule