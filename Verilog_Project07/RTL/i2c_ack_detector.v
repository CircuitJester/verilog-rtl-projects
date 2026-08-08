module i2c_ack_detector(

    input scl,
    input rst,
    input ack_enable,
    input sda,

    output reg ack_received

);

always @(posedge scl or posedge rst)
begin

    if(rst)
    begin

        ack_received <= 0;

    end

    else if(ack_enable)
    begin

        if(sda == 1'b0)
            ack_received <= 1'b1;

        else
            ack_received <= 1'b0;

    end
end
endmodule