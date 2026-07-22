module tb_sequence_detector_1011;

reg clk;
reg rst;
reg din;
wire detected;

sequence_detector_1011 uut(
    .clk(clk),
    .rst(rst),
    .din(din),
    .detected(detected)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("sequence_detector.vcd");
    $dumpvars(0,tb_sequence_detector_1011);

    rst = 1;
    din = 0;

    #10 rst = 0;

    din = 1; #10;
    din = 0; #10;
    din = 1; #10;
    din = 1; #10;

    #20;

    $finish;
end
endmodule