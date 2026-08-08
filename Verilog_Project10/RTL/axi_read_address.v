module axi_read_address #

(

parameter ADDR_WIDTH = 32
)
(

input wire clk,
input wire rst,
input wire start,
input wire [ADDR_WIDTH-1:0] address,
input wire arready,

output reg [ADDR_WIDTH-1:0] araddr,
output reg arvalid,
output reg done
);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        araddr  <= 0;
        arvalid <= 0;
        done    <= 0;

    end

    else
    begin

        done <= 0;

        if(start)
        begin

            araddr  <= address;
            arvalid <= 1'b1;

        end

        if(arvalid && arready)
        begin

            arvalid <= 1'b0;
            done    <= 1'b1;

        end
    end
end
endmodule