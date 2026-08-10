module spi_shift_register
#(
    parameter DATA_WIDTH = 8
)
(
    input  wire clk,
    input  wire rst,
    input  wire load,
    input  wire shift_enable,
    input  wire [DATA_WIDTH-1:0] tx_data,
    input  wire miso,

    output wire mosi,
    output reg [DATA_WIDTH-1:0] rx_data,
    output reg shift_done
);

reg [DATA_WIDTH-1:0] tx_shift;
reg [3:0] bit_count;


assign mosi = tx_shift[DATA_WIDTH-1];


always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        tx_shift   <= 0;
        rx_data    <= 0;
        bit_count  <= 0;
        shift_done <= 0;

    end

    else
    begin

        shift_done <= 0;

        if(load)
        begin
            tx_shift  <= tx_data;
            rx_data   <= 0;
            bit_count <= 0;

        end

        else if(shift_enable)
        begin

            tx_shift <= {tx_shift[DATA_WIDTH-2:0],1'b0};
            rx_data <= {rx_data[DATA_WIDTH-2:0],miso};
            bit_count <= bit_count + 1;

            if(bit_count == DATA_WIDTH-1)

                shift_done <= 1;

        end
    end

end
endmodule