`timescale 1ns/1ps

module tb_can_ack_generator;

reg crc_valid;
reg frame_received;

wire ack;

can_ack_generator uut(

.crc_valid(crc_valid),
.frame_received(frame_received),

.ack(ack)

);

initial
begin

    $dumpfile("waves/can_ack_generator.vcd");
    $dumpvars(0, tb_can_ack_generator);

    // Test 1

    crc_valid = 0;
    frame_received = 0;
    #20;

    // Test 2

    frame_received = 1;
    crc_valid = 0;
    #20;
    // Test 3

    frame_received = 1;
    crc_valid = 1;
    #20;

    // Test 4

    frame_received = 0;
    crc_valid = 1;
    #20;
    $finish;

end
endmodule