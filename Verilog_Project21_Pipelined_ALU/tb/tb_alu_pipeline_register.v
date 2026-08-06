`timescale 1ns/1ps

module tb_alu_pipeline_register;


// Parameters
parameter DATA_WIDTH = 32;

// Inputs
reg clk;
reg rst;

reg [DATA_WIDTH-1:0] result_in;
reg zero_in;
reg carry_in;
reg negative_in;
reg overflow_in;

// Outputs
wire [DATA_WIDTH-1:0] result_out;

wire zero_out;
wire carry_out;
wire negative_out;
wire overflow_out;

// DUT
alu_pipeline_register
#(
    .DATA_WIDTH(DATA_WIDTH)
)
uut
(
    .clk(clk),
    .rst(rst),

    .result_in(result_in),
    .zero_in(zero_in),
    .carry_in(carry_in),
    .negative_in(negative_in),
    .overflow_in(overflow_in),
    .result_out(result_out),
    .zero_out(zero_out),
    .carry_out(carry_out),
    .negative_out(negative_out),
    .overflow_out(overflow_out)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/alu_pipeline_register.vcd");
    $dumpvars(0, tb_alu_pipeline_register);

    clk = 0;

    rst = 1;

    result_in = 0;
    zero_in = 0;
    carry_in = 0;
    negative_in = 0;
    overflow_in = 0;

    // Apply Reset
    #20;
    rst = 0;

    // Test 1
    result_in = 32'd25;

    zero_in = 0;
    carry_in = 0;
    negative_in = 0;
    overflow_in = 0;

    #20;

    // Test 2
    result_in = 32'd0;

    zero_in = 1;
    carry_in = 0;
    negative_in = 0;
    overflow_in = 0;

    #20;

    // Test 3
    result_in = 32'h80000000;

    zero_in = 0;
    carry_in = 0;
    negative_in = 1;
    overflow_in = 0;

    #20;

    // Test 4
    result_in = 32'hFFFFFFFF;

    zero_in = 0;
    carry_in = 1;
    negative_in = 1;
    overflow_in = 1;

    #20;

    $finish;

end
endmodule