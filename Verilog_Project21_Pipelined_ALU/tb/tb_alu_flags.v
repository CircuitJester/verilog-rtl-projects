`timescale 1ns/1ps

module tb_alu_flags;

// Parameters
parameter DATA_WIDTH = 32;

// Inputs
reg [DATA_WIDTH-1:0] result;
reg carry_out;
reg overflow;

// Outputs
wire zero;
wire carry;
wire negative;
wire overflow_flag;

// DUT
alu_flags
#(
    .DATA_WIDTH(DATA_WIDTH)
)
uut
(
    .result(result),
    .carry_out(carry_out),
    .overflow(overflow),
    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow_flag(overflow_flag)
);

// Test
initial
begin

    $dumpfile("waves/alu_flags.vcd");
    $dumpvars(0,tb_alu_flags);

    // Normal Positive Number
    result = 32'd25;
    carry_out = 0;
    overflow = 0;

    #20;

    // Zero Result
    result = 32'd0;
    #20;


    // Negative Number
    result = 32'h80000000;
    #20;

    // Carry Flag
    result = 32'hFFFFFFFF;
    carry_out = 1;

    #20;

    // Overflow Flag
    carry_out = 0;
    overflow = 1;

    #20;

    // Multiple Flags
    result = 32'd0;
    carry_out = 1;
    overflow = 1;

    #20;

    $finish;

end

endmodule