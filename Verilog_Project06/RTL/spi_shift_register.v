module spi_shift_register # (
    parameter DATA_WIDTH = 8
) (
    input clk,
    input rst,
    input load,
    input shift,
    input [DATA_WIDTH-1:0] data_in,
    input miso,

    output reg [DATA_WIDTH-1:0] rx_data,
    output mosi,
    output reg [DATA_WIDTH-1:0] shift_reg

);

assign mosi = shift_reg[7];

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        shift_reg <= 8'd0;
        rx_data <= 0;
    end

    else if(load)
    begin
        shift_reg <= data_in;
        rx_data <= 0;
    end

    else if(shift)
    begin
        shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
        rx_data <= {rx_data[DATA_WIDTH-2:0], miso};
    end

end
endmodule