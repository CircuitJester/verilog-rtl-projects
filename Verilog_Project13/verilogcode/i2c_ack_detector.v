module i2c_ack_detector(

input wire clk,
input wire rst,
input wire check_ack,
input wire sda,

output reg ack,
output reg error

);

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        ack <= 1'b0;
        error <= 1'b0;

    end

    else
    begin

        ack <= 1'b0;
        error <= 1'b0;

        // Check ACK
        if(check_ack)

        begin

            if(sda == 1'b0)

            begin

                ack <= 1'b1;
            end

            else

            begin

                error <= 1'b1;
            end

        end

    end
end
endmodule