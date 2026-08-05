`timescale 1ns/1ps

module tb_dma_transfer_counter;

// Inputs
reg clk;
reg rst;

reg load;
reg decrement;
reg [15:0] transfer_length;

// Outputs
wire [15:0] count;
wire transfer_done;

// DUT
dma_transfer_counter uut
(
    .clk(clk),
    .rst(rst),

    .load(load),
    .decrement(decrement),
    .transfer_length(transfer_length),
    .count(count),
    .transfer_done(transfer_done)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/dma_transfer_counter.vcd");
    $dumpvars(0, tb_dma_transfer_counter);

    clk = 0;
    rst = 1;

    load = 0;
    decrement = 0;
    transfer_length = 0;

    // Reset
    #20;
    rst = 0;

    // Load Transfer Length
    #20;
    transfer_length = 16'd5;

    load = 1;
    #10;
    load = 0;

    // Transfer 1
    #20;
    decrement = 1;
    #10;
    decrement = 0;

    // Transfer 2
    #20;
    decrement = 1;
    #10;
    decrement = 0;

    // Transfer 3
    #20;
    decrement = 1;
    #10;
    decrement = 0;

    // Transfer 4
    #20;
    decrement = 1;
    #10;
    decrement = 0;

    // Transfer 5
    #20;
    decrement = 1;
    #10;
    decrement = 0;

    // Extra Decrement (Have No Effect)
    #20;
    decrement = 1;
    #10;
    decrement = 0;

    #30;

    $finish;

end
endmodule