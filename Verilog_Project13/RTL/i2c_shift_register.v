module i2c_shift_register #

(

parameter DATA_WIDTH = 8
)
(

input wire clk,
input wire rst,
input wire load,
input wire shift,
input wire [DATA_WIDTH-1:0] tx_data,
input wire sda_in,

output wire sda_out,
output reg [DATA_WIDTH-1:0] rx_data,
output reg done
);

// Registers
reg [DATA_WIDTH-1:0] tx_shift;
reg [DATA_WIDTH-1:0] rx_shift;
reg [3:0] bit_count;

// SDA Output
assign sda_out = tx_shift[DATA_WIDTH-1];

// Shift Logic
always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        tx_shift <= 0;
        rx_shift <= 0;

        rx_data <= 0;
        bit_count <= 0;
        done <= 0;

    end

    else

    begin

        done <= 0;

        // Load
        if(load)

        begin

            tx_shift <= tx_data;
            rx_shift <= 0;
            bit_count <= 0;
        end

        // Shift
        else if(shift)

        begin

            tx_shift <= {tx_shift[DATA_WIDTH-2:0],1'b0};
            rx_shift <= {rx_shift[DATA_WIDTH-2:0],sda_in};

            if(bit_count == DATA_WIDTH-1)

            begin

                rx_data <= {rx_shift[DATA_WIDTH-2:0],sda_in};
                done <= 1'b1;
                bit_count <= 0;
            end

            else

            begin

                bit_count <= bit_count + 1'b1;

            end

        end

    end
end
endmodule