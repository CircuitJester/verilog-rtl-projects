module tb_traffic_light_fsm;

reg clk;
reg rst;

wire north_red;
wire north_yellow;
wire north_green;

wire south_red;
wire south_yellow;
wire south_green;

traffic_light_fsm uut(
    .clk(clk),
    .rst(rst),

    .north_red(north_red),
    .north_yellow(north_yellow),
    .north_green(north_green),

    .south_red(south_red),
    .south_yellow(south_yellow),
    .south_green(south_green)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("traffic_light.vcd");
    $dumpvars(0,tb_traffic_light_fsm);

    rst = 1;
    #10;

    rst = 0;

    #100;

    $finish;

end
endmodule