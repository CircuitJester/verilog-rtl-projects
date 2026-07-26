module axi_slave_read_data #

(

parameter DATA_WIDTH = 32
)
(

input wire clk,
input wire rst,
input wire [DATA_WIDTH-1:0] register_data,
input wire data_available,
input wire rready,

output reg [DATA_WIDTH-1:0] rdata,
output reg rvalid
);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        rdata <= {DATA_WIDTH{1'b0}};
        rvalid <= 1'b0;

    end

    else
    begin

        if(data_available)
        begin

            rdata <= register_data;

            rvalid <= 1'b1;

        end

        else if(rready)
        begin

            rvalid <= 1'b0;

        end
    end
end
endmodule