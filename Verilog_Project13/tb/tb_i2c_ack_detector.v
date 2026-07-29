`timescale 1ns/1ps

module tb_i2c_ack_detector;

// Inputs
reg clk;
reg rst;
reg check_ack;
reg sda;

// Outputs
wire ack;
wire error;

// DUT
i2c_ack_detector uut
(
    .clk(clk),
    .rst(rst),
    .check_ack(check_ack),
    .sda(sda),
    .ack(ack),
    .error(error)
);

// Clock
always #5 clk = ~clk;

// Test
initial
begin

    $dumpfile("waves/i2c_ack_detector.vcd");
    $dumpvars(0,tb_i2c_ack_detector);

    clk = 0;
    rst = 1;

    check_ack = 0;
    sda = 1;

    // Reset
    #20;
    rst = 0;

    // Test ACK
    #20;
    sda = 0;
    check_ack = 1;
    #10;
    check_ack = 0;

    // Wait
    #40;

    // Test NACK
    sda = 1;
    check_ack = 1;
    #10;
    check_ack = 0;

    #50;
    $finish;

end
endmodule