module i2c_clock_generator #

(

parameter DIVIDER = 250
)
(

input wire clk,
input wire rst,

output reg scl
);

// Counter
reg [15:0] counter;

// Clock Divider
always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        counter <= 16'd0;
        scl <= 1'b1;

    end

    else
    begin

        if(counter == DIVIDER-1)
        begin

            counter <= 16'd0;
            scl <= ~scl;

        end

        else
        begin

            counter <= counter + 1'b1;
        end

    end
end
endmodule