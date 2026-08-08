module spi_bit_counter(

    input clk,
    input rst,
    input enable,

    output reg [2:0] bit_count,
    output done
);

assign done = (bit_count == 3'd7);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        bit_count <= 3'd0; //because we are counting from 0 to 7 we need 3 bits  
    end

    else if(enable)
    begin

        if(bit_count == 3'd7)
            bit_count <= 3'd0;

        else
            bit_count <= bit_count + 1;

    end
end
endmodule