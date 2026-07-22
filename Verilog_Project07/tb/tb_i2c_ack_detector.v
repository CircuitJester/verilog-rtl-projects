`timescale 1ns/1ps

module tb_i2c_ack_detector;

reg scl;
reg rst;
reg ack_enable;
reg sda;

wire ack_received;

i2c_ack_detector uut(

    .scl(scl),
    .rst(rst),
    .ack_enable(ack_enable),
    .sda(sda),
    .ack_received(ack_received)

);

always #5 scl = ~scl;

initial
begin

    $dumpfile("waves/i2c_ack_detector.vcd");
    $dumpvars(0,tb_i2c_ack_detector);

    scl = 0;
    rst = 1;
    ack_enable = 0;
    sda = 1;
    #20;
    rst = 0;

    // Simulate ACK
    #20;
    ack_enable = 1;
    sda = 0;
    #10;
    ack_enable = 0;
    #40;

    // Simulate NACK
    ack_enable = 1;
    sda = 1;
    #10;
    ack_enable = 0;
    #40;
    $finish;

end
endmodule