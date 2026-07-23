module i2c_ack_generator(

    input scl,
    input rst,
    input ack_enable,
    input address_match,

    output reg ack

);

always @(posedge scl or posedge rst)
begin

    if(rst)
    begin

        ack <= 1'b1;

    end

    else if(ack_enable)
    begin

        if(address_match)
            ack <= 1'b0;

        else
            ack <= 1'b1;

    end

    else
    begin

        ack <= 1'b1;

    end
end
endmodule