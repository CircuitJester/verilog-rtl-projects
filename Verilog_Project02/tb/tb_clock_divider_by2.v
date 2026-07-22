module tb_clock_divider_by2;

reg clk;
reg rst;

wire clk_out;

clock_divider_by2 uut(
    .clk(clk),
    .rst(rst),
    .clk_out(clk_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("clock_divider.vcd");
    $dumpvars(0,tb_clock_divider_by2);

    rst = 1;
    #10;

    rst = 0;

    #100;
    $finish;
end
endmodule