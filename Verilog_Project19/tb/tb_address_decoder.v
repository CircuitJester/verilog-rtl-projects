`timescale 1ns/1ps

module tb_address_decoder;


// Inputs
reg [31:0] address;

// Outputs
wire [1:0] reg_select;
wire valid;

// DUT
address_decoder uut
(
    .address(address),
    .reg_select(reg_select),
    .valid(valid)
);

// Test Sequence
initial
begin

    $dumpfile("waves/address_decoder.vcd");
    $dumpvars(0, tb_address_decoder);

    // REG0
    address = 32'h00000000;
    #20;

    // REG1
    address = 32'h00000004;
    #20;

    // REG2
    address = 32'h00000008;
    #20;

    // REG3
    address = 32'h0000000C;
    #20;

    // Invalid Address
    address = 32'h00000020;
    #20;

    // Another Invalid Address
    address = 32'h12345678;

    #20;

    $finish;

end
endmodule