module spi_clock_divider
#(
    parameter DIVIDER = 4
)
(
    input  wire clk,
    input  wire rst,

    output reg spi_clk
);

reg [31:0] counter;

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