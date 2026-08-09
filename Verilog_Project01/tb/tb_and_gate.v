module tb_and_gate;

reg a;
reg b;
wire y;

and_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    a = 1'b0;
    b = 1'b0;
    #10;

    a = 1'b0;
    b = 1'b1;
    #10;

    a = 1'b1;
    b = 1'b0;
    #10;

    a = 1'b1;
    b = 1'b1;
    #10;

    $finish;
end

initial begin
    $dumpfile("and_gate.vcd");
    $dumpvars(0, tb_and_gate);
end

endmodule