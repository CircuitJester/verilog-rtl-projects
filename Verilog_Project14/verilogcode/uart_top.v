module uart_top #

(
parameter CLOCK_DIVIDER = 4,
parameter DATA_WIDTH = 8
)
(
input wire clk,
input wire rst,

// TX Interface
input wire tx_start,
input wire [DATA_WIDTH-1:0] tx_data,

output wire tx_busy,
output wire tx_done,
output wire tx,

// RX Interface
input wire rx,

output wire [DATA_WIDTH-1:0] rx_data,
output wire rx_busy,
output wire rx_done
);

// Internal Signals
wire baud_tick;

// TX FSM Signals
wire load;
wire start_bit;
wire shift_enable;
wire stop_bit;

// RX FSM Signals
wire sample_enable;

// Baud Generator
uart_baud_generator #

(
.DIVIDER(CLOCK_DIVIDER)

)
baud_gen

(

.clk(clk),
.rst(rst),

.baud_tick(baud_tick)
);

// UART Transmitter
uart_transmitter #

(
.DATA_WIDTH(DATA_WIDTH)

)
tx_unit

(
.clk(clk),
.rst(rst),

.baud_tick(baud_tick),
.start(tx_start),
.tx_data(tx_data),
.tx(tx),
.busy(tx_busy),
.done(tx_done)
);

// UART Receiver
uart_receiver #

(
.DATA_WIDTH(DATA_WIDTH)

)
rx_unit
(
.clk(clk),
.rst(rst),

.baud_tick(baud_tick),
.rx(rx),
.rx_data(rx_data),
.busy(rx_busy),
.done(rx_done)
);

// TX FSM
uart_tx_fsm
tx_fsm

(
.clk(clk),
.rst(rst),

.start(tx_start),
.baud_tick(baud_tick),
.shift_done(tx_done),
.load(load),
.start_bit(start_bit),
.shift_enable(shift_enable),
.stop_bit(stop_bit),
.busy(),
.done()
);

// RX FSM
uart_rx_fsm
rx_fsm

(
.clk(clk),
.rst(rst),

.rx(rx),
.baud_tick(baud_tick),
.receive_done(rx_done),
.sample_enable(sample_enable),
.busy(),
.done()

);
endmodule