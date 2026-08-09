`timescale 1ns/1ps

module tb_i2c_ack_detector;

reg scl;
reg rst;
reg ack_enable;
reg sda;

wire ack_received;

i2c_ack_detector dut (

    .scl(scl),
    .rst(rst),
    .ack_enable(ack_enable),
    .sda(sda),
    .ack_received(ack_received)
    
);

always #5 scl = ~scl;

initial begin

    $dumpfile("waves/i2c_ack_detector.vcd");
    $dumpvars(0, tb_i2c_ack_detector);

    scl = 1'b0;
    rst = 1'b1;
    ack_enable = 1'b0;
    sda = 1'b1;

    #20;
    rst = 1'b0;

    #20;
    ack_enable = 1'b1;
    sda = 1'b0;

    #10;
    ack_enable = 1'b0;

    #40;

    ack_enable = 1'b1;
    sda = 1'b1;

    #10;
    ack_enable = 1'b0;

    #40;
    $finish;

end

endmodule