`timescale 1ns/1ps

module tb_sdram_top;


// Inputs
reg clk;
reg rst;
reg read_request;
reg write_request;

// Outputs
wire cs_n;
wire ras_n;
wire cas_n;
wire we_n;

// DUT
sdram_top uut
(
.clk(clk),
.rst(rst),
.read_request(read_request),
.write_request(write_request),
.cs_n(cs_n),
.ras_n(ras_n),
.cas_n(cas_n),
.we_n(we_n)

);

always #5 clk = ~clk;

initial

begin

    $dumpfile("waves/sdram_top.vcd");
    $dumpvars(0,tb_sdram_top);

    clk = 0;
    rst = 1;

    read_request = 0;
    write_request = 0;

    #20;
    rst = 0;

    // Read Transaction
    #100;
    read_request = 1;
    #10;
    read_request = 0;

    // Write Transaction
    #150;
    write_request = 1;
    #10;
    write_request = 0;

    #300;
    $finish;

end
endmodule