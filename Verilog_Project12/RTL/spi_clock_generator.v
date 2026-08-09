module spi_clock_generator #

(
parameter DIVIDER = 4

)
(

input wire clk,
input wire rst,

output reg spi_clk
);

// Counter

reg [31:0] counter;

// Clock Divider

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        counter <= 0;
        spi_clk <= 0;
    end

    else
    begin

        if(counter == (DIVIDER/2)-1)
        begin

            counter <= 0;
            spi_clk <= ~spi_clk;

        end

        else
        begin
            counter <= counter + 1;
        end
    end
end
endmodule