module tb_binary_counter_4bit;

reg clk;
reg rst;

wire [3:0] q;

binary_counter_4bit uut(
    .clk(clk),
    .rst(rst),
    .q(q)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("binary_counter.vcd");
    $dumpvars(0,tb_binary_counter_4bit);

    rst = 1;
    #10;

    rst = 0;

    #180;

    $finish;

end
endmodule