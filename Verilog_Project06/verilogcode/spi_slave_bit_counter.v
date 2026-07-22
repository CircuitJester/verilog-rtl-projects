module spi_slave_bit_counter #(
    parameter DATA_WIDTH = 8
)(
    input spi_clk,
    input rst,
    input cs,

    output reg done,
    output reg [$clog2(DATA_WIDTH)-1:0] bit_count
);

always @(posedge spi_clk or posedge rst)
begin

    if(rst)
    begin
        bit_count <= 0;
        done <= 0;
    end

    else if(cs)
    begin
        bit_count <= 0;
        done <= 0;
    end

    else
    begin

        if(bit_count == DATA_WIDTH-1)
        begin
            bit_count <= 0;
            done <= 1;
        end

        else
        begin
            bit_count <= bit_count + 1;
            done <= 0;
        end
    end
end
endmodule