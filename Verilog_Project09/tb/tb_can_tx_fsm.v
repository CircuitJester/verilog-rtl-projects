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

can_tx_fsm dut (
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

    clk = 1'b0;
    rst = 1'b1;

    start = 1'b0;
    stuffing_done = 1'b0;
    crc_done = 1'b0;
    tx_done = 1'b0;
    ack_received = 1'b0;

    #20;
    rst = 1'b0;

    #10;
    start = 1'b1;

    #10;
    start = 1'b0;

    #20;
    stuffing_done = 1'b1;

    #10;
    stuffing_done = 1'b0;

    #20;
    crc_done = 1'b1;

    #10;
    crc_done = 1'b0;

    #20;
    tx_done = 1'b1;

    #10;
    tx_done = 1'b0;

    #20;
    ack_received = 1'b1;

    #10;
    ack_received = 1'b0;

    #40;
    $finish;
    
end

endmodule