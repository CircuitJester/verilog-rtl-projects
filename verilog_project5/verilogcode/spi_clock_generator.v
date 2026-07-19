module spi_clock_generator(

    input clk,
    input rst,

    output reg spi_clk

);

reg [1:0] clk_div;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        clk_div <= 2'd0;
        spi_clk <= 1'b0;
    end

    else
    begin

        if(clk_div == 2'd1)
        begin
            clk_div <= 2'd0;
            spi_clk <= ~spi_clk;
        end

        else
            clk_div <= clk_div + 1;

    end

end
endmodule