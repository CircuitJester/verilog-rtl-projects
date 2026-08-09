module tb_spi_master_fsm;

reg clk;
reg rst;
reg start;
reg done;

wire load;
wire shift;
wire enable;
wire busy;

spi_master_fsm dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .load(load),
    .shift(shift),
    .enable(enable),
    .busy(busy)
);

initial 
begin

    clk = 1'b0;
    forever #5 clk = ~clk;
end


initial 
begin

    $dumpfile("spi_fsm.vcd");
    $dumpvars(0, tb_spi_master_fsm);

    rst = 1'b1;
    start = 1'b0;
    done = 1'b0;

    #10;
    rst = 1'b0;

    #10;
    start = 1'b1;

    #10;
    start = 1'b0;

    #50;
    done = 1'b1;

    #10;
    done = 1'b0;

    #30;
    $finish;

end

endmodule