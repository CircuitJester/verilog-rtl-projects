`timescale 1ns/1ps

module tb_i2c_master_fsm;

reg scl;
reg rst;
reg start;
reg done;
reg ack_received;

wire start_condition;
wire stop_condition;
wire load;
wire shift;
wire ack_enable;
wire busy;

i2c_master_fsm uut(

    .scl(scl),
    .rst(rst),
    .start(start),
    .done(done),
    .ack_received(ack_received),
    .start_condition(start_condition),
    .stop_condition(stop_condition),
    .load(load),
    .shift(shift),
    .ack_enable(ack_enable),
    .busy(busy)

);

always #5 scl = ~scl;

initial
begin

    $dumpfile("waves/i2c_master_fsm.vcd");
    $dumpvars(0,tb_i2c_master_fsm);

    scl = 0;
    rst = 1;
    start = 0;
    done = 0;
    ack_received = 0;

    #20;
    rst = 0;
    #20;
    start = 1;
    #10;
    start = 0;
    #80;
    done = 1;
    #10;
    done = 0;
    #20;
    ack_received = 1;
    #50;
    $finish;

end
endmodule