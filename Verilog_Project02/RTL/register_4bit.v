module register_4bit(
    input clk,
    input rst,
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        q <= 4'b0000;
    else
        q <= d;
end

endmodule