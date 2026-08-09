`timescale 1ns/1ps

module tb_can_ack_generator;

reg crc_valid;
reg frame_received;
wire ack;

can_ack_generator dut (

    .crc_valid(crc_valid),
    .frame_received(frame_received),
    .ack(ack)
    
);

initial begin

    $dumpfile("waves/can_ack_generator.vcd");
    $dumpvars(0, tb_can_ack_generator);

    crc_valid = 1'b0;
    frame_received = 1'b0;
    #20;

    frame_received = 1'b1;
    crc_valid = 1'b0;
    #20;

    frame_received = 1'b1;
    crc_valid = 1'b1;
    #20;

    frame_received = 1'b0;
    crc_valid = 1'b1;
    #20;

    $finish;
end

endmodule