module dma_address_generator
(
    input wire clk,
    input wire rst,

    input wire load,
    input wire increment,
    input wire [31:0] src_addr_in,
    input wire [31:0] dst_addr_in,

    output reg [31:0] src_addr,
    output reg [31:0] dst_addr
);

// Address Generator
always @(posedge clk or posedge rst)
begin

    if(rst)

    begin

        src_addr <= 32'd0;
        dst_addr <= 32'd0;

    end
    else if(load)

    begin

        src_addr <= src_addr_in;
        dst_addr <= dst_addr_in;

    end
    else if(increment)

    begin

        src_addr <= src_addr + 32'd4;
        dst_addr <= dst_addr + 32'd4;

    end

end
endmodule