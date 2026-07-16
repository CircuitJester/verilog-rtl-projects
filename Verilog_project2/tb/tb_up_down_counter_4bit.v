module tb_up_down_counter_4bit;

reg clk;
reg rst;
reg up_down;

wire [3:0] q;

up_down_counter_4bit uut(
    .clk(clk),
    .rst(rst),
    .up_down(up_down),
    .q(q)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("up_down_counter.vcd");
    $dumpvars(0,tb_up_down_counter_4bit);

    rst = 1;
    up_down = 1;

    #10;
    rst = 0;

    // Count up
    #50;

    // Count down
    up_down = 0;

    #50;

    $finish;
end
endmodule