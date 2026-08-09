module spi_chip_select
(
    input wire clk,
    input wire rst,
    input wire start,
    input wire transfer_done,

    output reg cs_n,
    output reg busy
);

// Chip Select Control
always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        cs_n <= 1'b1;
        busy <= 1'b0;

    end

    else
    begin

        // Start Transfer
        if(start)
        begin

            cs_n <= 1'b0;
            busy <= 1'b1;

        end

        // End Transfer
        else if(transfer_done)
        begin

            cs_n <= 1'b1;
            busy <= 1'b0;

        end
    end
end
endmodule