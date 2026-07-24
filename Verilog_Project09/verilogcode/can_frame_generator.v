module can_frame_generator #

(

parameter ID_WIDTH = 11,
parameter DATA_WIDTH = 8

)

(

input load,
input [ID_WIDTH-1:0] identifier,
input [DATA_WIDTH-1:0] data,

output reg [30:0] frame

);

// Frame Format

// [30]      SOF(State of frame)

// [29:19]   Identifier

// [18:15]   DLC(Data Length Code) 
// [14:7]    Data

// [6:0]     EOF

always @(*)
begin

    if(load)
    begin

        frame[30]    = 1'b0;
        frame[29:19] = identifier;
        frame[18:15] = 4'd1;
        frame[14:7]  = data;
        frame[6:0]   = 7'b1111111;

    end

    else
    begin

        frame = 31'd0;

    end
end
endmodule