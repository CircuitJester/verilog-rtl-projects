module tb_d_flip_flop;

reg clk;
reg d;

wire q;

d_flip_flop uut(
    .clk(clk),
    .d(d),
    .q(q)
);

initial begin
    clk = 0;

    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("dff.vcd");
    $dumpvars(0, tb_d_flip_flop);

    d = 0; #10;
    d = 1; #10;
    d = 0; #10;
    d = 1; #10;

    $finish;

end
endmodule