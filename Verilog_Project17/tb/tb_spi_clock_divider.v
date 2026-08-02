`timescale 1ns/1ps

module tb_spi_clock_divider;

// Inputs
reg clk;
reg rst;

// Output
wire spi_clk;

// DUT
spi_clock_divider
#(
    .DIVIDER(4)
)
uut
(
    .clk(clk),
    .rst(rst),
    .spi_clk(spi_clk)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/spi_clock_divider.vcd");
    $dumpvars(0, tb_spi_clock_divider);

    clk = 0;
    rst = 1;

    // Reset
    #20;
    rst = 0;

    // Run Divider
    #200;

    $finish;
end

endmodule