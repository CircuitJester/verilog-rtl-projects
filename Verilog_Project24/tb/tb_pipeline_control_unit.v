`timescale 1ns/1ps

module tb_pipeline_control_unit;

    reg stall_request;
    reg flush_request;

    wire pc_write;
    wire if_id_write;
    wire id_ex_flush;

    pipeline_control_unit dut (
        .stall_request(stall_request),
        .flush_request(flush_request),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush)
    );

    initial begin
        $dumpfile("waves/pipeline_control_unit.vcd");
        $dumpvars(0, tb_pipeline_control_unit);

        stall_request = 1'b0;
        flush_request = 1'b0;
        #10;

        stall_request = 1'b1;
        flush_request = 1'b0;
        #10;

        stall_request = 1'b0;
        flush_request = 1'b1;
        #10;

        stall_request = 1'b1;
        flush_request = 1'b1;
        #10;

        stall_request = 1'b0;
        flush_request = 1'b0;
        #10;

        $finish;
    end

endmodule