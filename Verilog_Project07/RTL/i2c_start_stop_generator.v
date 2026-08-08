module i2c_start_stop_generator(

    input clk,
    input rst,
    input start,
    input stop,

    output reg sda,
    output reg busy

);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        sda <= 1'b1;
        busy <= 1'b0;

    end

    else
    begin

        if(start)
        begin

            sda <= 1'b0;
            busy <= 1'b1;

        end

        else if(stop)
        begin

            sda <= 1'b1;
            busy <= 1'b0;

        end
    end
end
endmodule