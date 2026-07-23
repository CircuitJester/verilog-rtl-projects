`timescale 1ns/1ps

module tb_i2c_slave_shift_register;

parameter DATA_WIDTH = 8;

reg scl;
reg rst;
reg load;
reg sda;

wire [DATA_WIDTH-1:0] rx_data;

i2c_slave_shift_register #(
    .DATA_WIDTH(DATA_WIDTH)
) uut(

    .scl(scl),
    .rst(rst),
    .load(load),
    .sda(sda),
    .rx_data(rx_data)

);

always #5 scl = ~scl;

initial
begin

    $dumpfile("waves/i2c_slave_shift_register.vcd");
    $dumpvars(0, tb_i2c_slave_shift_register);

    scl = 0;
    rst = 1;
    load = 0;
    sda = 0;
    #20;
    rst = 0;
    load = 1;

    // Send 10110010

    sda = 1; #10;
    sda = 0; #10;
    sda = 1; #10;
    sda = 1; #10;
    sda = 0; #10;
    sda = 0; #10;
    sda = 1; #10;
    sda = 0; #10;

    load = 0;

    #30;

    $finish;
end
endmodule