`timescale 1ns/1ps

module tb_spi_master;

parameter DATA_WIDTH = 8;

reg clk;
reg rst;
reg start;
reg miso;
reg cpol;
reg [7:0] clk_divider;
reg [DATA_WIDTH-1:0] data_in;

wire spi_clk;
wire mosi;
wire busy;
wire cs;
wire [DATA_WIDTH-1:0] rx_data;


spi_master #(
    .DATA_WIDTH(DATA_WIDTH)
) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .miso(miso),
    .clk_divider(clk_divider),
    .cpol(cpol),
    .spi_clk(spi_clk),
    .mosi(mosi),
    .busy(busy),
    .cs(cs),
    .rx_data(rx_data)
);

always #5 clk = ~clk;

initial 
begin
    $dumpfile("spi_master.vcd");
    $dumpvars(0, tb_spi_master);
end

initial 
begin

    clk = 1'b0;
    rst = 1'b1;
    start = 1'b0;
    cpol = 1'b0;
    clk_divider = 8'd3;
    data_in = 8'b10110010;
    miso = 1'b0;

    #20;
    rst = 1'b0;

    #20;
    start = 1'b1;

    #10;
    start = 1'b0;

end

always @(posedge spi_clk) 
begin

    miso <= ~miso;
end

initial begin
    #500;
    $finish;
end

endmodule