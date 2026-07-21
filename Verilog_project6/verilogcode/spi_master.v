module spi_master #(
    parameter DATA_WIDTH = 8
) (

    input clk,
    input rst,
    input start,
    input [DATA_WIDTH-1:0] data_in,
    input [7:0] clk_divider,
    input miso,
    input cpol,

    output [DATA_WIDTH-1:0] rx_data,
    output spi_clk,
    output mosi,
    output busy,
    output cs

);

wire load;
wire shift;
wire enable;
wire done;
wire [DATA_WIDTH-1:0] shift_reg;
wire [2:0] bit_count;

// Clock Generator

spi_clock_generator clock_gen(

    .clk(clk),  //System clock enters.
    .rst(rst),
    .cpol(cpol),
    .spi_clk(spi_clk),  //Generated SPI clock leaves.
    .clk_divider(clk_divider)
);
// Shift Register

spi_shift_register #(
    .DATA_WIDTH(DATA_WIDTH))
    shift_register(

    .clk(clk),
    .rst(rst),
    .load(load),   //Controlled by Fsm
    .shift(shift), //Controlled by Fsm
    .data_in(data_in), //Comes from Cpu.
    .mosi(mosi), //Leaves chip
    .shift_reg(shift_reg)
);

// Bit Counter

spi_bit_counter counter(

    .clk(clk),
    .rst(rst),
    .enable(enable), //Fsm decides when counting starts.
    .bit_count(bit_count), 
    .done(done)  //Counter tells Fsm when counting is done.

);

// Fsm

spi_master_fsm controller(

    .clk(clk),
    .rst(rst),
    .start(start), //CPU requests transfer.
    .done(done), //All bits sent.
    .load(load),
    .shift(shift),
    .enable(enable),
    .busy(busy),
    .cs(cs)
);
endmodule