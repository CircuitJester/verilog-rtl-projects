`timescale 1ns/1ps

module tb_axi_read_data;


parameter DATA_WIDTH = 32;

reg clk;
reg rst;
reg [DATA_WIDTH-1:0] rdata;
reg rvalid;

wire rready;
wire [DATA_WIDTH-1:0] data_out;
wire done;

axi_read_data #(
    .DATA_WIDTH(DATA_WIDTH)

) dut (
    .clk(clk),
    .rst(rst),
    .rdata(rdata),
    .rvalid(rvalid),
    .rready(rready),
    .data_out(data_out),
    .done(done)

);

always #5 clk = ~clk;

initial 

begin

    $dumpfile("waves/axi_read_data.vcd");
    $dumpvars(0, tb_axi_read_data);

    clk = 0;
    rst = 1;

    rdata  = 32'h00000000;
    rvalid = 0;

    #20;
    rst = 0;

    #30;
    rdata  = 32'h12345678;
    rvalid = 1;

    #10;
    rvalid = 0;

    #40;
    $finish;
end

endmodule