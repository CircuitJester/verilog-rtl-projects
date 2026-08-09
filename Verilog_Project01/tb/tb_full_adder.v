module tb_full_adder;

reg a;
reg b;
reg cin;

wire sum;
wire cout;

full_adder dut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(0, tb_full_adder);

    a = 1'b0; b = 1'b0; cin = 1'b0; #10;
    a = 1'b0; b = 1'b0; cin = 1'b1; #10;
    a = 1'b0; b = 1'b1; cin = 1'b0; #10;
    a = 1'b0; b = 1'b1; cin = 1'b1; #10;
    a = 1'b1; b = 1'b0; cin = 1'b0; #10;
    a = 1'b1; b = 1'b0; cin = 1'b1; #10;
    a = 1'b1; b = 1'b1; cin = 1'b0; #10;
    a = 1'b1; b = 1'b1; cin = 1'b1; #10;

    $finish;
end

endmodule