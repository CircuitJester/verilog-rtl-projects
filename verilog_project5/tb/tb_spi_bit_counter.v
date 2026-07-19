module tb_spi_bit_counter;

reg clk;
reg rst;
reg enable;
wire [2:0] bit_count;
wire done;

spi_bit_counter uut(

    .clk(clk),
    .rst(rst),
    .enable(enable),
    .bit_count(bit_count),
    .done(done)

);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    $dumpfile("spi_counter.vcd");
    $dumpvars(0,tb_spi_bit_counter);

    rst = 1;
    enable = 0;
    #10;

    rst = 0;
    enable = 1;
    #100;

    $finish;

end
endmodule