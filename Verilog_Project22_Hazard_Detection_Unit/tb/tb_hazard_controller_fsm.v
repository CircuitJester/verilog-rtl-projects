`timescale 1ns/1ps

module tb_hazard_controller_fsm;

// Inputs
reg clk;
reg rst;
reg stall;

// Outputs
wire pipeline_hold;
wire busy;

// DUT
hazard_controller_fsm uut
(
    .clk(clk),
    .rst(rst),

    .stall(stall),
    .pipeline_hold(pipeline_hold),
    .busy(busy)
);

// Clock Generation
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test Sequence
initial
begin

    $dumpfile("waves/hazard_controller_fsm.vcd");
    $dumpvars(0, tb_hazard_controller_fsm);

    // Reset
    rst = 1;
    stall = 0;
    #20;

    rst = 0;

    // Test 1
    // No Hazard
    #20;

    // Test 2
    // Hazard Appears
    stall = 1;

    #40;

    // Test 3
    // Hazard Cleared
    stall = 0;

    #40;

    // Test 4
    // Hazard Again
    stall = 1;

    #30;

    // Test 5
    // Hazard Removed
    stall = 0;

    #40;

    $finish;

end

endmodule