module sdram_timing_generator #

(
parameter WAIT_CYCLES = 8

)
(
input wire clk,
input wire rst,
input wire start,

output reg done
);

reg [$clog2(WAIT_CYCLES):0] counter;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        counter <= 0;
        done <= 0;
    end
    else

    begin

        if(start)

        begin

            if(counter == WAIT_CYCLES-1)

            begin

                counter <= 0;
                done <= 1;
            end
            else

            begin

                counter <= counter + 1;
                done <= 0;
            end
        end

        else
        begin

            counter <= 0;
            done <= 0;
        end
    end
end
endmodule