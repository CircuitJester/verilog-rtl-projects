`timescale 1ns/1ps

module tb_forwarding_unit;

reg [4:0] ex_mem_rd;
reg ex_mem_reg_write;

reg [4:0] mem_wb_rd;
reg mem_wb_reg_write;

reg  [4:0] id_ex_rs1;
reg  [4:0] id_ex_rs2;

wire [1:0] forward_a;
wire [1:0] forward_b;

forwarding_unit dut (
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

task automatic apply_case;
    input [4:0] ex_rd;
    input ex_write;
    input [4:0] wb_rd;
    input wb_write;
    input [4:0] source_a;
    input [4:0] source_b;

    begin
        ex_mem_rd = ex_rd;
        ex_mem_reg_write = ex_write;
        mem_wb_rd = wb_rd;
        mem_wb_reg_write = wb_write;
        id_ex_rs1 = source_a;
        id_ex_rs2 = source_b;
        #10;
    end
endtask

initial 
begin

    $dumpfile("waves/forwarding_unit.vcd");
    $dumpvars(0, tb_forwarding_unit);

    ex_mem_rd = 5'd0;
    ex_mem_reg_write = 1'b0;
    mem_wb_rd = 5'd0;
    mem_wb_reg_write = 1'b0;
    id_ex_rs1 = 5'd0;
    id_ex_rs2 = 5'd0;

    #10;

    apply_case(5'd10, 1'b1, 5'd0,  1'b0, 5'd10, 5'd3);
    apply_case(5'd0,  1'b0, 5'd11, 1'b1, 5'd2,  5'd11);
    apply_case(5'd12, 1'b1, 5'd13, 1'b1, 5'd12, 5'd13);
    apply_case(5'd14, 1'b1, 5'd15, 1'b1, 5'd14, 5'd15);

    apply_case(5'd20, 1'b1, 5'd21, 1'b0, 5'd1,  5'd2);
    apply_case(5'd0,  1'b0, 5'd22, 1'b1, 5'd1,  5'd2);

    apply_case(5'd23, 1'b1, 5'd23, 1'b1, 5'd23, 5'd4);
    apply_case(5'd5,  1'b0, 5'd5,  1'b1, 5'd5,  5'd6);

    apply_case(5'd0,  1'b1, 5'd0,  1'b1, 5'd0,  5'd0);

    #10;

    $finish;
    
end

endmodule