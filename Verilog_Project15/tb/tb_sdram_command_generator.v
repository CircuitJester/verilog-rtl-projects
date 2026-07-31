`timescale 1ns/1ps

module tb_sdram_command_generator;

// Inputs
reg precharge;
reg refresh;
reg load_mode;
reg read_cmd;
reg write_cmd;
reg activate;

// Outputs
wire cs_n;
wire ras_n;
wire cas_n;
wire we_n;

// DUT
sdram_command_generator uut
(
    .precharge(precharge),
    .refresh(refresh),
    .load_mode(load_mode),
    .read_cmd(read_cmd),
    .write_cmd(write_cmd),
    .activate(activate),
    .cs_n(cs_n),
    .ras_n(ras_n),
    .cas_n(cas_n),
    .we_n(we_n)
);

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_command_generator.vcd");
    $dumpvars(0,tb_sdram_command_generator);

    // Default NOP
    precharge = 0;
    refresh = 0;
    load_mode = 0;
    read_cmd = 0;
    write_cmd = 0;
    activate = 0;

    #20;

    // ACTIVE
    activate = 1;
    #20;
    activate = 0;

    // READ
    read_cmd = 1;
    #20;
    read_cmd = 0;

    // WRITE
    write_cmd = 1;
    #20;
    write_cmd = 0;

    // PRECHARGE
    precharge = 1;
    #20;
    precharge = 0;

    // REFRESH
    refresh = 1;
    #20;
    refresh = 0;

    // LOAD MODE
    load_mode = 1;
    #20;
    load_mode = 0;

    #20;
    $finish;

end
endmodule