module sdram_refresh_controller #

(

parameter REFRESH_PERIOD = 16
)
(

input wire clk,
input wire rst,

output reg refresh_request
);

reg [$clog2(REFRESH_PERIOD):0] counter;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        counter <= 0;
        refresh_request <= 0;
    end

    else

    begin

        if(counter == REFRESH_PERIOD-1)

        begin

            counter <= 0;
            refresh_request <= 1;
        end

        else

        begin

            counter <= counter + 1;
            refresh_request <= 0;
        end
    end
end
endmodule