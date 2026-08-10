`timescale 1ns/1ps

module tb_hazard_detection_unit;

    reg id_ex_mem_read;
    reg [4:0] id_ex_rd;
    reg [4:0] if_id_rs1;
    reg [4:0] if_id_rs2;

    wire pc_write;
    wire if_id_write;
    wire id_ex_flush;

    hazard_detection_unit dut (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush)
    );

    task automatic check_hazard;
        input load_active;

        input [4:0] load_destination;
        input [4:0] source_one;
        input [4:0] source_two;
        input expected_pc_write;
        input expected_if_id_write;
        input expected_flush;

        begin
            id_ex_mem_read = load_active;
            id_ex_rd = load_destination;
            if_id_rs1 = source_one;
            if_id_rs2 = source_two;

            #1;

            if ((pc_write !== expected_pc_write) ||
                (if_id_write !== expected_if_id_write) ||
                (id_ex_flush !== expected_flush)) begin

                $display("FAIL: MemRead=%b Rd=%0d Rs1=%0d Rs2=%0d | PC=%b IF_ID=%b FLUSH=%b",
                         load_active,
                         load_destination,
                         source_one,
                         source_two,
                         pc_write,
                         if_id_write,
                         id_ex_flush);
            end
            else 
            begin

                $display("PASS: MemRead=%b Rd=%0d Rs1=%0d Rs2=%0d | PC=%b IF_ID=%b FLUSH=%b",
                         load_active,
                         load_destination,
                         source_one,
                         source_two,
                         pc_write,
                         if_id_write,
                         id_ex_flush);
            end

        end

    endtask

    initial begin
        $dumpfile("waves/hazard_detection_unit.vcd");
        $dumpvars(0, tb_hazard_detection_unit);

        id_ex_mem_read = 1'b0;
        id_ex_rd = 5'd0;
        if_id_rs1 = 5'd0;
        if_id_rs2 = 5'd0;

        #5;

        check_hazard(
            1'b0, 5'd10, 5'd10, 5'd4,
            1'b1, 1'b1, 1'b0
        );

        check_hazard(
            1'b1, 5'd10, 5'd10, 5'd4,
            1'b0, 1'b0, 1'b1
        );

        check_hazard(
            1'b1, 5'd11, 5'd4, 5'd11,
            1'b0, 1'b0, 1'b1
        );

        check_hazard(
            1'b1, 5'd12, 5'd3, 5'd4,
            1'b1, 1'b1, 1'b0
        );

        check_hazard(
            1'b1, 5'd0, 5'd0, 5'd4,
            1'b1, 1'b1, 1'b0
        );

        check_hazard(
            1'b1, 5'd15, 5'd15, 5'd15,
            1'b0, 1'b0, 1'b1
        );

        check_hazard(
            1'b1, 5'd20, 5'd15, 5'd16,
            1'b1, 1'b1, 1'b0
        );

        #10;

        $finish;

    end

endmodule