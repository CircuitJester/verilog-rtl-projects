`timescale 1ns/1ps

module tb_pipelined_alu_top;

// Parameters
parameter DATA_WIDTH = 32;

// Inputs
reg clk;
reg rst;

reg [2:0] opcode;
reg [DATA_WIDTH-1:0] operand_a;
reg [DATA_WIDTH-1:0] operand_b;

reg carry_out;
reg overflow;

// Outputs
wire [DATA_WIDTH-1:0] result;
wire zero;
wire carry;
wire negative;
wire overflow_flag;

// DUT
pipelined_alu_top
#(
    .DATA_WIDTH(DATA_WIDTH)
)
uut
(
    .clk(clk),
    .rst(rst),

    .opcode(opcode),
    .operand_a(operand_a),
    .operand_b(operand_b),

    .carry_out(carry_out),
    .overflow(overflow),
    .result(result),

    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow_flag(overflow_flag)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/pipelined_alu_top.vcd");
    $dumpvars(0,tb_pipelined_alu_top);

    clk = 0;
    rst = 1;

    opcode = 0;
    operand_a = 0;
    operand_b = 0;
    carry_out = 0;
    overflow = 0;

    // Reset
    #20;
    rst = 0;

    // ADD
    opcode = 3'b000;

    operand_a = 15;
    operand_b = 10;

    #20;

    // SUB
    opcode = 3'b001;
    #20;

    // AND
    opcode = 3'b010;

    operand_a = 32'hF0;
    operand_b = 32'hAA;

    #20;

    // OR
    opcode = 3'b011;
    #20;

    // XOR
    opcode = 3'b100;
    #20;

    // SHIFT LEFT
    opcode = 3'b101;
    operand_a = 8;
    #20;

    // SHIFT RIGHT
    opcode = 3'b110;

    #20;
    // COMPARE (Equal)
    opcode = 3'b111;

    operand_a = 25;
    operand_b = 25;

    #20;

    // COMPARE (Not Equal)
    operand_b = 30;

    #20;

    // Carry Test
    opcode = 3'b000;

    operand_a = 32'hFFFFFFFF;
    operand_b = 1;
    carry_out = 1;

    #20;

    // Overflow Test 
    overflow = 1;
    #20;

    $finish;

end

endmodule