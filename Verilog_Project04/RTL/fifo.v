module fifo(

    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,

    output reg [7:0] data_out,
    output full,
    output empty

);

reg [7:0] memory [0:3];

reg [1:0] wr_ptr;
reg [1:0] rd_ptr;
reg [2:0] count;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;
        data_out <= 0;
    end

    else
    begin

        // Write
        if(wr_en && !full)
        begin
            memory[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end

        // Read     
        if(rd_en && !empty)
        begin
            data_out <= memory[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end

    end

end

assign full  = (count == 4);
assign empty = (count == 0);
endmodule