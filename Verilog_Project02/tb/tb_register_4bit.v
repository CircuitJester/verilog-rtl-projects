module tb_register_4bit;

reg clk;
reg rst;
reg [3:0] d;

wire [3:0] q;

register_4bit uut(
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("register_4bit.vcd");
    $dumpvars(0,tb_register_4bit);

    rst = 1;
    d = 4'b0000;

    #10;
    rst = 0;
    
    d = 4'b1010;
    #10;

    d = 4'b0101;
    #10;

    d = 4'b1111;
    #10;

    rst = 1;
    #10;

    rst = 0;
    d = 4'b0011;
    #10;

    $finish;
end
endmodule