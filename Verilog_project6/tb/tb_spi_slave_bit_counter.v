`timescale 1ns/1ps

module tb_spi_slave_bit_counter;

parameter DATA_WIDTH = 8;

reg spi_clk;
reg rst;
reg cs;

wire done;
wire [$clog2(DATA_WIDTH)-1:0] bit_count;

spi_slave_bit_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .done(done),
    .bit_count(bit_count)

);

always #5 spi_clk = ~spi_clk;

initial begin

    $dumpfile("waves/spi_slave_bit_counter.vcd");
    $dumpvars(0, tb_spi_slave_bit_counter);

    spi_clk = 0;
    rst = 1;
    cs = 1;

    #20;
    rst = 0;
    #20;
    cs = 0;

    #100;

    cs = 1;
    #40;

    $finish;

end
endmodule