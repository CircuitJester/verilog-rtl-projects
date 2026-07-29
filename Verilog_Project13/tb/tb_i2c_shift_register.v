`timescale 1ns/1ps

module tb_i2c_shift_register;

parameter DATA_WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg load;
reg shift;
reg [DATA_WIDTH-1:0] tx_data;
reg sda_in;

// Outputs
wire sda_out;
wire [DATA_WIDTH-1:0] rx_data;
wire done;

// DUT
i2c_shift_register #

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
    .sda_in(sda_in),
    .sda_out(sda_out),
    .rx_data(rx_data),
    .done(done)
);

// Clock
always #5 clk = ~clk;

// Test
initial
begin

    $dumpfile("waves/i2c_shift_register.vcd");
    $dumpvars(0,tb_i2c_shift_register);

    clk = 0;
    rst = 1;

    load = 0;
    shift = 0;
    tx_data = 8'hA5;
    sda_in = 0;

    // Reset
    #20;
    rst = 0;

    // Load Data
    #20;
    load = 1;
    #10;
    load = 0;

    // Shift 8 Bits
    shift = 1;

    sda_in = 1; #10;
    sda_in = 0; #10;
    sda_in = 1; #10;
    sda_in = 1; #10;
    sda_in = 1; #10;
    sda_in = 1; #10;
    sda_in = 0; #10;
    sda_in = 0; #10;

    shift = 0;

    #50;
    $finish;

end
endmodule