module can_bit_stuffing #

(
parameter FRAME_WIDTH = 31

)
(

input  [FRAME_WIDTH-1:0] frame,

output reg [FRAME_WIDTH+6:0] stuffed_frame

);

integer i;
integer j;

reg previous_bit;
reg [2:0] count;

always @(*)
begin

    stuffed_frame = 0;
    previous_bit = frame[FRAME_WIDTH-1];
    count = 1;
    stuffed_frame[FRAME_WIDTH+6] = frame[FRAME_WIDTH-1];
    j = FRAME_WIDTH + 5;

    for(i = FRAME_WIDTH-2; i >= 0; i = i - 1)
    begin

        if(frame[i] == previous_bit)
        begin

            count = count + 1;
            stuffed_frame[j] = frame[i];
            j = j - 1;

            if(count == 5)
            begin

                stuffed_frame[j] = ~previous_bit;
                j = j - 1;
                count = 0;

            end

        end

        else
        begin

            previous_bit = frame[i];
            count = 1;
            stuffed_frame[j] = frame[i];
            j = j - 1;

        end
    end
end
endmodule