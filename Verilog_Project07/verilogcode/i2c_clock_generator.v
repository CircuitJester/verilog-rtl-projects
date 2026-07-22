module i2c_clock_generator(

    input clk,
    input rst,
    input [15:0] clk_divider,

    output reg scl

);
reg [15:0] clk_count;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        clk_count <= 16'd0;
        scl <= 1'b1;
    end

    else
    begin

        clk_count <= clk_count + 1;

        if(clk_count >= clk_divider)
        begin
            clk_count <= 16'd0;
            scl <= ~scl;
        end
    end
end
endmodule