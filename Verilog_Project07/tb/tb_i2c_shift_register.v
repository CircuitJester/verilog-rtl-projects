`timescale 1ns/1ps

module tb_i2c_shift_register;

parameter DATA_WIDTH = 8;

reg scl;
reg rst;
reg load;
reg shift;
reg [DATA_WIDTH-1:0] data_in;

wire sda;
wire [DATA_WIDTH-1:0] shift_reg;

i2c_shift_register #(
    .DATA_WIDTH(DATA_WIDTH)
) uut(

    .scl(scl),
    .rst(rst),
    .load(load),
    .shift(shift),
    .data_in(data_in),
    .sda(sda),
    .shift_reg(shift_reg)

);

always #5 scl = ~scl;

initial
begin

    $dumpfile("waves/i2c_shift_register.vcd");
    $dumpvars(0,tb_i2c_shift_register);

    scl = 0;
    rst = 1;
    load = 0;
    shift = 0;

    data_in = 8'b10100110;

    #20;
    rst = 0;
    #10;
    load = 1;
    #10;
    load = 0;
    shift = 1;
    #100;

    shift = 0;
    #30;
    $finish;

end
endmodule