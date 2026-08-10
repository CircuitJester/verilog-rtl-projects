module dma_control_register
(
    input wire clk,
    input wire rst,
    input wire start,
    input wire dma_busy,
    input wire dma_done,

    output reg start_reg,
    output reg busy_reg,
    output reg done_reg
);

// Control Register
always @(posedge clk or posedge rst)
begin

    if(rst)

    begin

        start_reg <= 0;
        busy_reg  <= 0;
        done_reg  <= 0;

    end
    else

    begin

        // Capture START Command
        start_reg <= start;

        // DMA Status
        busy_reg <= dma_busy;
        done_reg <= dma_done;

    end

end
endmodule