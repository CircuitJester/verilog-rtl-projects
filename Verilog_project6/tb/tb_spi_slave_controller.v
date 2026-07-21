`timescale 1ns/1ps

module tb_spi_slave_controller;

reg spi_clk;
reg rst;
reg cs;
reg done;

wire load;
wire busy;

spi_slave_controller uut(

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .done(done),
    .load(load),
    .busy(busy)

);
always #5 spi_clk = ~spi_clk;

initial
begin

    $dumpfile("waves/spi_slave_controller.vcd");
    $dumpvars(0, tb_spi_slave_controller);

    spi_clk = 0;
    rst = 1;
    cs = 1;
    done = 0;

    // Reset
    #20;
    rst = 0;

    // Wait in IDLE
    #20;

    // Master selects slave
    cs = 0;

    // Receive data for a while
    #60;

    // Byte received
    done = 1;
    #10;
    done = 0;

    // Master releases slave
    #30;
    cs = 1;
    #30;

    $finish;
end
endmodule