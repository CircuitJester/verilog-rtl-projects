module spi_chip_select(

input wire clk,
input wire rst,
input wire cs_enable,

output reg cs_n
);

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        cs_n <= 1'b1;

    end
    else

    begin

        if(cs_enable)
            cs_n <= 1'b0;

        else

            cs_n <= 1'b1;

    end
end
endmodule