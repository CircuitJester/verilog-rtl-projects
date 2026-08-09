module axi_write_response(

input wire clk,
input wire rst,
input wire [1:0] bresp,
input wire bvalid,

output reg bready,
output reg done,
output reg error

);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        bready <= 0;
        done   <= 0;
        error  <= 0;

    end

    else
    begin

        done  <= 0;
        error <= 0;

        if(bvalid)
        begin

            bready <= 1'b1;

            if(bresp == 2'b00)
                done <= 1'b1;
            else
                error <= 1'b1;

        end

        else
        begin

            bready <= 1'b0;

        end

    end
    
end
endmodule