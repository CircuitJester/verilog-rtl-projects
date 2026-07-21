module spi_slave #(
    parameter DATA_WIDTH = 8
)(
    input spi_clk,
    input rst,
    input cs,
    input mosi,
    input [DATA_WIDTH-1:0] tx_data,

    output miso,
    output busy,
    output [DATA_WIDTH-1:0] rx_data
);

wire load;
wire done;
wire [$clog2(DATA_WIDTH)-1:0] bit_count;

spi_slave_controller controller(

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .done(done),
    .load(load),
    .busy(busy)

);

spi_slave_shift_register #(
    .DATA_WIDTH(DATA_WIDTH)
) shift_register(

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .load(load),
    .mosi(mosi),
    .tx_data(tx_data),
    .miso(miso),
    .rx_data(rx_data)

);

spi_slave_bit_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) counter(

    .spi_clk(spi_clk),
    .rst(rst),
    .cs(cs),
    .done(done),
    .bit_count(bit_count)

);
endmodule