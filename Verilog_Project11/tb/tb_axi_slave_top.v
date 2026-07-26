`timescale 1ns/1ps

module tb_axi_slave_top;

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;

reg clk;
reg rst;
reg [ADDR_WIDTH-1:0] write_address;
reg [DATA_WIDTH-1:0] write_data;
reg write_enable;
reg [ADDR_WIDTH-1:0] read_address;

wire [DATA_WIDTH-1:0] read_data;

// DUT

axi_slave_top #

(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
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

initial
begin

    $dumpfile("waves/axi_slave_top.vcd");
    $dumpvars(0, tb_axi_slave_top);

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

    #20;
    write_address = 32'h00000000;
    write_data    = 32'h12345678;
    write_enable  = 1;
    #10;
    write_enable = 0;

    //Write REG1 

    #20;
    write_address = 32'h00000004;
    write_data    = 32'hABCDEF12;
    write_enable  = 1;
    #10;
    write_enable = 0;

    // Read REG0 

    #30;
    read_address = 32'h00000000;
    #20;

    // Read REG1 

    read_address = 32'h00000004;
    #30;
    $finish;

end
endmodule