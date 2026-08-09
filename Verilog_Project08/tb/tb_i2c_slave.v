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
    
) dut (
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

always #5 scl = ~scl;

initial 

begin

    $dumpfile("waves/i2c_slave.vcd");
    $dumpvars(0, tb_i2c_slave);

    scl = 1'b0;
    rst = 1'b1;
    start_detected = 1'b0;
    stop_detected = 1'b0;
    sda = 1'b0;
    received_address = 0;

    #20;
    rst = 1'b0;

    #10;
    start_detected = 1'b1;

    #10;
    start_detected = 1'b0;

    received_address = 7'h42;

    sda = 1'b1; #10;
    sda = 1'b0; #10;
    sda = 1'b1; #10;
    sda = 1'b1; #10;
    sda = 1'b0; #10;
    sda = 1'b0; #10;
    sda = 1'b1; #10;
    sda = 1'b0; #10;

    stop_detected = 1'b1;

    #10;
    stop_detected = 1'b0;

    #40;
    $finish;
end

endmodule