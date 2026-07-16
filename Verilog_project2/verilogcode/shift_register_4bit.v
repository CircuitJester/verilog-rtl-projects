module shift_register_4bit(
    input clk,
    input rst,
    input serial_in,
    output reg [3:0] q
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        q <= 4'b0000;
    else
        q <= {q[2:0], serial_in};
end

endmodule