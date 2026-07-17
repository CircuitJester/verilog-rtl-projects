module tb_uart_tx_fsm;

reg clk;
reg rst;
reg start;

reg [7:0] data_in;
wire tx;
wire busy;

uart_tx_fsm uut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("uart_tx.vcd");
    $dumpvars(0,tb_uart_tx_fsm);

    rst = 1;
    start = 0;
    data_in = 8'b10110010;

    #10;
    rst = 0;

    #10;
    start = 1;

    #10;
    start = 0;

    #150;

    $finish;
end
endmodule