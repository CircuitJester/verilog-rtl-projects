module spi_master_top
#(
    parameter DATA_WIDTH = 8,
    parameter DIVIDER = 4
)
(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [DATA_WIDTH-1:0] tx_data,
    input wire miso,

    output wire spi_clk,
    output wire mosi,
    output wire cs_n,
    output wire [DATA_WIDTH-1:0] rx_data,
    output wire done
);

// Internal Signals
wire load;
wire shift_enable;
wire shift_done;
wire cs_enable;

// Clock Divider
spi_clock_divider
#(
    .DIVIDER(DIVIDER)
)
clock_divider
(
    .clk(clk),
    .rst(rst),
    .spi_clk(spi_clk)
);

// Shift Register
spi_shift_register
#(
    .DATA_WIDTH(DATA_WIDTH)
)
shift_register
(
    .clk(spi_clk),
    .rst(rst),
    .load(load),
    .shift_enable(shift_enable),
    .tx_data(tx_data),
    .miso(miso),
    .mosi(mosi),
    .rx_data(rx_data),
    .shift_done(shift_done)
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
    .shift_enable(shift_enable),
    .cs_enable(cs_enable),
    .done(done)
);

// Chip Select
spi_chip_select
chip_select
(
    .clk(clk),
    .rst(rst),
    .cs_enable(cs_enable),
    .cs_n(cs_n)
);
endmodule