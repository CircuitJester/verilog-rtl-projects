`timescale 1ns/1ps

module tb_i2c_slave;

parameter DATA_WIDTH = 8;
parameter ADDRESS_WIDTH = 7;
parameter SLAVE_ADDRESS = 7'h42;

reg scl;
reg rst;
reg start_detected;
reg stop_detected;
reg sda;

reg [ADDRESS_WIDTH-1:0] received_address;

wire ack;
wire busy;
wire [DATA_WIDTH-1:0] rx_data;

i2c_slave #(

    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .SLAVE_ADDRESS(SLAVE_ADDRESS)

) uut (

    .scl(scl),
    .rst(rst),
    .start_detected(start_detected),
    .stop_detected(stop_detected),
    .sda(sda),
    .received_address(received_address),
    .ack(ack),
    .busy(busy),
    .rx_data(rx_data)

);

// Clock

always #5 scl = ~scl;

// Test Sequence

initial
begin

    $dumpfile("waves/i2c_slave.vcd");
    $dumpvars(0, tb_i2c_slave);

    scl = 0;
    rst = 1;

    start_detected = 0;
    stop_detected = 0;
    sda = 0;
    received_address = 0;

    // Reset

    #20;
    rst = 0;

    // START

    #10;
    start_detected = 1;
    #10;
    start_detected = 0;

    // Address = 0x42

    received_address = 7'h42;

    // Send Data = B2

    sda = 1; #10;
    sda = 0; #10;
    sda = 1; #10;
    sda = 1; #10;
    sda = 0; #10;
    sda = 0; #10;
    sda = 1; #10;
    sda = 0; #10;

    // STOP

    stop_detected = 1;
    #10;
    stop_detected = 0;
    #40;
    $finish;

end
endmodule