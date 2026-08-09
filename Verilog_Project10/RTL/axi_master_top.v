module axi_master_top #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
    
) (
    input  wire clk,
    input  wire rst,
    input  wire start_write,
    input  wire start_read,
    input  wire [ADDR_WIDTH-1:0] write_address,
    input  wire [ADDR_WIDTH-1:0] read_address,
    input  wire [DATA_WIDTH-1:0] write_data,

    input  wire awready,
    input  wire wready,
    input  wire [1:0] bresp,
    input  wire bvalid,
    input  wire arready,
    input  wire [DATA_WIDTH-1:0] rdata,
    input  wire rvalid,

    output wire [ADDR_WIDTH-1:0] awaddr,
    output wire awvalid,
    output wire [DATA_WIDTH-1:0] wdata,
    output wire wvalid,
    output wire bready,
    output wire [ADDR_WIDTH-1:0] araddr,
    output wire arvalid,
    output wire rready,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire done

);


wire aw_start;
wire w_start;
wire ar_start;

wire aw_done;
wire w_done;
wire b_done;
wire ar_done;
wire r_done;

wire error;

axi_master_fsm fsm (

    .clk(clk),
    .rst(rst),
    .start_write(start_write),
    .start_read(start_read),
    .aw_done(aw_done),
    .w_done(w_done),
    .b_done(b_done),
    .ar_done(ar_done),
    .r_done(r_done),
    .aw_start(aw_start),
    .w_start(w_start),
    .ar_start(ar_start),
    .done(done)
);

axi_write_address #(

    .ADDR_WIDTH(ADDR_WIDTH)
) write_address_inst (

    .clk(clk),
    .rst(rst),
    .start(aw_start),
    .address(write_address),
    .awready(awready),
    .awaddr(awaddr),
    .awvalid(awvalid),
    .done(aw_done)
);

axi_write_data #(

    .DATA_WIDTH(DATA_WIDTH)
) write_data_inst (

    .clk(clk),
    .rst(rst),
    .start(w_start),
    .data(write_data),
    .wready(wready),
    .wdata(wdata),
    .wvalid(wvalid),
    .done(w_done)
);

axi_write_response write_response_inst (

    .clk(clk),
    .rst(rst),
    .bresp(bresp),
    .bvalid(bvalid),
    .bready(bready),
    .done(b_done),
    .error(error)
);

axi_read_address #(
    .ADDR_WIDTH(ADDR_WIDTH)

) read_address_inst (

    .clk(clk),
    .rst(rst),
    .start(ar_start),
    .address(read_address),
    .arready(arready),
    .araddr(araddr),
    .arvalid(arvalid),
    .done(ar_done)

);

axi_read_data #(

    .DATA_WIDTH(DATA_WIDTH)

) read_data_inst (
    .clk(clk),
    .rst(rst),
    .rdata(rdata),
    .rvalid(rvalid),
    .rready(rready),
    .data_out(data_out),
    .done(r_done)
);


endmodule