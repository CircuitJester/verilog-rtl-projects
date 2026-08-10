module dma_transfer_counter
(
    input wire clk,
    input wire rst,

    input wire load,
    input wire decrement,
    input wire [15:0] transfer_length,

    output reg [15:0] count,
    output wire transfer_done
);

// Transfer Counter
always @(posedge clk or posedge rst)
begin

    if(rst)
        count <= 16'd0;

    else if(load)

        count <= transfer_length;

    else if(decrement && count != 0)
        count <= count - 1;

end

// Transfer Complete Signal
assign transfer_done = (count == 0);

endmodule