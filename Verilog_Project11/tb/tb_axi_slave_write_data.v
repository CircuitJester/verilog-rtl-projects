`timescale 1ns/1ps

module tb_axi_slave_write_data;

parameter DATA_WIDTH = 32;

// Inputs

reg clk;
reg rst;
reg [DATA_WIDTH-1:0] wdata;
reg wvalid;

// Outputs

wire wready;
wire [DATA_WIDTH-1:0] data;
wire data_valid;

// DUT

axi_slave_write_data #

(
    .DATA_WIDTH(DATA_WIDTH)
)

uut

(
    .clk(clk),
    .rst(rst),
    .wdata(wdata),
    .wvalid(wvalid),
    .wready(wready),
    .data(data),
    .data_valid(data_valid)
);

// Clock
always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/axi_slave_write_data.vcd");
    $dumpvars(0,tb_axi_slave_write_data);

    clk = 0;
    rst = 1;

    wdata  = 32'h00000000;
    wvalid = 0;

    // Reset

    #20;
    rst = 0;

    // First Write

    #20;
    wdata  = 32'h12345678;
    wvalid = 1;
    #10;
    wvalid = 0;

    // Second Write

    #30;
    wdata  = 32'hABCDEF12;
    wvalid = 1;
    #10;
    wvalid = 0;

    #40;

    $finish;
end
endmodule