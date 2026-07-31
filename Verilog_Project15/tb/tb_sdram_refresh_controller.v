`timescale 1ns/1ps

module tb_sdram_refresh_controller;

// Parameters
parameter REFRESH_PERIOD = 16;

// Inputs
reg clk;
reg rst;

// Outputs
wire refresh_request;

// DUT
sdram_refresh_controller #

(
.REFRESH_PERIOD(REFRESH_PERIOD)

)
uut

(

.clk(clk),
.rst(rst),

.refresh_request(refresh_request)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_refresh_controller.vcd");
    $dumpvars(0,tb_sdram_refresh_controller);

    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    
    #400;
    $finish;

end
endmodule