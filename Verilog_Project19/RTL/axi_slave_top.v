module axi_slave_top
(
    input wire clk,
    input wire rst,

    // Write Interface
    input wire awvalid,
    input wire wvalid,
    input wire bready,

    // Read Interface
    input wire arvalid,
    input wire rready,


    // Address/Data Interface
    input wire [31:0] address,
    input wire [31:0] write_data,

    output wire [31:0] read_data,

    // AXI Outputs

    output wire awready,
    output wire wready,
    output wire bvalid,
    output wire arready,
    output wire rvalid
);

// Internal Signals
wire [1:0] reg_select;
wire address_valid;
wire write_enable;
wire read_enable;

// Address Decoder
address_decoder decoder
(
    .address(address),
    .reg_select(reg_select),
    .valid(address_valid)
);

// Register File
register_file regfile
(
    .clk(clk),
    .rst(rst),

    .write_enable(write_enable),
    .write_addr(reg_select),
    .write_data(write_data),

    .read_addr(reg_select),
    .read_data(read_data)
);

// Write Channel
axi_write_channel write_ctrl
(
    .clk(clk),
    .rst(rst),
    .awvalid(awvalid),

    .wvalid(wvalid),
    .bready(bready),
    .address_valid(address_valid),
    .awready(awready),

    .wready(wready),
    .bvalid(bvalid),
    .write_enable(write_enable)
);

// Read Channel
axi_read_channel read_ctrl
(
    .clk(clk),
    .rst(rst),

    .arvalid(arvalid),

    .rready(rready),
    .address_valid(address_valid),
    .arready(arready),
    .rvalid(rvalid),
    .read_enable(read_enable)
);

endmodule