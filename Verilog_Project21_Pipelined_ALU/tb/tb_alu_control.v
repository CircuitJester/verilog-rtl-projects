`timescale 1ns/1ps

module tb_alu_control;


// Inputs
reg [2:0] opcode;

// Outputs
wire [3:0] alu_control;

// DUT
alu_control uut
(
    .opcode(opcode),
    .alu_control(alu_control)
);

// Test Sequence
initial
begin

    $dumpfile("waves/alu_control.vcd");
    $dumpvars(0, tb_alu_control);

    // ADD
    opcode = 3'b000;
    #20;

    // SUB
    opcode = 3'b001;
    #20;

    // AND
    opcode = 3'b010;
    #20;

    // OR
    opcode = 3'b011;
    #20;

    // XOR
    opcode = 3'b100;
    #20;

    // SHIFT LEFT
    opcode = 3'b101;
    #20;

    // SHIFT RIGHT
    opcode = 3'b110;
    #20;

    // COMPARE
    opcode = 3'b111;
    #20;

    $finish;

end
endmodule