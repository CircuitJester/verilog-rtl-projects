`timescale 1ns/1ps

module tb_axi_master_fsm;

reg clk;
reg rst;
reg start_write;
reg start_read;
reg aw_done;
reg w_done;
reg b_done;
reg ar_done;
reg r_done;

wire aw_start;
wire w_start;
wire ar_start;
wire done;

axi_master_fsm uut(

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

always #5 clk = ~clk;

initial
begin

    $dumpfile("waves/axi_master_fsm.vcd");
    $dumpvars(0,tb_axi_master_fsm);

    clk = 0;
    rst = 1;

    start_write = 0;
    start_read  = 0;

    aw_done = 0;
    w_done  = 0;
    b_done  = 0;
    ar_done = 0;
    r_done  = 0;

    // Reset

    #20 rst = 0;

    // Write Transaction
    
    #10 start_write = 1;
    #10 start_write = 0;
    #20 aw_done = 1;
    #10 aw_done = 0;
    #20 w_done = 1;
    #10 w_done = 0;
    #20 b_done = 1;
    #10 b_done = 0;

    // Read Transaction
    
    #30 start_read = 1;
    #10 start_read = 0;
    #20 ar_done = 1;
    #10 ar_done = 0;
    #20 r_done = 1;
    #10 r_done = 0;

    #50;

    $finish;

end
endmodule