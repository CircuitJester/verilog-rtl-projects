`timescale 1ns/1ps

module tb_uart_baud_generator;

parameter DIVIDER = 4;

// Inputs
reg clk;
reg rst;

// Outputs
wire baud_tick;

// DUT
uart_baud_generator #

(
    .DIVIDER(DIVIDER)
)
uut

(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/uart_baud_generator.vcd");
    $dumpvars(0,tb_uart_baud_generator);

    clk = 0;
    rst = 1;

    // Reset
    #20;
    rst = 0;

    
    #200;
    $finish;

end
endmodule