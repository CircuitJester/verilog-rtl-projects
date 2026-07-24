`timescale 1ns/1ps

module tb_can_bit_stuffing;

parameter FRAME_WIDTH = 31;

reg [FRAME_WIDTH-1:0] frame;

wire [FRAME_WIDTH+6:0] stuffed_frame;

can_bit_stuffing #

(
.FRAME_WIDTH(FRAME_WIDTH)

)
uut

(
.frame(frame),
.stuffed_frame(stuffed_frame)

);
initial
begin

    $dumpfile("waves/can_bit_stuffing.vcd");
    $dumpvars(0, tb_can_bit_stuffing);

    frame = 31'b1111101111100000111110000011111;
    #40;
    frame = 31'b1010101010101010101010101010101;
    #40;
    frame = 31'b0000011111000001111100000111110;
    #40;

    $finish;
end
endmodule