module axi_slave_read_address #

(

parameter ADDR_WIDTH = 32
)

(

input wire clk,
input wire rst,
input wire [ADDR_WIDTH-1:0] araddr,
input wire arvalid,

output reg arready,
output reg [ADDR_WIDTH-1:0] address,
output reg address_valid
);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        arready <= 1'b0;
        address <= {ADDR_WIDTH{1'b0}};
        address_valid <= 1'b0;
    end

    else
    begin

        // Default outputs
        arready <= 1'b0;
        address_valid <= 1'b0;

        // Accept read address
        if(arvalid)
        begin

            arready <= 1'b1;
            address <= araddr;
            address_valid <= 1'b1;
        end
    end
end
endmodule