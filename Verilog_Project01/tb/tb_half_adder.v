module tb_half_adder;

reg a;
reg b;
wire sum;
wire carry;

half_adder dut (
    .a(a),
    .b(b),
    .sum(sum),
    .carry(carry)
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
    $dumpfile("half_adder.vcd");
    $dumpvars(0, tb_half_adder);
end

endmodule