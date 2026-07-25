module axi_read_data #

(

parameter DATA_WIDTH = 32
)

(
input wire clk,
input wire rst,
input wire [DATA_WIDTH-1:0] rdata,
input wire rvalid,

output reg rready,
output reg [DATA_WIDTH-1:0] data_out,
output reg done

);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        rready   <= 0;
        data_out <= 0;
        done     <= 0;

    end

    else
    begin

        done <= 0;

        if(rvalid)
        begin

            rready   <= 1'b1;
            data_out <= rdata;
            done     <= 1'b1;

        end

        else
        begin

            rready <= 1'b0;

        end
    end
end
endmodule