`timescale 1ns/1ps

module tb_axi_slave_write_response;

reg clk;
reg rst;
reg write_complete;
reg bready;

wire [1:0] bresp;
wire bvalid;

// DUT

axi_slave_write_response uut(

    .clk(clk),
    .rst(rst),
    .write_complete(write_complete),
    .bready(bready),
    .bresp(bresp),
    .bvalid(bvalid)

);

// Clock

always #5 clk = ~clk;

// Test

initial
begin

    $dumpfile("waves/axi_slave_write_response.vcd");
    $dumpvars(0,tb_axi_slave_write_response);

    clk = 0;
    rst = 1;

    write_complete = 0;
    bready = 0;

    // Reset

    #20;
    rst = 0;

    // First Write Response

    #20;
    write_complete = 1;
    #10;
    write_complete = 0;
    #20;
    bready = 1;
    #10;
    bready = 0;

    // Second Transaction

    #30;
    write_complete = 1;
    #10;
    write_complete = 0;
    #20;
    bready = 1;
    #10;
    bready = 0;

    #40;

    $finish;

end
endmodule