module tb_timer;

reg clk;
reg rst;
reg enable;
reg [7:0] period;

wire timeout;

timer uut(

    .clk(clk),
    .rst(rst),
    .enable(enable),
    .period(period),
    .timeout(timeout)

);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    $dumpfile("timer.vcd");
    $dumpvars(0,tb_timer);
    rst = 1;
    enable = 0;
    period = 8'd9;

    #10;
    rst = 0;
    enable = 1;

    #250;

    $finish;

end
endmodule