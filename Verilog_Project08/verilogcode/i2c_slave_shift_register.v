module i2c_slave_shift_register #(
    parameter DATA_WIDTH = 8
)(
    input scl,
    input rst,
    input load,
    input sda,

    output reg [DATA_WIDTH-1:0] rx_data
);

always @(posedge scl or posedge rst)
begin

    if(rst)
    begin

        rx_data <= 0;

    end

    else if(load)
    begin

        rx_data <= {rx_data[DATA_WIDTH-2:0], sda};

    end
end
endmodule