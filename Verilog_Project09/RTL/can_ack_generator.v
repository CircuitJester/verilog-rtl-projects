module can_ack_generator(

input crc_valid,
input frame_received,

output reg ack

);

always @(*)
begin

    if(frame_received && crc_valid)
        ack = 1'b0;     // Dominant ACK
    else
        ack = 1'b1;     // Recessive (No ACK)

end
endmodule