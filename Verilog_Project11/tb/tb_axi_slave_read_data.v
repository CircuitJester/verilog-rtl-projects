`timescale 1ns/1ps

module tb_axi_slave_read_data;

parameter DATA_WIDTH = 32;

// Inputs

reg clk;
reg rst;
reg [DATA_WIDTH-1:0] register_data;
reg data_available;
reg rready;

// Outputs

wire [DATA_WIDTH-1:0] rdata;
wire rvalid;

// DUT

axi_slave_read_data #

(
    .DATA_WIDTH(DATA_WIDTH)
)

uut
(
    .clk(clk),
    .rst(rst),
    .register_data(register_data),
    .data_available(data_available),
    .rready(rready),
    .rdata(rdata),
    .rvalid(rvalid)
);

// Clock

always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/axi_slave_read_data.vcd");
    $dumpvars(0, tb_axi_slave_read_data);

    clk = 0;
    rst = 1;

    register_data = 32'h00000000;
    data_available = 0;
    rready = 0;

    // Reset

    #20;
    rst = 0;

    // First Read

    #20;
    register_data = 32'h12345678;
    data_available = 1;
    #10;
    data_available = 0;
    #20;
    rready = 1;
    #10;
    rready = 0;

    // Second Read

    #30;
    register_data = 32'hABCDEF12;
    data_available = 1;
    #10;
    data_available = 0;
    #20;
    rready = 1;
    #10;
    rready = 0;

    #40;

    $finish;
end
endmodule