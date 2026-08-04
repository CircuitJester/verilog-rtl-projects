module axi_read_channel
(
    input wire clk,
    input wire rst,
    input wire arvalid,
    input wire rready,
    input wire address_valid,

    output reg arready,
    output reg rvalid,
    output reg read_enable
);

// Read Handshake
always @(posedge clk or posedge rst)
begin

    if(rst)

    begin
        arready <= 0;
        rvalid <= 0;
        read_enable <= 0;

    end

    else
    begin

        read_enable <= 0;

        // Accept Read Request
        if(arvalid && address_valid)

        begin
            arready <= 1;
            read_enable <= 1;
            rvalid <= 1;

        end

        // Finish Read Transaction
        else if(rready)

        begin

            arready <= 0;
            rvalid <= 0;

        end

    end
end
endmodule