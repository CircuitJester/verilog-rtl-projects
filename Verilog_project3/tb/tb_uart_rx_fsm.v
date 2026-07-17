module tb_uart_rx_fsm;

reg clk;
reg rst;
reg rx;
wire [7:0] data_out;
wire done;

uart_rx_fsm uut(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .done(done)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("uart_rx.vcd");
    $dumpvars(0,tb_uart_rx_fsm);

    rst = 1;
    rx = 1;
    #10 rst = 0;

    // Start bit
    rx = 0; #10;

    // Data bits for 10110010 (LSB first)
    rx = 0; #10; // D0
    rx = 1; #10; // D1
    rx = 0; #10; // D2
    rx = 0; #10; // D3
    rx = 1; #10; // D4
    rx = 1; #10; // D5
    rx = 0; #10; // D6
    rx = 1; #10; // D7

    // Stop bit
    rx = 1; #10;

    #20;
    $finish;

end
endmodule