module i2c_start_stop(

input wire clk,
input wire rst,
input wire start_cmd,
input wire stop_cmd,
input wire scl,

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

        // Default
        busy <= 1'b0;

        // Generate START
        if(start_cmd && scl)

        begin

            sda <= 1'b0;
            busy <= 1'b1;
        end

        // Generate STOP
        else if(stop_cmd && scl)

        begin

            sda <= 1'b1;
            busy <= 1'b1;

        end

    end
end
endmodule