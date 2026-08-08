module i2c_address_comparator #(
    parameter ADDRESS_WIDTH = 7,
    parameter SLAVE_ADDRESS = 7'h42
)(
    input [ADDRESS_WIDTH-1:0] received_address,

    output match
);

assign match = (received_address == SLAVE_ADDRESS);

endmodule