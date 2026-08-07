module clock_divider_by2(
    input clk,
    input rst,
    output reg clk_out
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        clk_out <= 1'b0;
    else
        clk_out <= ~clk_out;
end
endmodule