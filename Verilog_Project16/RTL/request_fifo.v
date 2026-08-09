module request_fifo(

input wire clk,
input wire rst,
input wire write_en,
input wire read_en,
input wire [1:0] data_in,

output reg [1:0] data_out,
output wire full,
output wire empty
);

parameter DEPTH = 4;

reg [1:0] fifo [0:DEPTH-1];
reg [1:0] write_ptr;
reg [1:0] read_ptr;
reg [2:0] count;


assign full  = (count == DEPTH);
assign empty = (count == 0);


always @(posedge clk or posedge rst)

begin
    if(rst)

    begin

        write_ptr <= 0;
        read_ptr <= 0;
        count <= 0;
        data_out <= 0;

    end

    else

    begin

        // Write
        if(write_en && !full)

        begin
            fifo[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            count <= count + 1;

        end

        // Read
        if(read_en && !empty)

        begin

            data_out <= fifo[read_ptr];
            read_ptr <= read_ptr + 1;
            count <= count - 1;

        end

    end
end
endmodule