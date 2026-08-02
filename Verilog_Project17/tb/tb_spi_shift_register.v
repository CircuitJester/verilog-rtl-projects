`timescale 1ns/1ps

module tb_spi_shift_register;

// Parameters
parameter DATA_WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg load;
reg shift_enable;
reg [DATA_WIDTH-1:0] tx_data;
reg miso;

// Outputs
wire mosi;
wire [DATA_WIDTH-1:0] rx_data;
wire shift_done;

// DUT
spi_shift_register
#(
    .DATA_WIDTH(DATA_WIDTH)
)
uut
(
    .clk(clk),
    .rst(rst),
    .load(load),
    .shift_enable(shift_enable),
    .tx_data(tx_data),
    .miso(miso),
    .mosi(mosi),
    .rx_data(rx_data),
    .shift_done(shift_done)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/spi_shift_register.vcd");
    $dumpvars(0,tb_spi_shift_register);

    clk = 0;
    rst = 1;
    load = 0;
    shift_enable = 0;
    tx_data = 8'hA5;
    miso = 0;

    // Reset
    #20;
    rst = 0;

    // Load Transmit Data
    #10;
    load = 1;
    #10;
    load = 0;

    // Shift 8 Bits
    repeat(8)

    begin

        miso = ~miso;
        shift_enable = 1;
        #10;
        shift_enable = 0;
        #10;

    end

    #40;
    $finish;

end
endmodule