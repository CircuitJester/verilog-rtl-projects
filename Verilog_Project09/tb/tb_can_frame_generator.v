`timescale 1ns/1ps

module tb_can_frame_generator;

parameter ID_WIDTH = 11;
parameter DATA_WIDTH = 8;

reg load;
reg [ID_WIDTH-1:0] identifier;
reg [DATA_WIDTH-1:0] data;

wire [30:0] frame;

can_frame_generator #

(
.ID_WIDTH(ID_WIDTH),
.DATA_WIDTH(DATA_WIDTH)

)
uut

(
.load(load),
.identifier(identifier),
.data(data),
.frame(frame)
);

initial
begin

    $dumpfile("waves/can_frame_generator.vcd");
    $dumpvars(0, tb_can_frame_generator);

    load = 0;
    identifier = 11'h123;

    data = 8'hB2;
    #20;
    load = 1;
    #40;
    load = 0;
    #20;

    $finish;

end
endmodule