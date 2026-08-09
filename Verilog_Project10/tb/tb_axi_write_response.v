`timescale 1ns/1ps

module tb_axi_write_response;

reg clk;
reg rst;
reg [1:0] bresp;
reg bvalid;

wire bready;
wire done;
wire error;

axi_write_response dut (
    .clk(clk),
    .rst(rst),
    .bresp(bresp),
    .bvalid(bvalid),
    .bready(bready),
    .done(done),
    .error(error)
    
);

always #5 clk = ~clk;

initial 

begin

    $dumpfile("waves/axi_write_response.vcd");
    $dumpvars(0, tb_axi_write_response);

    clk = 0;
    rst = 1;

    bresp = 2'b00;
    bvalid = 0;

    #20;
    rst = 0;

    #20;
    bresp = 2'b00;
    bvalid = 1;

    #10;
    bvalid = 0;

    #30;
    bresp = 2'b10;
    bvalid = 1;

    #10;
    bvalid = 0;

    #40;
    $finish;

end

endmodule