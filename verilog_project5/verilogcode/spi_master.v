module spi_master(

    input clk,
    input rst,
    input start,
    input [7:0] data_in,

    output spi_clk,
    output mosi,
    output busy
);

wire load;
wire shift;
wire enable;
wire done;
wire [7:0] shift_reg;
wire [2:0] bit_count;

// Clock Generator

spi_clock_generator clock_gen(

    .clk(clk),  //System clock enters.
    .rst(rst),
    .spi_clk(spi_clk)  //Generated SPI clock leaves.

);
// Shift Register

spi_shift_register shift_register(

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
    .busy(busy)

);
endmodule