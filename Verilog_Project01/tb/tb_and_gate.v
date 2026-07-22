module tb_and_gate;

reg a;
reg b;
wire y;

and_gate uut(
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    a=0; b=0;
    #10;

    a=0; b=1;
    #10;

    a=1; b=0;
    #10;

    a=1; b=1;
    #10;

    $finish;
end

initial begin
    $dumpfile("and_gate.vcd");
    $dumpvars(0,tb_and_gate);
end

endmodule