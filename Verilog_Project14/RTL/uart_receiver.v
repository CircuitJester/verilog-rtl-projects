module uart_receiver #

(

parameter DATA_WIDTH = 8
)
(
input wire clk,
input wire rst,
input wire baud_tick,
input wire rx,

output reg [DATA_WIDTH-1:0] rx_data,
output reg busy,
output reg done

);

reg [DATA_WIDTH-1:0] shift_reg;
reg [3:0] bit_count;
reg receiving;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin
        rx_data <= 0;
        shift_reg <= 0;
        bit_count <= 0;
        receiving <= 0;
        busy <= 0;
        done <= 0;

    end
    else

    begin

        done <= 0;

        // Detect Start Bit
        if(!receiving && rx == 0)

        begin
            receiving <= 1;
            busy <= 1;
            bit_count <= 0;

        end

        // Sample Incoming Bits
        else if(receiving && baud_tick)

        begin

            case(bit_count)

            0:
            begin

                // Ignore Start Bit
                bit_count <= 1;
            end

            1,2,3,4,5,6,7,8:
            begin
                shift_reg <= {rx,shift_reg[DATA_WIDTH-1:1]};
                bit_count <= bit_count + 1;

            end

            9:
            begin

                rx_data <= shift_reg;
                bit_count <= 10;
            end

            10:
            begin
                receiving <= 0;
                busy <= 0;
                done <= 1;

            end

            endcase

        end

    end
end
endmodule