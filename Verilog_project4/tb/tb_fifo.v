module tb_fifo;

reg clk;
reg rst;
reg wr_en;
reg rd_en;

reg [7:0] data_in;
wire [7:0] data_out;

wire full;
wire empty;

fifo uut(

    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),

    .data_in(data_in),
    .data_out(data_out),

    .full(full),
    .empty(empty)
);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    $dumpfile("fifo.vcd");
    $dumpvars(0,tb_fifo);

    rst = 1;

    wr_en = 0;
    rd_en = 0;

    data_in = 0;

    #10;

    rst = 0;

    // Write four values
    wr_en = 1;

    data_in = 8'd12; #10;
    data_in = 8'd25; #10;
    data_in = 8'd45; #10;
    data_in = 8'd99; #10;

    wr_en = 0;

    // Read four values
    #10;

    rd_en = 1;

    #40;

    rd_en = 0;

    #20;

    $finish;

end
endmodule