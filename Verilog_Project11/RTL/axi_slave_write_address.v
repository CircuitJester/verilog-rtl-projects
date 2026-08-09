module axi_slave_write_address #(
    parameter ADDR_WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire [ADDR_WIDTH-1:0] awaddr,
    input wire awvalid,

    output reg awready,
    output reg [ADDR_WIDTH-1:0] address,
    output reg address_valid
);

always @(posedge clk or posedge rst) 

begin

    if (rst) begin
        awready <= 1'b0;
        address <= {ADDR_WIDTH{1'b0}};
        address_valid <= 1'b0;

    end else begin

        awready <= 1'b0;
        address_valid <= 1'b0;

        if (awvalid) begin
            awready <= 1'b1;
            address <= awaddr;
            address_valid <= 1'b1;
        end

    end

end

endmodule