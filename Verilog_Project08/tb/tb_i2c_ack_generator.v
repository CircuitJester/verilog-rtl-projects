`timescale 1ns/1ps

module tb_i2c_ack_generator;

reg scl;
reg rst;

reg ack_enable;
reg address_match;

wire ack;

i2c_ack_generator uut(

    .scl(scl),
    .rst(rst),
    .ack_enable(ack_enable),
    .address_match(address_match),
    .ack(ack)

);

always #5 scl = ~scl;

initial
begin

    $dumpfile("waves/i2c_ack_generator.vcd");
    $dumpvars(0, tb_i2c_ack_generator);

    scl = 0;
    rst = 1;

    ack_enable = 0;
    address_match = 0;
    #20;
    rst = 0;

    // ACK Case

    address_match = 1;
    ack_enable = 1;
    #20;
    ack_enable = 0;
    #20;

    // NACK Case

    address_match = 0;
    ack_enable = 1;
    #20;
    ack_enable = 0;
    #30;

    $finish;

end
endmodule