`timescale 1ns/1ps

module tb_request_fifo;

// Inputs
reg clk;
reg rst;
reg write_en;
reg read_en;
reg [1:0] data_in;

// Outputs
wire [1:0] data_out;
wire full;
wire empty;

// DUT
request_fifo uut
(
    .clk(clk),
    .rst(rst),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/request_fifo.vcd");
    $dumpvars(0, tb_request_fifo);

    clk = 0;
    rst = 1;

    write_en = 0;
    read_en = 0;
    data_in = 2'b00;

    // Reset
    #20;
    rst = 0;

    // Write CPU (00)
    data_in = 2'b00;
    write_en = 1;
    #10;
    write_en = 0;

    // Write DMA (01)
    #10;
    data_in = 2'b01;
    write_en = 1;
    #10;
    write_en = 0;

    // Write ETH (10)
    #10;
    data_in = 2'b10;
    write_en = 1;
    #10;
    write_en = 0;

    // Write GPU (11)
    #10;
    data_in = 2'b11;
    write_en = 1;
    #10;
    write_en = 0;

    // Read All Entries
    repeat(4)
    begin

        #20;
        read_en = 1;
        #10;
        read_en = 0;

    end

    #50;
    $finish;

end
endmodule