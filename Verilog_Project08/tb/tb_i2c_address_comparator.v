`timescale 1ns/1ps

module tb_i2c_address_comparator;

parameter ADDRESS_WIDTH = 7;
parameter SLAVE_ADDRESS = 7'h42;

reg [ADDRESS_WIDTH-1:0] received_address;

wire match;

i2c_address_comparator #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .SLAVE_ADDRESS(SLAVE_ADDRESS)
) uut (

    .received_address(received_address),
    .match(match)

);
initial
begin

    $dumpfile("waves/i2c_address_comparator.vcd");
    $dumpvars(0, tb_i2c_address_comparator);

    received_address = 7'h42;
    #20;
    received_address = 7'h50;
    #20;
    received_address = 7'h68;
    #20;
    received_address = 7'h42;
    #20;

    $finish;

end
endmodule