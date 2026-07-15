module tb_alu_4bit;

reg [3:0] a;
reg [3:0] b;
reg [2:0] sel;

wire [3:0] result;
wire carry;

alu_4bit uut(
    .a(a),
    .b(b),
    .sel(sel),
    .result(result),
    .carry(carry)
);

initial begin

    $dumpfile("alu4.vcd");
    $dumpvars(0,tb_alu_4bit);

    a = 4'b0101;
    b = 4'b0011;

    sel=3'b000; #10;
    sel=3'b001; #10;
    sel=3'b010; #10;
    sel=3'b011; #10;
    sel=3'b100; #10;
    sel=3'b101; #10;
    sel=3'b110; #10;
    sel=3'b111; #10;

    $finish;
end

endmodule