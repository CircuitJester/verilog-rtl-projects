`timescale 1ns/1ps

module tb_axi_master_top;

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;

reg clk;
reg rst;
reg start_write;
reg start_read;
reg [ADDR_WIDTH-1:0] write_address;
reg [ADDR_WIDTH-1:0] read_address;
reg [DATA_WIDTH-1:0] write_data;

reg awready;
reg wready;
reg [1:0] bresp;
reg bvalid;
reg arready;
reg [DATA_WIDTH-1:0] rdata;
reg rvalid;

wire [ADDR_WIDTH-1:0] awaddr;
wire awvalid;
wire [DATA_WIDTH-1:0] wdata;
wire wvalid;
wire bready;
wire [ADDR_WIDTH-1:0] araddr;
wire arvalid;
wire rready;
wire [DATA_WIDTH-1:0] data_out;
wire done;

axi_master_top #(

    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)

) dut (

    .clk(clk),
    .rst(rst),
    .start_write(start_write),
    .start_read(start_read),
    .write_address(write_address),
    .read_address(read_address),
    .write_data(write_data),
    .awready(awready),
    .wready(wready),
    .bresp(bresp),
    .bvalid(bvalid),
    .arready(arready),
    .rdata(rdata),
    .rvalid(rvalid),
    .awaddr(awaddr),
    .awvalid(awvalid),
    .wdata(wdata),
    .wvalid(wvalid),
    .bready(bready),
    .araddr(araddr),
    .arvalid(arvalid),
    .rready(rready),
    .data_out(data_out),
    .done(done)

);


always #5 clk = ~clk;


initial 

begin

    $dumpfile("waves/axi_master_top.vcd");
    $dumpvars(0, tb_axi_master_top);

    clk = 0;
    rst = 1;

    start_write = 0;
    start_read = 0;

    write_address = 32'h40001000;
    read_address  = 32'h40001004;
    write_data = 32'h12345678;

    awready = 0;
    wready  = 0;

    bresp  = 2'b00;
    bvalid = 0;

    arready = 0;

    rdata  = 32'hABCDEF12;
    rvalid = 0;

    #20;
    rst = 0;

    #20;
    start_write = 1;

    #10;
    start_write = 0;

    #20;
    awready = 1;

    #10;
    awready = 0;

    #20;
    wready = 1;

    #10;
    wready = 0;

    #20;
    bvalid = 1;

    #10;
    bvalid = 0;

    #40;
    start_read = 1;

    #10;
    start_read = 0;

    #20;
    arready = 1;

    #10;
    arready = 0;

    #20;
    rvalid = 1;

    #20;
    rvalid = 0;

    #100;

    $finish;
    
end

endmodule