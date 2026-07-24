module can_crc_generator #(

parameter FRAME_WIDTH = 31

)

(

input [FRAME_WIDTH-1:0] frame,

output reg [7:0] crc

);

integer i;

always @(*)
begin

    crc = 8'h00;

    for(i=0;i<FRAME_WIDTH;i=i+1)
    begin

        crc = crc ^ frame[i];

    end
end
endmodule