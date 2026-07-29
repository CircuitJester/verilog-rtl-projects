`timescale 1ns/1ps

module tb_i2c_master_top;

parameter DATA_WIDTH = 8;
parameter CLOCK_DIVIDER = 4;

// Inputs
reg clk;
reg rst;
reg start;
reg [DATA_WIDTH-1:0] tx_data;
reg sda_in;

// Outputs
wire scl;
wire sda_out;
wire busy;
wire done;
wire ack_error;
wire [DATA_WIDTH-1:0] rx_data;

// DUT
i2c_master_top #

(
    .DATA_WIDTH(DATA_WIDTH),
    .CLOCK_DIVIDER(CLOCK_DIVIDER)
)

uut
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .tx_data(tx_data),
    .sda_in(sda_in),
    .scl(scl),
    .sda_out(sda_out),
    .busy(busy),
    .done(done),
    .ack_error(ack_error),
    .rx_data(rx_data)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/i2c_master_top.vcd");
    $dumpvars(0,tb_i2c_master_top);

    clk = 0;
    rst = 1;

    start = 0;
    tx_data = 8'hA5;
    sda_in = 1;

    // Reset
    #20;
    rst = 0;

    // Start Transaction
    #20;
    start = 1;
    #10;
    start = 0;

    // Simulated ACK
    #120;
    sda_in = 0;

    // Simulated Read Bits
    #20; sda_in = 1;
    #10; sda_in = 0;
    #10; sda_in = 1;
    #10; sda_in = 1;
    #10; sda_in = 0;
    #10; sda_in = 0;
    #10; sda_in = 1;
    #10; sda_in = 1;

    #200;
    $finish;
end
endmodule