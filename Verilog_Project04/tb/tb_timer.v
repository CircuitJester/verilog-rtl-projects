module tb_timer;

reg clk;
reg rst;
reg enable;
reg [7:0] period;

wire timeout;

timer dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .period(period),
    .timeout(timeout)
);

initial 
begin

    clk = 1'b0;
    forever #5 clk = ~clk;

end

initial 
begin

    $dumpfile("timer.vcd");
    $dumpvars(0, tb_timer);

    rst = 1'b1;
    enable = 1'b0;
    period = 8'd9;

    #10;
    rst = 1'b0;
    enable = 1'b1;

    #250;
    $finish;
    
end

endmodule