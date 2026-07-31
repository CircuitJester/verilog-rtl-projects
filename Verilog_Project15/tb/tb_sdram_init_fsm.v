`timescale 1ns/1ps

module tb_sdram_init_fsm;

// Inputs
reg clk;
reg rst;
reg delay_done;

// Outputs
wire start_delay;
wire precharge;
wire refresh;
wire load_mode;
wire init_done;

// DUT
sdram_init_fsm uut
(
    .clk(clk),
    .rst(rst),

    .delay_done(delay_done),
    .start_delay(start_delay),
    .precharge(precharge),
    .refresh(refresh),
    .load_mode(load_mode),
    .init_done(init_done)
);

// Clock Generation
always #5 clk = ~clk;

// Test Sequence
initial
begin

    $dumpfile("waves/sdram_init_fsm.vcd");
    $dumpvars(0, tb_sdram_init_fsm);

    clk = 0;
    rst = 1;
    delay_done = 0;

    // Reset
    #20;
    rst = 0;

    // Power-up delay complete
    #80;
    delay_done = 1;
    #10;
    delay_done = 0;

    #150;
    $finish;

end
endmodule