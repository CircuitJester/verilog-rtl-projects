`timescale 1ns/1ps

module tb_i2c_clock_generator;

reg clk;
reg rst;
reg [15:0] clk_divider;

wire scl;

i2c_clock_generator uut(

    .clk(clk),
    .rst(rst),
    .clk_divider(clk_divider),
    .scl(scl)
);

always #5 clk = ~clk;

initial
begin

    $dumpfile("waves/i2c_clock_generator.vcd");
    $dumpvars(0,tb_i2c_clock_generator);

    clk = 0;
    rst = 1;

    clk_divider = 4;
    #20;
    rst = 0;

    #300;

    $finish;

end
endmodule