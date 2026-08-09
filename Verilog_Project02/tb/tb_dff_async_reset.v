module tb_dff_async_reset;

reg clk;
reg rst;
reg d;
wire q;

dff_async_reset dut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

initial begin

    clk = 1'b0;
    forever #5 clk = ~clk;
    
end

initial begin

    $dumpfile("dff_async_reset.vcd");
    $dumpvars(0, tb_dff_async_reset);

    rst = 1'b1;
    d = 1'b0;

    #10;
    rst = 1'b0;
    d = 1'b1;

    #10;
    d = 1'b0;

    #10;
    rst = 1'b1;

    #5;
    rst = 1'b0;
    d = 1'b1;

    #10;
    $finish;
end

endmodule