module spi_master_top #

(

parameter DATA_WIDTH = 8,
parameter CLOCK_DIVIDER = 4

)
(

input wire clk,
input wire rst,
input wire start,
input wire [DATA_WIDTH-1:0] tx_data,
input wire miso,

output wire mosi,
output wire spi_clk,
output wire cs_n,
output wire [DATA_WIDTH-1:0] rx_data,
output wire busy

);

// Internal Wires
wire load;
wire shift_enable;
wire transfer_done;
wire cs_start;
wire shift_done;

// SPI Clock Generator
spi_clock_generator #

(

.DIVIDER(CLOCK_DIVIDER)
)

clock_gen

(

.clk(clk),
.rst(rst),

.spi_clk(spi_clk)
);

// Shift Register
spi_shift_register #

(
.DATA_WIDTH(DATA_WIDTH)

)

shift_reg
(

.clk(spi_clk),
.rst(rst),

.load(load),
.shift(shift_enable),
.tx_data(tx_data),
.miso(miso),
.mosi(mosi),
.rx_data(rx_data),
.done(shift_done)
);

// Chip Select
spi_chip_select
chip_select

(

.clk(clk),
.rst(rst),

.start(cs_start),
.transfer_done(transfer_done),
.cs_n(cs_n),
.busy()
);

// FSM
spi_master_fsm

fsm

(

.clk(clk),
.rst(rst),

.start(start),
.shift_done(shift_done),
.load(load),
.cs_start(cs_start),
.shift_enable(shift_enable),
.transfer_done(transfer_done),
.busy(busy)

);
endmodule