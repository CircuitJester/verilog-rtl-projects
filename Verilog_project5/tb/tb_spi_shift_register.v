module tb_spi_shift_register;

reg clk;
reg rst;
reg load;
reg shift;
reg [7:0] data_in;
wire mosi;
wire [7:0] shift_reg;

spi_shift_register uut(

    .clk(clk),
    .rst(rst),
    .load(load),
    .shift(shift),
    .data_in(data_in),
    .mosi(mosi),
    .shift_reg(shift_reg)

);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    $dumpfile("spi_shift.vcd");
    $dumpvars(0,tb_spi_shift_register);

    rst = 1;
    load = 0;
    shift = 0;
    data_in = 8'b10110010;

    #10;
    rst = 0;
    load = 1;

    #10;
    load = 0;

    repeat(8)
    begin
        shift = 1;
        #10;
    end

    shift = 0;

    #20;

    $finish;

end
endmodule