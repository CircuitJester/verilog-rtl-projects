`timescale 1ns/1ps

module tb_axi_slave_controller;

// Inputs

reg clk;
reg rst;
reg start_write;
reg start_read;
reg write_complete;
reg response_done;
reg read_complete;

// Outputs

wire write_enable;
wire read_enable;
wire send_response;
wire busy;

// DUT

axi_slave_controller uut(

    .clk(clk),
    .rst(rst),

    .start_write(start_write),
    .start_read(start_read),
    .write_complete(write_complete),
    .response_done(response_done),
    .read_complete(read_complete),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .send_response(send_response),
    .busy(busy)

);

// Clock
always #5 clk = ~clk;

// Stimulus

initial
begin

    $dumpfile("waves/axi_slave_controller.vcd");
    $dumpvars(0,tb_axi_slave_controller);

    clk = 0;
    rst = 1;

    start_write = 0;
    start_read = 0;
    write_complete = 0;
    response_done = 0;
    read_complete = 0;

    // Reset

    #20;
    rst = 0;

    // WRITE TRANSACTION

    #20;
    start_write = 1;
    #10;
    start_write = 0;

    #20;
    write_complete = 1;
    #10;
    write_complete = 0;

    #20;
    response_done = 1;
    #10;
    response_done = 0;

    // READ TRANSACTION

    #40;
    start_read = 1;
    #10;
    start_read = 0;


    #20;
    read_complete = 1;
    #10;
    read_complete = 0;

    #50;

    $finish;

end
endmodule