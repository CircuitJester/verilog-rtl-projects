`timescale 1ns/1ps

module tb_i2c_bit_counter;

parameter DATA_WIDTH = 8;

reg scl;
reg rst;
reg enable;

wire done;
wire [$clog2(DATA_WIDTH)-1:0] bit_count;

i2c_bit_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (

    .scl(scl),
    .rst(rst),
    .enable(enable),
    .done(done),
    .bit_count(bit_count)

);

always #5 scl = ~scl;

initial
begin

    $dumpfile("waves/i2c_bit_counter.vcd");
    $dumpvars(0, tb_i2c_bit_counter);

    scl = 0;
    rst = 1;
    enable = 0;

    #20;
    rst = 0;
    #20;
    enable = 1;

    #100;
    enable = 0;
    #40;

    $finish;

end
endmodule