module tb_vending_machine_fsm;

reg clk;
reg rst;
reg coin_5;
reg coin_10;
wire dispense;

vending_machine_fsm uut(
    .clk(clk),
    .rst(rst),
    .coin_5(coin_5),
    .coin_10(coin_10),
    .dispense(dispense)
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("vending_machine.vcd");
    $dumpvars(0,tb_vending_machine_fsm);

    rst = 1;
    coin_5 = 0;
    coin_10 = 0;

    #10 rst = 0;

    // Insert ₹5
    coin_5 = 1; #10;
    coin_5 = 0;

    // Insert another ₹5
    #10;
    coin_5 = 1; #10;
    coin_5 = 0;

    #20;

    $finish;

end
endmodule