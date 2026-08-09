module tb_pwm_generator;

reg clk;
reg rst;
reg [7:0] duty;

wire pwm;

pwm_generator dut (
    .clk(clk),
    .rst(rst),
    .duty(duty),
    .pwm(pwm)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("pwm.vcd");
    $dumpvars(0, tb_pwm_generator);

    rst = 1'b1;
    duty = 8'd128;

    #10;
    rst = 1'b0;

    #3000;
    $finish;
end

endmodule