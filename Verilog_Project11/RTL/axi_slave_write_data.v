module axi_slave_write_data #

(

parameter DATA_WIDTH = 32
)
(

input wire clk,
input wire rst,
input wire [DATA_WIDTH-1:0] wdata,
input wire wvalid,

output reg wready,
output reg [DATA_WIDTH-1:0] data,
output reg data_valid
);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        wready <= 1'b0;
        data <= {DATA_WIDTH{1'b0}};
        data_valid <= 1'b0;

    end
    else
    begin

        // Default outputs
        wready <= 1'b0;
        data_valid <= 1'b0;

        // Accept write data
        if(wvalid)
        begin

            wready <= 1'b1;

            data <= wdata;

            data_valid <= 1'b1;

        end
    end
end
endmodule