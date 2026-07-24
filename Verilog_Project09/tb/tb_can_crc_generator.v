`timescale 1ns/1ps

module tb_can_crc_generator;

parameter FRAME_WIDTH = 31;

reg [FRAME_WIDTH-1:0] frame;

wire [7:0] crc;

can_crc_generator #(

.FRAME_WIDTH(FRAME_WIDTH)

)

uut(
.frame(frame),
.crc(crc)

);

initial
begin

    $dumpfile("waves/can_crc_generator.vcd");
    $dumpvars(0, tb_can_crc_generator);

    frame = 31'h0918D97F;
    #20;
    frame = 31'h55555555;
    #20;
    frame = 31'h03E0F83E;
    #20;
    frame = 31'h7DF07C1F;
    #20;

    $finish;
end
endmodule