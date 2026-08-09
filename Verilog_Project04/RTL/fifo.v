module fifo (
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
    if (rst) begin
        wr_ptr   <= 2'd0;
        rd_ptr   <= 2'd0;
        count    <= 3'd0;
        data_out <= 8'd0;
    end else begin
        if (wr_en && !full) begin
            memory[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1'b1;
            count <= count + 1'b1;
        end

        if (rd_en && !empty) begin
            data_out <= memory[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
            count <= count - 1'b1;

        end
    end
end

assign full  = (count == 3'd4);
assign empty = (count == 3'd0);

endmodule