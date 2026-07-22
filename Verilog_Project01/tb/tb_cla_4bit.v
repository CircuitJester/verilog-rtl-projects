module tb_cla_4bit;

reg [3:0] a;
reg [3:0] b;
reg cin;

wire [3:0] sum;
wire cout;

cla_4bit uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin

    $dumpfile("cla4.vcd");
    $dumpvars(0,tb_cla_4bit);

    a=4'b0000; b=4'b0000; cin=0; #10;
    a=4'b0001; b=4'b0001; cin=0; #10;
    a=4'b0011; b=4'b0010; cin=0; #10;
    a=4'b0101; b=4'b0011; cin=0; #10;
    a=4'b1111; b=4'b0001; cin=0; #10;

    $finish;
end

endmodule