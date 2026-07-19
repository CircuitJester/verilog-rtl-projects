module spi_shift_register(

    input clk,
    input rst,
    input load,
    input shift,
    input [7:0] data_in,

    output mosi,
    output reg [7:0] shift_reg

);

assign mosi = shift_reg[7];

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        shift_reg <= 8'd0;
    end

    else if(load)
    begin
        shift_reg <= data_in;
    end

    else if(shift)
    begin
        shift_reg <= {shift_reg[6:0],1'b0};
    end

end
endmodule