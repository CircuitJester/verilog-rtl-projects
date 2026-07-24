`timescale 1ns/1ps

module tb_can_tx_fsm;

reg clk;
reg rst;
reg start;
reg stuffing_done;
reg crc_done;
reg tx_done;
reg ack_received;

wire load_frame;
wire start_stuffing;
wire start_crc;
wire transmit;
wire busy;

can_tx_fsm uut(

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

always #5 clk = ~clk;

initial
begin

    $dumpfile("waves/can_tx_fsm.vcd");
    $dumpvars(0, tb_can_tx_fsm);

    clk = 0;
    rst = 1;

    start = 0;
    stuffing_done = 0;
    crc_done = 0;
    tx_done = 0;
    ack_received = 0;

    #20 rst = 0;

    // Start transmission
    #10 start = 1;
    #10 start = 0;

    // Frame stuffing complete
    #20 stuffing_done = 1;
    #10 stuffing_done = 0;

    // CRC complete
    #20 crc_done = 1;
    #10 crc_done = 0;

    // Transmission complete
    #20 tx_done = 1;
    #10 tx_done = 0;

    // ACK received
    #20 ack_received = 1;
    #10 ack_received = 0;
    #40;
    $finish;

end
endmodule