module axi_write_address #

(
parameter ADDR_WIDTH = 32

)
(

input wire clk,
input wire rst,
input wire start,
input wire [ADDR_WIDTH-1:0] address,
input wire awready,

output reg [ADDR_WIDTH-1:0] awaddr,
output reg awvalid,
output reg done

);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        awaddr  <= 0;
        awvalid <= 0;
        done    <= 0;
    end
    else
    begin

        done <= 0;

        if(start)
        begin

            awaddr  <= address;
            awvalid <= 1'b1;

        end

        if(awvalid && awready)
        begin

            awvalid <= 1'b0;
            done    <= 1'b1;

        end
    end
end
endmodule