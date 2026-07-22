module tb_johnson_counter_4bit;

reg clk;
reg rst;

wire [3:0] q;

johnson_counter_4bit uut(
    .clk(clk),
    .rst(rst),
    .q(q)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("johnson_counter.vcd");
    $dumpvars(0,tb_johnson_counter_4bit);

    rst = 1;
    #10;

    rst = 0;

    #100;

    $finish;

end

endmodule