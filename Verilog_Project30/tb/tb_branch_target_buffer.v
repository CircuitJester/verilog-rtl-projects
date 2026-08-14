`timescale 1ns/1ps

module tb_branch_target_buffer;

reg clk;
reg rst;

reg [31:0] lookup_pc;

reg update_enable;
reg [31:0] branch_pc;
reg [31:0] branch_target;

wire hit;
wire [31:0] target_pc;

branch_target_buffer dut (

    .clk(clk),
    .rst(rst),
    .lookup_pc(lookup_pc),
    .update_enable(update_enable),
    .branch_pc(branch_pc),
    .branch_target(branch_target),
    .hit(hit),
    .target_pc(target_pc)

);

task automatic update_entry;
    input [31:0] source_pc;
    input [31:0] destination_pc;

    begin

        branch_pc = source_pc;
        branch_target = destination_pc;
        update_enable = 1'b1;

        #10;
        update_enable = 1'b0;

    end

endtask

task automatic lookup_entry;
    input [31:0] source_pc;

    begin
        lookup_pc = source_pc;
        #10;

    end

endtask

initial 

begin

    clk = 1'b0;
    forever #5 clk = ~clk;

end

initial begin
    $dumpfile("waves/branch_target_buffer.vcd");
    $dumpvars(0, tb_branch_target_buffer);

    rst = 1'b1;
    lookup_pc = 32'h00000000;
    update_enable = 1'b0;
    branch_pc = 32'h00000000;
    branch_target = 32'h00000000;

    #12;

    rst = 1'b0;
    lookup_entry(32'h00000020);

    update_entry(
        32'h00000020,
        32'h00000100
    );

    lookup_entry(32'h00000020);

    update_entry(
        32'h00000030,
        32'h00000200

    );

    lookup_entry(32'h00000030);
    lookup_entry(32'h00000040);

    update_entry(
        32'h00000020,
        32'h00000300
    );

    lookup_entry(32'h00000020);
    lookup_entry(32'h00000120);

    $finish;

end

endmodule