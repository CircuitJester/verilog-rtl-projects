`timescale 1ns/1ps

module tb_axi_register_file;

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;

// Inputs

reg clk;
reg rst;
reg [ADDR_WIDTH-1:0] write_address;
reg [DATA_WIDTH-1:0] write_data;
reg write_enable;
reg [ADDR_WIDTH-1:0] read_address;

// Outputs

wire [DATA_WIDTH-1:0] read_data;

// DUT

axi_register_file #

(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)

uut
(
    .clk(clk),
    .rst(rst),
    .write_address(write_address),
    .write_data(write_data),
    .write_enable(write_enable),
    .read_address(read_address),
    .read_data(read_data)
);

always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/axi_register_file.vcd");
    $dumpvars(0, tb_axi_register_file);

    clk = 0;
    rst = 1;

    write_address = 0;
    write_data = 0;
    write_enable = 0;
    read_address = 0;

    // Reset

    #20;
    rst = 0;

    // Write REG0

    #10;
    write_address = 32'h00000000;
    write_data    = 32'h11111111;
    write_enable  = 1;
    #10;
    write_enable = 0;

    // Write REG1

    #20;
    write_address = 32'h00000004;
    write_data    = 32'h22222222;
    write_enable  = 1;
    #10;
    write_enable = 0;

    // Write REG2

    #20;
    write_address = 32'h00000008;
    write_data    = 32'h33333333;
    write_enable  = 1;
    #10;
    write_enable = 0;

    // Write REG3

    #20;
    write_address = 32'h0000000C;
    write_data    = 32'h44444444;
    write_enable  = 1;
    #10;
    write_enable = 0;

    // Read REG0

    #20;
    read_address = 32'h00000000;
    #20;

    // Read REG1

    read_address = 32'h00000004;
    #20;

    // Read REG2

    read_address = 32'h00000008;
    #20;

    // Read REG3

    read_address = 32'h0000000C;
    #20;

    $finish;
end
endmodule