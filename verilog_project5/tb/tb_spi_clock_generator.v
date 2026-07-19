module tb_spi_clock_generator;

reg clk;
reg rst;
wire spi_clk;

spi_clock_generator uut(

    .clk(clk),
    .rst(rst),
    .spi_clk(spi_clk)
);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    $dumpfile("spi_clock.vcd");
    $dumpvars(0,tb_spi_clock_generator);

    rst = 1;

    #10;

    rst = 0;

    #200;

    $finish;

end
endmodule