module axi_write_data #

(

parameter DATA_WIDTH = 32
)
(

input wire clk,
input wire rst,
input wire start,
input wire [DATA_WIDTH-1:0] data,
input wire wready,

output reg [DATA_WIDTH-1:0] wdata,
output reg wvalid,
output reg done

);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        wdata  <= 0;
        wvalid <= 0;
        done   <= 0;

    end

    else
    begin

        done <= 0;

        if(start)
        begin

            wdata  <= data;
            wvalid <= 1'b1;

        end

        if(wvalid && wready)
        begin

            wvalid <= 1'b0;
            done   <= 1'b1;

        end
    end
end
endmodule