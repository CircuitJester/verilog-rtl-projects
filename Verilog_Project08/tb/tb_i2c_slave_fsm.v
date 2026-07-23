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

i2c_slave_fsm uut(

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

// Clock Generation

always #5 scl = ~scl;

// Test Sequence

initial
begin

    $dumpfile("waves/i2c_slave_fsm.vcd");
    $dumpvars(0, tb_i2c_slave_fsm);

    scl = 0;
    rst = 1;

    start_detected = 0;
    address_match  = 0;
    byte_done      = 0;
    stop_detected  = 0;

    // Reset
    
    #20;
    rst = 0;

    // START detected
    
    #10;
    start_detected = 1;
    #10;
    start_detected = 0;

    // Address received 

    address_match = 1;
    #20;
    byte_done = 1;
    #10;
    byte_done = 0;

    // Receive Data Byte

    #30;
    byte_done = 1;
    #10;
    byte_done = 0;

    // STOP detected
    
    #20;
    stop_detected = 1;
    #10;
    stop_detected = 0;

   

    #40;

    $finish;

end
endmodule