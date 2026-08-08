module can_controller #

(
parameter ID_WIDTH = 11,
parameter DATA_WIDTH = 8,
parameter FRAME_WIDTH = 31

)
(

input wire clk,
input wire rst,
input wire start,
input wire [ID_WIDTH-1:0] identifier,
input wire [DATA_WIDTH-1:0] data,
input wire stuffing_done,
input wire crc_done,
input wire tx_done,
input wire frame_received,
input wire crc_valid,
input wire ack_received,

output wire load_frame,
output wire start_stuffing,
output wire start_crc,
output wire transmit,
output wire busy,
output wire ack,
output wire [FRAME_WIDTH-1:0] frame,
output wire [FRAME_WIDTH+6:0] stuffed_frame,
output wire [7:0] crc

);

// Frame Generator


can_frame_generator #

(
.ID_WIDTH(ID_WIDTH),
.DATA_WIDTH(DATA_WIDTH)

)
frame_gen

(

.load(load_frame),
.identifier(identifier),
.data(data),
.frame(frame)

);

// Bit Stuffing

can_bit_stuffing #

(
.FRAME_WIDTH(FRAME_WIDTH)

)
stuff_unit

(
.frame(frame),
.stuffed_frame(stuffed_frame)

);

// CRC Generator

can_crc_generator #

(
.FRAME_WIDTH(FRAME_WIDTH)

)
crc_unit

(
.frame(frame),
.crc(crc)

);

// ACK Generator

can_ack_generator ack_unit(

.crc_valid(crc_valid),
.frame_received(frame_received),
.ack(ack)

);

// Fsm

can_tx_fsm fsm(

.clk(clk),
.rst(rst),
.start(start),
.stuffing_done(stuffing_done),
.crc_done(crc_done),
.tx_done(tx_done),
.ack_received(ack_received),
.load_frame(load_frame),
.start_stuffing(start_stuffing),
.start_crc(start_crc),
.transmit(transmit),
.busy(busy)

);
endmodule