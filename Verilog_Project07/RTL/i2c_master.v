module i2c_master #(
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input start,
    input [DATA_WIDTH-1:0] data_in,
    input sda_in,
    input [15:0] clk_divider,

    output scl,
    output sda,
    output busy
);

wire start_condition;
wire stop_condition;
wire load;
wire shift;
wire ack_enable;
wire done;
wire ack_received;
wire [DATA_WIDTH-1:0] shift_reg;
wire [$clog2(DATA_WIDTH)-1:0] bit_count;

// Clock Generator

i2c_clock_generator clock_gen(

    .clk(clk),
    .rst(rst),
    .clk_divider(clk_divider),
    .scl(scl)

);

// Start Stop Generator

i2c_start_stop_generator start_stop(

    .clk(clk),
    .rst(rst),
    .start(start_condition),
    .stop(stop_condition),
    .sda(),
    .busy()

);

// Shift Register

i2c_shift_register #(
    .DATA_WIDTH(DATA_WIDTH)
) shift_register(

    .scl(scl),
    .rst(rst),
    .load(load),
    .shift(shift),
    .data_in(data_in),
    .sda(sda),
    .shift_reg(shift_reg)

);


// Bit Counter

i2c_bit_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) counter(

    .scl(scl),
    .rst(rst),
    .enable(shift),
    .done(done),
    .bit_count(bit_count)

);

// ACK Detector

i2c_ack_detector ack(

    .scl(scl),
    .rst(rst),
    .ack_enable(ack_enable),
    .sda(sda_in),
    .ack_received(ack_received)

);

// FSM

i2c_master_fsm fsm(

    .scl(scl),
    .rst(rst),
    .start(start),
    .done(done),
    .ack_received(ack_received),
    .start_condition(start_condition),
    .stop_condition(stop_condition),
    .load(load),
    .shift(shift),
    .ack_enable(ack_enable),
    .busy(busy)

);
endmodule