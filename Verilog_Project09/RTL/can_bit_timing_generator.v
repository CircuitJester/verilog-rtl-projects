module can_bit_timing_generator #(
    parameter CLK_DIVIDER = 4
)(
    input wire clk,
    input wire rst,

    output reg can_clk
);

reg [7:0] clk_count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        clk_count <= 8'd0;
        can_clk   <= 1'b0;
    end
    else
    begin
        if(clk_count == CLK_DIVIDER-1)
        begin
            clk_count <= 8'd0;
            can_clk   <= ~can_clk;
        end
        else
        begin
            clk_count <= clk_count + 1'b1;
        end
    end
end
endmodule