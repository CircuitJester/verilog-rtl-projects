module i2c_slave #

(
parameter DATA_WIDTH = 8,
parameter ADDRESS_WIDTH = 7,
parameter SLAVE_ADDRESS = 7'h42

)

(

input scl,
input rst,
input start_detected,
input stop_detected,
input sda,
input [ADDRESS_WIDTH-1:0] received_address,

output ack,
output busy,

output [DATA_WIDTH-1:0] rx_data

);

// Internal Wires

wire shift_enable;
wire ack_enable;
wire address_match;
wire byte_done;
wire [$clog2(DATA_WIDTH)-1:0] bit_count;

// Address Comparator

i2c_address_comparator #

(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .SLAVE_ADDRESS(SLAVE_ADDRESS)

)

address_comparator

(

.received_address(received_address),
.match(address_match)

);

// Shift Register

i2c_slave_shift_register #

(
.DATA_WIDTH(DATA_WIDTH)

)

shift_register

(

.scl(scl),
.rst(rst),
.load(shift_enable),
.sda(sda),
.rx_data(rx_data)

);

// ACK Generator

i2c_ack_generator
ack_generator

(

.scl(scl),
.rst(rst),
.ack_enable(ack_enable),
.address_match(address_match),
.ack(ack)

);

// Bit Counter

i2c_slave_bit_counter #

(

.DATA_WIDTH(DATA_WIDTH)

)

bit_counter

(

.scl(scl),
.rst(rst),
.enable(shift_enable),
.done(byte_done),
.bit_count(bit_count)

);

// FSM

i2c_slave_fsm
fsm

(

.scl(scl),
.rst(rst),
.start_detected(start_detected),
.address_match(address_match),
.byte_done(byte_done),
.stop_detected(stop_detected),
.shift_enable(shift_enable),
.ack_enable(ack_enable),
.busy(busy)

);

endmodule