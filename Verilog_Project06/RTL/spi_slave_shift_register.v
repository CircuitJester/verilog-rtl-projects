module spi_slave_shift_register #(
    parameter DATA_WIDTH = 8
)(
    input spi_clk,
    input rst,
    input cs,
    input load,
    input mosi,
    input  [DATA_WIDTH-1:0] tx_data,

    output miso,
    output reg [DATA_WIDTH-1:0] rx_data
);

reg [DATA_WIDTH-1:0] tx_shift_reg;

assign miso = tx_shift_reg[DATA_WIDTH-1];

always @(posedge spi_clk or posedge rst)
begin
    if (rst)
    begin
        tx_shift_reg <= 0;
        rx_data      <= 0;
    end

    else if (load)
    begin
        tx_shift_reg <= tx_data;
        rx_data      <= 0;
    end

    else if (!cs)
    begin
        // Shift incoming MOSI data
        rx_data <= {rx_data[DATA_WIDTH-2:0], mosi};

        // Shift outgoing MISO data
        tx_shift_reg <= {tx_shift_reg[DATA_WIDTH-2:0], 1'b0};
    end
end
endmodule