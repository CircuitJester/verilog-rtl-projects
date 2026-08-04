`timescale 1ns/1ps

module tb_register_file;


// Parameters
parameter DATA_WIDTH = 32;
parameter NUM_REGS   = 4;

// Inputs
reg clk;
reg rst;

reg write_enable;
reg [1:0] write_addr;
reg [DATA_WIDTH-1:0] write_data;
reg [1:0] read_addr;

// Outputs
wire [DATA_WIDTH-1:0] read_data;

// DUT
register_file
#(
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_REGS(NUM_REGS)
)
uut
(
    .clk(clk),
    .rst(rst),

    .write_enable(write_enable),
    .write_addr(write_addr),
    .write_data(write_data),
    .read_addr(read_addr),
    .read_data(read_data)
);

// Clock
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/register_file.vcd");
    $dumpvars(0, tb_register_file);

    clk = 0;
    rst = 1;

    write_enable = 0;
    write_addr = 0;
    write_data = 0;

    read_addr = 0;

    // Reset
    #20;
    rst = 0;

    // Write REG0
    #20;
    write_enable = 1;
    write_addr = 2'd0;
    write_data = 32'h12345678;
    #10;
    write_enable = 0;

    // Write REG1
    #20;
    write_enable = 1;
    write_addr = 2'd1;
    write_data = 32'hAAAAAAAA;
    #10;
    write_enable = 0;

    // Write REG2
    #20;
    write_enable = 1;
    write_addr = 2'd2;
    write_data = 32'h55555555;
    #10;
    write_enable = 0;

    // Write REG3
    #20;
    write_enable = 1;
    write_addr = 2'd3;
    write_data = 32'hDEADBEEF;
    #10;
    write_enable = 0;

    // Read REG0
    #20;
    read_addr = 2'd0;
    #20;

    // Read REG1
    read_addr = 2'd1;
    #20;

    // Read REG2
    read_addr = 2'd2;
    #20;

    // Read REG3
    read_addr = 2'd3;
    #20;

    $finish;

end
endmodule