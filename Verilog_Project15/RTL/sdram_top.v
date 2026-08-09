module sdram_top #

(
parameter WAIT_CYCLES = 8

)
(

input wire clk,
input wire rst,
input wire read_request,
input wire write_request,

output wire cs_n,
output wire ras_n,
output wire cas_n,
output wire we_n
);

// Internal Signals
wire delay_done;
wire start_delay;
wire init_done;
wire start_init;
wire refresh_request;
wire start_refresh;
wire activate;
wire read_cmd;
wire write_cmd;
wire read_done;
wire write_done;
wire start_read;
wire start_write;

// Timing Generator
sdram_timing_generator #

(
.WAIT_CYCLES(WAIT_CYCLES)

)
timing_generator

(
.clk(clk),
.rst(rst),
.start(start_delay),
.done(delay_done)

);

// Initialization FSM
sdram_init_fsm init_fsm
(

.clk(clk),
.rst(rst),
.delay_done(delay_done),
.start_delay(start_delay),
.precharge(),
.refresh(),
.load_mode(),
.init_done(init_done)
);

// Refresh Controller
sdram_refresh_controller refresh_controller
(

.clk(clk),
.rst(rst),

.refresh_request(refresh_request)
);

// Read Controller
sdram_read_controller read_controller

(
.clk(clk),
.rst(rst),
.read_request(start_read),
.delay_done(delay_done),
.start_delay(),
.activate(activate),
.read_cmd(read_cmd),
.read_done(read_done)

);

// Write Controller
sdram_write_controller write_controller

(
.clk(clk),
.rst(rst),
.write_request(start_write),
.delay_done(delay_done),
.start_delay(),
.activate(),
.write_cmd(write_cmd),
.write_done(write_done)
);

// Main FSM
sdram_main_fsm main_fsm

(
.clk(clk),
.rst(rst),
.init_done(init_done),
.refresh_request(refresh_request),
.read_request(read_request),
.write_request(write_request),
.read_done(read_done),
.write_done(write_done),
.start_init(),
.start_refresh(),
.start_read(start_read),
.start_write(start_write)
);

// Command Generator
sdram_command_generator command_generator

(
.activate(activate),
.read_cmd(read_cmd),
.write_cmd(write_cmd),
.precharge(1'b0),
.refresh(start_refresh),
.load_mode(1'b0),
.cs_n(cs_n),
.ras_n(ras_n),
.cas_n(cas_n),
.we_n(we_n)

);
endmodule