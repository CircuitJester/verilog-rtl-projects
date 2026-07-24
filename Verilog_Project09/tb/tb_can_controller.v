`timescale 1ns/1ps

module tb_can_controller;

parameter ID_WIDTH    = 11;
parameter DATA_WIDTH  = 8;
parameter FRAME_WIDTH = 31;

// Inputs

reg clk;
reg rst;
reg start;
reg [ID_WIDTH-1:0] identifier;
reg [DATA_WIDTH-1:0] data;
reg stuffing_done;
reg crc_done;
reg tx_done;
reg frame_received;
reg crc_valid;
reg ack_received;

// Outputs

wire load_frame;
wire start_stuffing;
wire start_crc;
wire transmit;
wire busy;
wire ack;
wire [FRAME_WIDTH-1:0] frame;
wire [FRAME_WIDTH+6:0] stuffed_frame;
wire [7:0] crc;

// DUT

can_controller #(
.ID_WIDTH(ID_WIDTH),
.DATA_WIDTH(DATA_WIDTH),
.FRAME_WIDTH(FRAME_WIDTH)

)

uut(

.clk(clk),
.rst(rst),
.start(start),
.identifier(identifier),
.data(data),
.stuffing_done(stuffing_done),
.crc_done(crc_done),
.tx_done(tx_done),
.frame_received(frame_received),
.crc_valid(crc_valid),
.ack_received(ack_received),
.load_frame(load_frame),
.start_stuffing(start_stuffing),
.start_crc(start_crc),
.transmit(transmit),
.busy(busy),
.ack(ack),
.frame(frame),
.stuffed_frame(stuffed_frame),
.crc(crc)

);

// Clock

always #5 clk = ~clk;

// Stimulus

initial
begin

    $dumpfile("waves/can_controller.vcd");
    $dumpvars(0,tb_can_controller);

    // Initialization

    clk = 0;
    rst = 1;

    start = 0;
    identifier = 11'h123;
    data = 8'hB2;

    stuffing_done = 0;
    crc_done = 0;
    tx_done = 0;

    frame_received = 0;
    crc_valid = 0;
    ack_received = 0;

    #20;
    rst = 0;

    // Start Transmission

    #10;
    start = 1;
    #10;
    start = 0;

    // Stuffing Completed

    #30;
    stuffing_done = 1;
    #10;
    stuffing_done = 0;

    // CRC Completed

    #30;
    crc_done = 1;
    #10;
    crc_done = 0;

    // Transmission Completed

    #30;
    tx_done = 1;
    #10;
    tx_done = 0;

    // Receiver received frame correctly

    #20;
    frame_received = 1;
    crc_valid = 1;

    // ACK

    #20;
    ack_received = 1;
    #10;
    ack_received = 0;

    #40;
    $finish;

end
endmodule