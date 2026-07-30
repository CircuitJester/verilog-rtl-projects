module uart_transmitter #

(

parameter DATA_WIDTH = 8
)
(

input wire clk,
input wire rst,
input wire baud_tick,
input wire start,
input wire [DATA_WIDTH-1:0] tx_data,

output reg tx,
output reg busy,
output reg done
);

reg [DATA_WIDTH-1:0] shift_reg;
reg [3:0] bit_count;
reg transmitting;

always @(posedge clk or posedge rst)

begin

    if(rst)
    begin

        tx <= 1'b1;
        busy <= 0;
        done <= 0;
        transmitting <= 0;
        shift_reg <= 0;
        bit_count <= 0;

    end
    else

    begin

        done <= 0;

        // Start Transmission
        if(start && !transmitting)

        begin
            transmitting <= 1;
            busy <= 1;
            shift_reg <= tx_data;
            bit_count <= 0;

        end

        // Baud Tick
        else if(transmitting && baud_tick)

        begin

            case(bit_count)

            0:
            begin

                tx <= 0;
                bit_count <= 1;

            end

            1,2,3,4,5,6,7,8:
            begin
                tx <= shift_reg[0];
                shift_reg <= {1'b0,shift_reg[DATA_WIDTH-1:1]};
                bit_count <= bit_count + 1;

            end

            9:
            begin

                tx <= 1;
                bit_count <= 10;

            end

            10:
            begin

                transmitting <= 0;
                busy <= 0;
                done <= 1;
                tx <= 1;

            end
            endcase

        end

    end
end
endmodule