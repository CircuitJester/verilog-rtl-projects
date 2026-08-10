module axi_write_channel
(
    input wire clk,
    input wire rst,
    input wire awvalid,
    input wire wvalid,
    input wire bready,
    input wire address_valid,

    output reg awready,
    output reg wready,
    output reg bvalid,
    output reg write_enable
);

// Write Handshake
always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        awready <= 0;
        wready <= 0;
        bvalid <= 0;
        write_enable <= 0;

    end
    else

    begin
        write_enable <= 0;

        // Accept Write
        if(awvalid && wvalid && address_valid)

        begin

            awready <= 1;
            wready <= 1;
            write_enable <= 1;
            bvalid <= 1;

        end

        // Finish Transaction
        else if(bready)

        begin

            awready <= 0;
            wready <= 0;
            bvalid <= 0;

        end
    end

end
endmodule