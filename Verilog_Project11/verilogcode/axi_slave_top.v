module axi_slave_top #

(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)
(

    input wire clk,
    input wire rst,

    // Write Interface

    input wire [ADDR_WIDTH-1:0] write_address,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire write_enable,

    // Read Interface

    input wire [ADDR_WIDTH-1:0] read_address,

    output wire [DATA_WIDTH-1:0] read_data

);

// Register File

axi_register_file #

(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)
register_file_inst

(

    .clk(clk),
    .rst(rst),

    .write_address(write_address),
    .write_data(write_data),
    .write_enable(write_enable),
    .read_address(read_address),
    .read_data(read_data)

);

endmodule