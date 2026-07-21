module spi_clock_generator(

    input clk,
    input rst,
    input [7:0] clk_divider,    
    input cpol,

    output reg spi_clk

);

reg [7:0] clk_count;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        clk_count <= 0;
        spi_clk <= cpol;
    end

    else
    begin

        clk_count <= clk_count + 1;

        if(clk_count >= clk_divider)
    begin
        clk_count <= 0;
        spi_clk <= ~spi_clk;
    end
    end
end
endmodule