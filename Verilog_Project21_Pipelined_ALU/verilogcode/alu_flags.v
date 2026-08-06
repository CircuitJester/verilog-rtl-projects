module alu_flags
#
(
    parameter DATA_WIDTH = 32
)
(
    input wire [DATA_WIDTH-1:0] result,
    input wire carry_out,
    input wire overflow,

    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow_flag
);

// Zero Flag
assign zero = (result == 0);

// Carry Flag
assign carry = carry_out;

// Negative Flag
assign negative = result[DATA_WIDTH-1];

// Overflow Flag
assign overflow_flag = overflow;

endmodule