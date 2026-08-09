module i2c_master_top #

(
parameter DATA_WIDTH = 8,
parameter CLOCK_DIVIDER = 4

)
(
input wire clk,
input wire rst,
input wire start,
input wire [DATA_WIDTH-1:0] tx_data,
input wire sda_in,

output wire scl,
output wire sda_out,
output wire busy,
output wire done,
output wire ack_error,
output wire [DATA_WIDTH-1:0] rx_data

);

// Internal Signals
wire start_cmd;
wire stop_cmd;
wire load;
wire shift;
wire check_ack;
wire shift_done;
wire ack;
wire start_busy;

// Clock Generator
i2c_clock_generator #

(
.DIVIDER(CLOCK_DIVIDER)

)
clock_inst

(
.clk(clk),
.rst(rst),

.scl(scl)
);

// Start / Stop Generator
wire sda_startstop;
i2c_start_stop

startstop_inst

(
.clk(clk),
.rst(rst),

.start_cmd(start_cmd),
.stop_cmd(stop_cmd),
.scl(scl),
.sda(sda_startstop),
.busy(start_busy)
);

// Shift Register
wire sda_shift;

i2c_shift_register #

(
.DATA_WIDTH(DATA_WIDTH)

)
shift_inst

(
.clk(clk),
.rst(rst),

.load(load),
.shift(shift),
.tx_data(tx_data),
.sda_in(sda_in),
.sda_out(sda_shift),
.rx_data(rx_data),
.done(shift_done)
);

// ACK Detector
i2c_ack_detector
ack_inst

(
.clk(clk),
.rst(rst),
.check_ack(check_ack),
.sda(sda_in),
.ack(ack),
.error(ack_error)
);

// FSM
i2c_master_fsm
fsm_inst

(

.clk(clk),
.rst(rst),

.start(start),
.shift_done(shift_done),
.ack(ack),
.error(ack_error),
.start_cmd(start_cmd),
.load(load),
.shift(shift),
.check_ack(check_ack),
.stop_cmd(stop_cmd),
.busy(busy),
.done(done)
);

// SDA Multiplexer
assign sda_out =
        (start_cmd || stop_cmd) ? sda_startstop :
                                  sda_shift;

endmodule