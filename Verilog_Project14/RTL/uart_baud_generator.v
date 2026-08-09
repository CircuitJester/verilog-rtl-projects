module uart_baud_generator #

(

parameter DIVIDER = 16
)
(
input wire clk,
input wire rst,

output reg baud_tick

);

// Counter
reg [31:0] counter;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        counter <= 0;
        baud_tick <= 0;

    end
    else

    begin

        if(counter == DIVIDER-1)

        begin

            counter <= 0;
            baud_tick <= 1'b1;

        end
        else

        begin

            counter <= counter + 1'b1;
            baud_tick <= 1'b0;

        end

    end
end
endmodule