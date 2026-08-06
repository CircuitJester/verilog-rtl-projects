`timescale 1ns/1ps

module tb_alu_execute;


// Parameters
parameter DATA_WIDTH = 32;

// Inputs
reg [DATA_WIDTH-1:0] operand_a;
reg [DATA_WIDTH-1:0] operand_b;
reg [3:0] alu_control;

// Outputs
wire [DATA_WIDTH-1:0] result;

// DUT
alu_execute
#(
    .DATA_WIDTH(DATA_WIDTH)
)
uut
(
    .operand_a(operand_a),
    .operand_b(operand_b),
    .alu_control(alu_control),
    .result(result)
);

// Test Sequence
initial
begin

    $dumpfile("waves/alu_execute.vcd");
    $dumpvars(0,tb_alu_execute);

    // ADD
    operand_a = 32'd15;
    operand_b = 32'd10;
    alu_control = 4'b0000;
    #20;

    // SUB
    alu_control = 4'b0001;
    #20;

    // AND
    operand_a = 32'hF0;
    operand_b = 32'hAA;
    alu_control = 4'b0010;
    #20;

    // OR
    alu_control = 4'b0011;
    #20;

    // XOR
    alu_control = 4'b0100;
    #20;

    // SHIFT LEFT
    operand_a = 32'd8;
    alu_control = 4'b0101;
    #20;

    // SHIFT RIGHT
    alu_control = 4'b0110;
    #20;

    //----------------------------------
    // COMPARE (Equal)
    operand_a = 32'd25;
    operand_b = 32'd25;
    alu_control = 4'b0111;

    #20;

    // COMPARE (Not Equal)
    operand_b = 32'd30;

    #20;

    $finish;

end
endmodule