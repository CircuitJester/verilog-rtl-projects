`timescale 1ns/1ps

module tb_i2c_slave_fsm;

reg scl;
reg rst;
reg start_detected;
reg address_match;
reg byte_done;
reg stop_detected;

wire shift_enable;
wire ack_enable;
wire busy;

i2c_slave_fsm dut (
    .scl(scl),
    .rst(rst),
    .start_detected(start_detected),
    .address_match(address_match),
    .byte_done(byte_done),
    .stop_detected(stop_detected),
    .shift_enable(shift_enable),
    .ack_enable(ack_enable),
    .busy(busy)

);

always #5 scl = ~scl;

initial 

begin

    $dumpfile("waves/i2c_slave_fsm.vcd");
    $dumpvars(0, tb_i2c_slave_fsm);

    scl = 1'b0;
    rst = 1'b1;
    start_detected = 1'b0;
    address_match = 1'b0;
    byte_done = 1'b0;
    stop_detected = 1'b0;

    #20;
    rst = 1'b0;

    #10;
    start_detected = 1'b1;

    #10;
    start_detected = 1'b0;

    address_match = 1'b1;

    #20;
    byte_done = 1'b1;

    #10;
    byte_done = 1'b0;

    #30;
    byte_done = 1'b1;

    #10;
    byte_done = 1'b0;

    #20;
    stop_detected = 1'b1;

    #10;
    stop_detected = 1'b0;

    #40;
    $finish;
end

endmodule