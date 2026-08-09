module tb_shift_register_4bit;

reg clk;
reg rst;
reg serial_in;
wire [3:0] q;

shift_register_4bit dut (
    .clk(clk),
    .rst(rst),
    .serial_in(serial_in),
    .q(q)
);

initial begin

    clk = 1'b0;
    forever #5 clk = ~clk;
    
end

initial begin

    $dumpfile("shift_register_4bit.vcd");
    $dumpvars(0, tb_shift_register_4bit);

    rst = 1'b1;
    serial_in = 1'b0;

    #10;
    rst = 1'b0;

    serial_in = 1'b1; #10;
    serial_in = 1'b0; #10;
    serial_in = 1'b1; #10;
    serial_in = 1'b1; #10;

    $finish;
end

endmodule