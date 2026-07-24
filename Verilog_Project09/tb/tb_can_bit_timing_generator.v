`timescale 1ns/1ps

module tb_can_bit_timing_generator;

reg clk;
reg rst;

wire can_clk;

can_bit_timing_generator #(
    .CLK_DIVIDER(4)
) uut (

    .clk(clk),
    .rst(rst),
    .can_clk(can_clk)

);

// System Clock (100 MHz -> 10 ns period)

always #5 clk = ~clk;

// Test Sequence

initial
begin

    $dumpfile("waves/can_bit_timing_generator.vcd");
    $dumpvars(0, tb_can_bit_timing_generator);

    clk = 0;
    rst = 1;
    #20;
    rst = 0;

    // Run long enough to observe several divided clock cycles.
    #200;

    $finish;

end
endmodule