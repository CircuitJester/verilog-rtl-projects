`timescale 1ns/1ps

module tb_spi_shift_register;

parameter DATA_WIDTH = 8;

// Inputs

reg clk;
reg rst;
reg load;
reg shift;
reg [DATA_WIDTH-1:0] tx_data;
reg miso;


// Outputs
wire mosi;
wire [DATA_WIDTH-1:0] rx_data;
wire done;

// DUT

spi_shift_register #

(
    .DATA_WIDTH(DATA_WIDTH)
)

uut

(
    .clk(clk),
    .rst(rst),
    .load(load),
    .shift(shift),
    .tx_data(tx_data),
    .miso(miso),
    .mosi(mosi),
    .rx_data(rx_data),
    .done(done)
);

// Clock

always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/spi_shift_register.vcd");
    $dumpvars(0, tb_spi_shift_register);

    clk = 0;
    rst = 1;

    load = 0;
    shift = 0;

    tx_data = 8'hA5;
    miso = 0;

    // Reset
    #20;
    rst = 0;

    // Load TX Register
    #10;
    load = 1;
    #10;
    load = 0;

    // Shift 8 Bits

    // Bit 7
    miso = 0;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 6
    miso = 0;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 5
    miso = 1;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 4
    miso = 1;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 3
    miso = 1;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 2
    miso = 1;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 1
    miso = 0;
    shift = 1;
    #10;
    shift = 0;
    #10;

    // Bit 0
    miso = 0;
    shift = 1;
    #10;
    shift = 0;
    #20;

    $finish;

end
endmodule