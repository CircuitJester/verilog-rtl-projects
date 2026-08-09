module tb_uart_rx_fsm;

reg clk;
reg rst;
reg rx;

wire [7:0] data_out;
wire done;

uart_rx_fsm dut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .done(done)
);

initial 
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, tb_uart_rx_fsm);

    rst = 1'b1;
    rx = 1'b1;

    #10 rst = 1'b0;

    rx = 1'b0; #10;

    rx = 1'b0; #10;
    rx = 1'b1; #10;
    rx = 1'b0; #10;
    rx = 1'b0; #10;
    rx = 1'b1; #10;
    rx = 1'b1; #10;
    rx = 1'b0; #10;
    rx = 1'b1; #10;

    rx = 1'b1; #10;

    #20;
    $finish;
end

endmodule