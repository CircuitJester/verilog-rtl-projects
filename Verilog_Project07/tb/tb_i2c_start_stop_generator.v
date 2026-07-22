`timescale 1ns/1ps

module tb_i2c_start_stop_generator;

reg clk;
reg rst;
reg start;
reg stop;

wire sda;
wire busy;

i2c_start_stop_generator uut(

    .clk(clk),
    .rst(rst),
    .start(start),
    .stop(stop),
    .sda(sda),
    .busy(busy)

);

always #5 clk = ~clk;

initial
begin

    $dumpfile("waves/i2c_start_stop_generator.vcd");
    $dumpvars(0,tb_i2c_start_stop_generator);

    clk = 0;
    rst = 1;
    start = 0;
    stop = 0;
    #20;
    rst = 0;
    #20;

    // Generate START
    start = 1;
    #10;
    start = 0;
    #80;

    // Generate STOP
    stop = 1;
    #10;
    stop = 0;
    #50;

    $finish;

end
endmodule